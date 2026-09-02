<#
.SYNOPSIS
    Registers a Windows Scheduled Task to back up Copilot skills and VS Code MCP configs daily at 8:05 AM.
#>
[CmdletBinding()]
param(
    [string]$ProjectRoot,
    [string]$TaskName = 'CopilotSkillsDailyBackup',
    [string]$Time = '08:05'
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

$backupScript = Join-Path $ProjectRoot 'scripts\Backup-CopilotSkills.ps1'
if (-not (Test-Path -LiteralPath $backupScript)) {
    throw "Backup script not found: $backupScript"
}

$logsDir = Join-Path $ProjectRoot 'logs'
New-Item -ItemType Directory -Path $logsDir -Force | Out-Null

$psExe = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
if (-not (Test-Path -LiteralPath $psExe)) {
    $psExe = 'powershell.exe'
}

$arg = "-NoProfile -ExecutionPolicy Bypass -File `"$backupScript`" -ProjectRoot `"$ProjectRoot`""

$action  = New-ScheduledTaskAction -Execute $psExe -Argument $arg -WorkingDirectory $ProjectRoot
$trigger = New-ScheduledTaskTrigger -Daily -At $Time
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Limited
$settings  = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -MultipleInstances IgnoreNew

Register-ScheduledTask `
    -TaskName $TaskName `
    -Action $action `
    -Trigger $trigger `
    -Principal $principal `
    -Settings $settings `
    -Description "Daily backup of GitHub Copilot skills and VS Code MCP configs into: $ProjectRoot" `
    -Force | Out-Null

$info = Get-ScheduledTask -TaskName $TaskName
$next = (Get-ScheduledTaskInfo -TaskName $TaskName).NextRunTime

Write-Host "Scheduled task registered."
Write-Host "  Name     : $TaskName"
Write-Host "  State    : $($info.State)"
Write-Host "  Daily at : $Time"
Write-Host "  Script   : $backupScript"
Write-Host "  Next run : $next"
Write-Host ""
Write-Host "Test now with: Start-ScheduledTask -TaskName '$TaskName'"
