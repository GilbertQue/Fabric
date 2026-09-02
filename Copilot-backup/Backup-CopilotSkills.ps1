<#
.SYNOPSIS
    Backs up GitHub Copilot skills into this project folder and refreshes README.md.

.DESCRIPTION
    Copies:
      - %USERPROFILE%\.copilot\skills
      - %USERPROFILE%\.copilot\installed-plugins
    into:
      <ProjectRoot>\backup\skills
      <ProjectRoot>\backup\installed-plugins

    Also writes:
      - backup\manifest.json  (run metadata + skill inventory)
      - README.md             (skill list + restore instructions)

.PARAMETER ProjectRoot
    Root of the Copilot Skills Backup project. Defaults to parent of /scripts.

.PARAMETER SkipReadme
    If set, does not regenerate README.md (backup still runs).
#>
[CmdletBinding()]
param(
    [string]$ProjectRoot,
    [switch]$SkipReadme
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($ProjectRoot)) {
    if (-not [string]::IsNullOrWhiteSpace($PSScriptRoot)) {
        $ProjectRoot = Split-Path -Parent $PSScriptRoot
    } else {
        $ProjectRoot = Split-Path -Parent $PSCommandPath
    }
}
if ([string]::IsNullOrWhiteSpace($ProjectRoot)) {
    throw 'Could not determine ProjectRoot. Pass -ProjectRoot explicitly.'
}
$ProjectRoot = (Resolve-Path -LiteralPath $ProjectRoot).Path

function Write-Log {
    param([string]$Message, [string]$Level = 'INFO')
    $ts = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $line = "[$ts] [$Level] $Message"
    Write-Host $line
    if ($script:LogPath) {
        Add-Content -Path $script:LogPath -Value $line -Encoding UTF8
    }
}

function Get-SkillDescription {
    param([string]$SkillMdPath)
    if (-not (Test-Path -LiteralPath $SkillMdPath)) {
        return '(no SKILL.md)'
    }

    # Read as UTF-8 (with or without BOM)
    $raw = [System.IO.File]::ReadAllText($SkillMdPath, [System.Text.UTF8Encoding]::new($false))
    if ([string]::IsNullOrWhiteSpace($raw)) {
        return '(empty SKILL.md)'
    }

    $desc = $null

    # YAML frontmatter between --- fences
    if ($raw -match '(?ms)^---\s*\r?\n(.*?)\r?\n---') {
        $fm = $Matches[1]

        # Block scalar: description: >-  / >  / |  / |-  then indented lines
        if ($fm -match '(?ms)^description:\s*[>|][-+]?\s*\r?\n((?:[ \t]+.+\r?\n?)*)') {
            $block = $Matches[1]
            if (-not [string]::IsNullOrWhiteSpace($block)) {
                $desc = ($block -replace '(?m)^[ \t]+', '' -replace '\s+', ' ').Trim()
            }
        }

        # Single-line description (ignore bare >- / | markers)
        if ([string]::IsNullOrWhiteSpace($desc) -and $fm -match '(?m)^description:\s*(.+?)\s*$') {
            $candidate = $Matches[1].Trim().Trim('"').Trim("'")
            if ($candidate -notmatch '^[>|][-+]?$') {
                $desc = $candidate
            }
        }
    }

    # Fallback: first useful markdown body line
    if ([string]::IsNullOrWhiteSpace($desc)) {
        $lines = $raw -split '\r?\n'
        foreach ($line in $lines) {
            $t = $line.Trim()
            if ($t -and $t -notmatch '^---' -and $t -notmatch '^#' -and $t -notmatch '^(name|description|metadata|version):' -and $t -notmatch '^>') {
                $desc = $t
                break
            }
        }
    }

    if ([string]::IsNullOrWhiteSpace($desc)) {
        return '(no description found)'
    }

    if ($desc.Length -gt 220) {
        $desc = $desc.Substring(0, 217) + '...'
    }
    return $desc
}

function Write-Utf8File {
    param([string]$Path, [string]$Content)
    $utf8Bom = New-Object System.Text.UTF8Encoding $true
    [System.IO.File]::WriteAllText($Path, $Content, $utf8Bom)
}

function Copy-TreeRobocopy {
    param(
        [Parameter(Mandatory)][string]$Source,
        [Parameter(Mandatory)][string]$Destination,
        [string]$Label
    )

    if (-not (Test-Path -LiteralPath $Source)) {
        Write-Log "Source missing, skipping: $Source" 'WARN'
        return $false
    }

    New-Item -ItemType Directory -Path $Destination -Force | Out-Null

    $args = @(
        $Source,
        $Destination,
        '/MIR',
        '/R:1',
        '/W:1',
        '/NFL',
        '/NDL',
        '/NP',
        '/XD', '.git', '__pycache__', 'node_modules'
    )

    Write-Log "Copying $Label from '$Source' -> '$Destination'"
    $output = & robocopy @args
    $code = $LASTEXITCODE

    if ($code -ge 8) {
        Write-Log "robocopy failed for $Label with exit code $code" 'ERROR'
        $output | ForEach-Object { Write-Log $_ 'ERROR' }
        throw "Backup copy failed for $Label (robocopy exit $code)"
    }

    Write-Log "Copy complete for $Label (robocopy exit $code)"
    return $true
}

function Get-RelativePath {
    param([string]$BasePath, [string]$FullPath)

    $baseFull = [System.IO.Path]::GetFullPath($BasePath)
    $targetFull = [System.IO.Path]::GetFullPath($FullPath)
    $baseUri = New-Object System.Uri($baseFull.TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar) + [System.IO.Path]::DirectorySeparatorChar)
    $targetUri = New-Object System.Uri($targetFull)
    return [System.Uri]::UnescapeDataString($baseUri.MakeRelativeUri($targetUri).ToString()).Replace('/', [System.IO.Path]::DirectorySeparatorChar)
}

function Copy-McpConfigFiles {
    param(
        [Parameter(Mandatory)][string]$BackupRoot,
        [Parameter(Mandatory)][string]$UserProfileRoot
    )

    $destMcp = Join-Path $BackupRoot 'mcp'
    New-Item -ItemType Directory -Path $destMcp -Force | Out-Null

    $sources = @(
        @{ Source = Join-Path $env:APPDATA 'Code\User\mcp.json' },
        @{ Source = Join-Path $env:APPDATA 'Code\User\mcp.local.json' },
        @{ Source = Join-Path $env:USERPROFILE '.copilot\mcp.json' },
        @{ Source = Join-Path $env:USERPROFILE '.vscode\mcp.json' },
        @{ Source = Join-Path $env:LOCALAPPDATA 'Programs\Microsoft VS Code\User\mcp.json' }
    )

    $backedUp = @()
    foreach ($entry in $sources) {
        if (-not (Test-Path -LiteralPath $entry.Source)) {
            continue
        }

        $relativePath = Get-RelativePath -BasePath $UserProfileRoot -FullPath $entry.Source
        $destination = Join-Path $destMcp $relativePath
        $destinationDir = Split-Path -Parent $destination
        New-Item -ItemType Directory -Path $destinationDir -Force | Out-Null
        Copy-Item -LiteralPath $entry.Source -Destination $destination -Force

        Write-Log "Backed up MCP config: $($entry.Source) -> $destination"
        $backedUp += [pscustomobject]@{
            source = $entry.Source
            relativePath = $relativePath
            destination = $destination
        }
    }

    return $backedUp
}

function Get-SkillInventory {
    param([string]$SkillsPath)

    $items = @()
    if (-not (Test-Path -LiteralPath $SkillsPath)) {
        return $items
    }

    Get-ChildItem -LiteralPath $SkillsPath -Directory -ErrorAction SilentlyContinue |
        Sort-Object Name |
        ForEach-Object {
            $skillMd = Join-Path $_.FullName 'SKILL.md'
            $items += [pscustomobject]@{
                name        = $_.Name
                description = (Get-SkillDescription -SkillMdPath $skillMd)
                hasSkillMd  = (Test-Path -LiteralPath $skillMd)
                path        = $_.FullName
            }
        }

    return $items
}

function Get-PluginSkillInventory {
    param([string]$PluginsPath)

    $items = @()
    if (-not (Test-Path -LiteralPath $PluginsPath)) {
        return $items
    }

    Get-ChildItem -LiteralPath $PluginsPath -Recurse -Filter 'SKILL.md' -File -ErrorAction SilentlyContinue |
        Sort-Object FullName |
        ForEach-Object {
            $rel = $_.FullName.Substring($PluginsPath.TrimEnd('\').Length).TrimStart('\')
            $skillName = Split-Path (Split-Path $_.FullName -Parent) -Leaf
            $items += [pscustomobject]@{
                name        = $skillName
                relativePath = $rel
                description = (Get-SkillDescription -SkillMdPath $_.FullName)
            }
        }

    return $items
}

function Build-Readme {
    param(
        [string]$ReadmePath,
        [datetime]$BackupTime,
        [object[]]$Skills,
        [object[]]$PluginSkills,
        [object[]]$McpConfigs,
        [string]$SourceSkills,
        [string]$SourcePlugins,
        [string]$DestSkills,
        [string]$DestPlugins
    )

    $skillRows = ($Skills | ForEach-Object {
        $d = ($_.description -replace '\|', '\|')
        "| ``$($_.name)`` | $d |"
    }) -join "`n"

    if (-not $skillRows) {
        $skillRows = '| _(none found)_ | |'
    }

    $pluginUnique = $PluginSkills |
        Group-Object name |
        Sort-Object Name |
        ForEach-Object {
            $first = $_.Group | Select-Object -First 1
            $d = ($first.description -replace '\|', '\|')
            "| ``$($_.Name)`` | $d |"
        }
    $pluginRows = if ($pluginUnique) { $pluginUnique -join "`n" } else { '| _(none found)_ | |' }

    $mcpRows = if ($McpConfigs) {
        ($McpConfigs | ForEach-Object {
            $rel = $_.relativePath -replace '\\', '/'
            "| ``$rel`` | ``$($_.source)`` |"
        }) -join "`n"
    } else {
        '| _(none found)_ | |'
    }

    $content = @"
# Copilot Skills Backup

Daily backup of GitHub Copilot / VS Code agent **skills** and VS Code **MCP server configs** from this PC into this project folder.

| | |
|---|---|
| **Last backup** | $($BackupTime.ToString('yyyy-MM-dd HH:mm:ss')) |
| **Schedule** | Every day at **8:05 AM** (Windows Task Scheduler) |
| **Task name** | ``CopilotSkillsDailyBackup`` |
| **Source skills** | ``$SourceSkills`` |
| **Source plugins** | ``$SourcePlugins`` |
| **Source MCP configs** | ``%APPDATA%\Code\User\mcp.json`` and ``%USERPROFILE%\.copilot\mcp.json`` |
| **Backup skills** | ``backup\skills`` |
| **Backup plugins** | ``backup\installed-plugins`` |
| **Backup MCP configs** | ``backup\mcp`` |

---

## What is backed up

1. **User / resolved skills** - ``%USERPROFILE%\.copilot\skills``  
   These are the skill folders Copilot loads (including marketplace-resolved copies).
2. **Installed plugins (with embedded skills)** - ``%USERPROFILE%\.copilot\installed-plugins``  
   Plugin packs that ship their own ``SKILL.md`` definitions.
3. **VS Code / Copilot MCP configs** - ``%APPDATA%\Code\User\mcp.json`` and ``%USERPROFILE%\.copilot\mcp.json``  
   These are the local MCP server configuration files used by VS Code and Copilot.

Each run **mirrors** the sources into ``backup\`` (adds, updates, and removes files that no longer exist at the source). A machine-readable inventory is written to ``backup\manifest.json``. Logs append to ``logs\backup.log``.

---

## Skills inventory (from ``.copilot\skills``)

**Count:** $($Skills.Count)

| Skill | Description |
|-------|-------------|
$skillRows

---

## Plugin-embedded skills (from ``installed-plugins``)

Unique skill names discovered under installed plugins. **Count (unique):** $((($PluginSkills | Group-Object name).Count))

| Skill | Description |
|-------|-------------|
$pluginRows

---

## MCP config inventory (from VS Code / Copilot)

**Count:** $($McpConfigs.Count)

| Backup path | Source |
|------------|--------|
$mcpRows

---

## Manual backup

From PowerShell:

``````powershell
cd "$ProjectRoot"
.\scripts\Backup-CopilotSkills.ps1
``````

Optional:

``````powershell
# Backup only (do not rewrite README)
.\scripts\Backup-CopilotSkills.ps1 -SkipReadme
``````

---

## Schedule (daily 8:05 AM)

Register or refresh the Windows scheduled task:

``````powershell
cd "$ProjectRoot"
.\scripts\Register-CopilotSkillsBackupTask.ps1
``````

Useful checks:

``````powershell
Get-ScheduledTask -TaskName 'CopilotSkillsDailyBackup'
Get-ScheduledTaskInfo -TaskName 'CopilotSkillsDailyBackup'
# Run once now:
Start-ScheduledTask -TaskName 'CopilotSkillsDailyBackup'
``````

Unregister:

``````powershell
Unregister-ScheduledTask -TaskName 'CopilotSkillsDailyBackup' -Confirm:`$false
``````

---

## How to restore (new PC or recovery)

Use this when you move to another machine, reinstall VS Code / Copilot, or accidentally delete skills or MCP config files.

### Prerequisites on the target PC

1. Install **Visual Studio Code**.
2. Install the **GitHub Copilot** and **GitHub Copilot Chat** extensions (and any Fabric / Power BI agent extensions you use).
3. Sign in to GitHub / Microsoft accounts as you normally do for Copilot.
4. Copy this entire project folder to the new PC (OneDrive / git / USB - wherever you keep it).

### Option A - Full restore script (recommended)

On the **target** PC, open PowerShell and run:

``````powershell
cd "<path-to-this-project>"
# Preview only:
.\scripts\Restore-CopilotSkills.ps1 -WhatIf

# Apply restore:
.\scripts\Restore-CopilotSkills.ps1
``````

This copies:

- ``backup\skills\*`` -> ``%USERPROFILE%\.copilot\skills\``
- ``backup\installed-plugins\*`` -> ``%USERPROFILE%\.copilot\installed-plugins\``
- ``backup\mcp\*`` -> the original VS Code / Copilot MCP config locations

Then **fully quit and restart VS Code** so Copilot reloads skills and MCP server settings.

### Option B - Manual copy

1. Close VS Code completely (all windows).
2. Ensure these folders exist:
   - ``%USERPROFILE%\.copilot\skills``
   - ``%USERPROFILE%\.copilot\installed-plugins``
3. Copy contents:

``````powershell
`$src = "<path-to-this-project>\backup"
`$dst = "`$env:USERPROFILE\.copilot"
New-Item -ItemType Directory -Force -Path "`$dst\skills", "`$dst\installed-plugins" | Out-Null
robocopy "`$src\skills" "`$dst\skills" /E
robocopy "`$src\installed-plugins" "`$dst\installed-plugins" /E
``````

4. Restart VS Code.
5. In Copilot Chat, confirm skills appear (or ask the agent to list available skills).

### Option C - Restore a single skill

``````powershell
`$name = "sqldw-consumption-cli"   # example
`$src  = "<path-to-this-project>\backup\skills\`$name"
`$dst  = "`$env:USERPROFILE\.copilot\skills\`$name"
Copy-Item -Path `$src -Destination `$dst -Recurse -Force
``````

Restart VS Code after copying.

### After restore checklist

- [ ] ``%USERPROFILE%\.copilot\skills`` contains the expected skill folders  
- [ ] Plugin packs under ``installed-plugins`` are present if you use them  
- [ ] MCP config files under ``backup\mcp`` were restored to the original VS Code / Copilot locations  
- [ ] VS Code restarted  
- [ ] Copilot Chat can invoke a known skill (e.g. a Fabric or Power BI skill you use daily)  
- [ ] Re-register the daily backup task on the new PC: ``.\scripts\Register-CopilotSkillsBackupTask.ps1``

### Notes / caveats

- **Marketplace plugins** may also reinstall via Copilot's plugin UI; this backup is a safety net for local skill files and custom/direct installs.
- VS Code MCP configs are backed up as files, not as live server processes.

---

## Project layout

``````
Copilot Skills Backup/
  README.md                          # this file (auto-updated on backup)
  scripts/
    Backup-CopilotSkills.ps1         # daily backup + README refresh
    Restore-CopilotSkills.ps1        # restore to .copilot and VS Code MCP config locations
    Register-CopilotSkillsBackupTask.ps1
  backup/
    skills/                          # mirror of .copilot\skills
    installed-plugins/               # mirror of .copilot\installed-plugins
    mcp/                             # mirror of VS Code / Copilot MCP config files
    manifest.json                    # last run metadata + inventory
  logs/
    backup.log
``````

---

*Generated automatically by ``scripts\Backup-CopilotSkills.ps1`` on $($BackupTime.ToString('yyyy-MM-dd HH:mm:ss')).*
"@

    $content = $content.Replace('$ProjectRoot', $ProjectRoot)

    Write-Utf8File -Path $ReadmePath -Content $content
    Write-Log "README updated: $ReadmePath"
}

# -------------------- main --------------------
$backupRoot   = Join-Path $ProjectRoot 'backup'
$destSkills   = Join-Path $backupRoot 'skills'
$destPlugins  = Join-Path $backupRoot 'installed-plugins'
$logsDir      = Join-Path $ProjectRoot 'logs'
$manifestPath = Join-Path $backupRoot 'manifest.json'
$readmePath   = Join-Path $ProjectRoot 'README.md'

$sourceSkills  = Join-Path $env:USERPROFILE '.copilot\skills'
$sourcePlugins = Join-Path $env:USERPROFILE '.copilot\installed-plugins'

New-Item -ItemType Directory -Path $backupRoot, $logsDir -Force | Out-Null
$script:LogPath = Join-Path $logsDir 'backup.log'

$started = Get-Date
Write-Log "=== Copilot skills and MCP backup started ==="
Write-Log "ProjectRoot: $ProjectRoot"
Write-Log "User: $env:USERNAME"

Copy-TreeRobocopy -Source $sourceSkills  -Destination $destSkills  -Label 'skills' | Out-Null
Copy-TreeRobocopy -Source $sourcePlugins -Destination $destPlugins -Label 'installed-plugins' | Out-Null

$mcpConfigs = @(Copy-McpConfigFiles -BackupRoot $backupRoot -UserProfileRoot $env:USERPROFILE)

$skills       = @(Get-SkillInventory -SkillsPath $destSkills)
$pluginSkills = @(Get-PluginSkillInventory -PluginsPath $destPlugins)

$manifest = [ordered]@{
    backupTimeUtc     = $started.ToUniversalTime().ToString('o')
    backupTimeLocal   = $started.ToString('yyyy-MM-dd HH:mm:ss')
    computerName      = $env:COMPUTERNAME
    userName          = $env:USERNAME
    projectRoot       = $ProjectRoot
    sourceSkills      = $sourceSkills
    sourcePlugins     = $sourcePlugins
    destinationSkills = $destSkills
    destinationPlugins= $destPlugins
    sourceMcpConfigs  = @($mcpConfigs | ForEach-Object { $_.source })
    destinationMcp    = Join-Path $backupRoot 'mcp'
    mcpConfigCount    = $mcpConfigs.Count
    skillCount        = $skills.Count
    pluginSkillCount  = $pluginSkills.Count
    skills            = @($skills | ForEach-Object { [ordered]@{ name = $_.name; description = $_.description; hasSkillMd = $_.hasSkillMd } })
    pluginSkills      = @($pluginSkills | ForEach-Object { [ordered]@{ name = $_.name; relativePath = $_.relativePath; description = $_.description } })
    mcpConfigs        = @($mcpConfigs | ForEach-Object { [ordered]@{ source = $_.source; relativePath = $_.relativePath; destination = $_.destination } })
}

Write-Utf8File -Path $manifestPath -Content (($manifest | ConvertTo-Json -Depth 6))
Write-Log "Manifest written ($($skills.Count) skills, $($pluginSkills.Count) plugin SKILL.md files, $($mcpConfigs.Count) MCP config files)"

if (-not $SkipReadme) {
    Build-Readme -ReadmePath $readmePath -BackupTime $started `
        -Skills $skills -PluginSkills $pluginSkills -McpConfigs $mcpConfigs `
        -SourceSkills $sourceSkills -SourcePlugins $sourcePlugins `
        -DestSkills $destSkills -DestPlugins $destPlugins
}

$elapsed = (Get-Date) - $started
Write-Log "=== Backup finished in $([int]$elapsed.TotalSeconds)s ==="
exit 0
