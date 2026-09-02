<#
.SYNOPSIS
    Restores Copilot skills and VS Code MCP config files from this project's backup folder.

.PARAMETER ProjectRoot
    Root of the Copilot Skills Backup project. Defaults to parent of /scripts.

.PARAMETER WhatIf
    Show what would be copied without making changes.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$ProjectRoot
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

$backupRoot  = Join-Path $ProjectRoot 'backup'
$srcSkills   = Join-Path $backupRoot 'skills'
$srcPlugins  = Join-Path $backupRoot 'installed-plugins'
$srcMcp      = Join-Path $backupRoot 'mcp'
$dstRoot     = Join-Path $env:USERPROFILE '.copilot'
$dstSkills   = Join-Path $dstRoot 'skills'
$dstPlugins  = Join-Path $dstRoot 'installed-plugins'

function Copy-Restore {
    param([string]$Source, [string]$Destination, [string]$Label)

    if (-not (Test-Path -LiteralPath $Source)) {
        Write-Warning "No backup found for $Label at: $Source"
        return
    }

    if ($PSCmdlet.ShouldProcess($Destination, "Restore $Label from $Source")) {
        New-Item -ItemType Directory -Path $Destination -Force | Out-Null
        $args = @($Source, $Destination, '/E', '/R:1', '/W:1', '/NFL', '/NDL', '/NP')
        Write-Host "Restoring $Label..."
        & robocopy @args | Out-Null
        $code = $LASTEXITCODE
        if ($code -ge 8) {
            throw "Restore failed for $Label (robocopy exit $code)"
        }
        Write-Host "Restored $Label -> $Destination (robocopy exit $code)"
    }
}

function Restore-McpConfigs {
    param([string]$SourceRoot)

    if (-not (Test-Path -LiteralPath $SourceRoot)) {
        Write-Warning "No MCP config backup found at: $SourceRoot"
        return
    }

    $files = Get-ChildItem -LiteralPath $SourceRoot -Recurse -File -ErrorAction SilentlyContinue |
        Sort-Object FullName

    foreach ($file in $files) {
        $relativePath = [System.IO.Path]::GetRelativePath($SourceRoot, $file.FullName)
        $destination = Join-Path $env:USERPROFILE $relativePath
        $destinationDir = Split-Path -Parent $destination
        New-Item -ItemType Directory -Path $destinationDir -Force | Out-Null

        if ($PSCmdlet.ShouldProcess($destination, "Restore MCP config file from $($file.FullName)")) {
            Copy-Item -LiteralPath $file.FullName -Destination $destination -Force
            Write-Host "Restored MCP config -> $destination"
        }
    }
}

Write-Host "ProjectRoot : $ProjectRoot"
Write-Host "Backup root : $backupRoot"
Write-Host "Target      : $dstRoot"
Write-Host ""

if (-not (Test-Path -LiteralPath $backupRoot)) {
    throw "Backup folder not found: $backupRoot. Run Backup-CopilotSkills.ps1 first."
}

Copy-Restore -Source $srcSkills  -Destination $dstSkills  -Label 'skills'
Copy-Restore -Source $srcPlugins -Destination $dstPlugins -Label 'installed-plugins'
Restore-McpConfigs -SourceRoot $srcMcp

Write-Host ""
Write-Host "Restore complete. Fully quit and restart VS Code so Copilot reloads skills and MCP configuration."
Write-Host "On a new PC, also run: .\scripts\Register-CopilotSkillsBackupTask.ps1"
