# ─────────────────────────────────────────────────────────
# Cursor Source Setup - Windows Installer (PowerShell)
# Usage: powershell -ExecutionPolicy Bypass -File install.ps1
# ─────────────────────────────────────────────────────────

$ErrorActionPreference = "Stop"

$LiftoffDir = Join-Path $env:USERPROFILE ".cursor\liftoff"
$CursorSkillsDir = Join-Path $env:USERPROFILE ".cursor\skills"
$WorkflowsDir = Join-Path $LiftoffDir "workflows"
$ExtensionsDir = Join-Path $LiftoffDir "extensions"
$SetupDir = Join-Path $LiftoffDir "setup"
$RulesDir = Join-Path $LiftoffDir "rules"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$PackDir = Join-Path $ScriptDir "pack"

Write-Host ""
Write-Host "  ╔═══════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "  ║         CURSOR SOURCE SETUP               ║" -ForegroundColor Magenta
Write-Host "  ║   Liftoff pack for Cursor (global install) ║" -ForegroundColor Magenta
Write-Host "  ╚═══════════════════════════════════════════╝" -ForegroundColor Magenta
Write-Host ""

Write-Host "Creating directories..." -ForegroundColor Blue
New-Item -ItemType Directory -Force -Path $CursorSkillsDir | Out-Null
New-Item -ItemType Directory -Force -Path $WorkflowsDir | Out-Null
New-Item -ItemType Directory -Force -Path $ExtensionsDir | Out-Null
New-Item -ItemType Directory -Force -Path $SetupDir | Out-Null
New-Item -ItemType Directory -Force -Path $RulesDir | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $LiftoffDir "user-extensions") | Out-Null

Write-Host "Installing rules..." -ForegroundColor Green
Get-ChildItem -Path (Join-Path $PackDir "rules") -File | ForEach-Object {
    Copy-Item $_.FullName -Destination $RulesDir -Force
}

$ExtJsonDest = Join-Path $ExtensionsDir "extensions.json"
$ExtJsonSource = Join-Path $PackDir "extensions\extensions.json"

if (Test-Path $ExtJsonDest) {
    Write-Host "  Existing extensions.json found - preserving your settings" -ForegroundColor Yellow
    $existing = Get-Content $ExtJsonDest -Raw | ConvertFrom-Json
    $source = Get-Content $ExtJsonSource -Raw | ConvertFrom-Json
    $existingHash = @{}
    $existing.PSObject.Properties | ForEach-Object { $existingHash[$_.Name] = $_.Value }
    $source.PSObject.Properties | ForEach-Object {
        if (-not $existingHash.ContainsKey($_.Name)) {
            $existing | Add-Member -NotePropertyName $_.Name -NotePropertyValue $_.Value
            Write-Host "  + Added new entry: $($_.Name)" -ForegroundColor Green
        }
    }
    $existing | ConvertTo-Json -Depth 10 | Set-Content $ExtJsonDest -Encoding UTF8
} else {
    Copy-Item $ExtJsonSource $ExtJsonDest
}

Write-Host "Installing core skills to ~/.cursor/skills/..." -ForegroundColor Green
$MachineEnv = ""
$LifecycleFile = Join-Path $CursorSkillsDir "liftoff-lifecycle\SKILL.md"
if (Test-Path $LifecycleFile) {
    $content = Get-Content $LifecycleFile -Raw
    $match = [regex]::Match($content, '(?ms)^## Machine Environment.*$')
    if ($match.Success) { $MachineEnv = $match.Value }
}

$CoreSkills = @(
    "forge-methodology", "security-guardian", "error-handling", "git-flow",
    "brand-identity", "stack-pro-max", "cursor-standard", "liftoff-lifecycle"
)

foreach ($skill in $CoreSkills) {
    $destDir = Join-Path $CursorSkillsDir $skill
    New-Item -ItemType Directory -Force -Path $destDir | Out-Null
    Copy-Item (Join-Path $PackDir "skills\$skill\SKILL.md") (Join-Path $destDir "SKILL.md") -Force
    Write-Host "  + $skill" -ForegroundColor Gray
}

if ($MachineEnv) {
    $freshLifecycle = Join-Path $CursorSkillsDir "liftoff-lifecycle\SKILL.md"
    Add-Content $freshLifecycle "`n$MachineEnv"
}

Write-Host "Installing workflows..." -ForegroundColor Green
Copy-Item (Join-Path $PackDir "workflows\init-project.md") (Join-Path $WorkflowsDir "init-project.md") -Force

Write-Host "Installing setup tasks..." -ForegroundColor Green
Get-ChildItem -Path (Join-Path $PackDir "setup") -Directory | ForEach-Object {
    $destDir = Join-Path $SetupDir $_.Name
    New-Item -ItemType Directory -Force -Path $destDir | Out-Null
    Copy-Item (Join-Path $_.FullName "SKILL.md") (Join-Path $destDir "SKILL.md") -Force
    Write-Host "  + $($_.Name)" -ForegroundColor Gray
}

Write-Host "Installing extensions..." -ForegroundColor Green
$ExtCount = 0
Get-ChildItem -Path (Join-Path $PackDir "extensions") -Directory | ForEach-Object {
    $destDir = Join-Path $ExtensionsDir $_.Name
    if (Test-Path $destDir) { Remove-Item $destDir -Recurse -Force }
    Copy-Item $_.FullName $destDir -Recurse -Force
    Write-Host "  + $($_.Name)" -ForegroundColor Gray
    $script:ExtCount++
}

$gitAvailable = $null
try { $gitAvailable = Get-Command git -ErrorAction SilentlyContinue } catch {}
$gitDir = Join-Path $ScriptDir ".git"
if ($gitAvailable -and (Test-Path $gitDir)) {
    $commitHash = git -C $ScriptDir rev-parse HEAD 2>$null
    if ($LASTEXITCODE -eq 0 -and $commitHash) {
        Set-Content (Join-Path $LiftoffDir ".liftoff-version") $commitHash -Encoding UTF8
        Set-Content (Join-Path $LiftoffDir ".liftoff-source") $ScriptDir -Encoding UTF8
        Write-Host "Version tracking enabled" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "Installation complete!" -ForegroundColor Green
Write-Host "  Rules:    $RulesDir"
Write-Host "  Skills:   $CursorSkillsDir"
Write-Host "  Pack:     $LiftoffDir"
Write-Host "AGENT: Read $env:USERPROFILE\.cursor\liftoff\setup\package-manager\SKILL.md if setup pending."
Write-Host "AGENT: Read $env:USERPROFILE\.cursor\skills\liftoff-lifecycle\SKILL.md Session Start after install."
