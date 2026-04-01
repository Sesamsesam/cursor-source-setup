# ─────────────────────────────────────────────────────────
# Cursor Source Setup - Updater (Windows)
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

New-Item -ItemType Directory -Force -Path $RulesDir | Out-Null
Get-ChildItem -Path (Join-Path $PackDir "rules") -File | ForEach-Object {
    Copy-Item $_.FullName -Destination $RulesDir -Force
}

$MachineEnv = ""
$LifecycleFile = Join-Path $CursorSkillsDir "liftoff-lifecycle\SKILL.md"
if (Test-Path $LifecycleFile) {
    $content = Get-Content $LifecycleFile -Raw
    $match = [regex]::Match($content, '(?ms)^## Machine Environment.*$')
    if ($match.Success) { $MachineEnv = $match.Value }
}

Get-ChildItem -Path (Join-Path $PackDir "skills") -Directory | ForEach-Object {
    $destDir = Join-Path $CursorSkillsDir $_.Name
    if (Test-Path $destDir) { Remove-Item $destDir -Recurse -Force }
    Copy-Item $_.FullName $destDir -Recurse -Force
}

if ($MachineEnv) {
    $freshLifecycle = Join-Path $CursorSkillsDir "liftoff-lifecycle\SKILL.md"
    Add-Content $freshLifecycle "`n$MachineEnv"
}

if (Test-Path $WorkflowsDir) { Remove-Item $WorkflowsDir -Recurse -Force }
New-Item -ItemType Directory -Force -Path $WorkflowsDir | Out-Null
Get-ChildItem -Path (Join-Path $PackDir "workflows") -Filter "*.md" | ForEach-Object {
    Copy-Item $_.FullName (Join-Path $WorkflowsDir $_.Name) -Force
}

if (Test-Path $SetupDir) { Remove-Item $SetupDir -Recurse -Force }
New-Item -ItemType Directory -Force -Path $SetupDir | Out-Null
Get-ChildItem -Path (Join-Path $PackDir "setup") -Directory | ForEach-Object {
    Copy-Item $_.FullName (Join-Path $SetupDir $_.Name) -Recurse -Force
}

Get-ChildItem -Path $ExtensionsDir -Directory | ForEach-Object {
    Remove-Item $_.FullName -Recurse -Force
}

Get-ChildItem -Path (Join-Path $PackDir "extensions") -Directory | ForEach-Object {
    Copy-Item $_.FullName (Join-Path $ExtensionsDir $_.Name) -Recurse -Force
}

$ExtJsonDest = Join-Path $ExtensionsDir "extensions.json"
$ExtJsonSource = Join-Path $PackDir "extensions\extensions.json"
if (Test-Path $ExtJsonDest) {
    $existing = Get-Content $ExtJsonDest -Raw | ConvertFrom-Json
    $source = Get-Content $ExtJsonSource -Raw | ConvertFrom-Json
    $existingHash = @{}
    $existing.PSObject.Properties | ForEach-Object { $existingHash[$_.Name] = $_.Value }
    $source.PSObject.Properties | ForEach-Object {
        if (-not $existingHash.ContainsKey($_.Name)) {
            $existing | Add-Member -NotePropertyName $_.Name -NotePropertyValue $_.Value
        }
    }
    $existing | ConvertTo-Json -Depth 10 | Set-Content $ExtJsonDest -Encoding UTF8
} else {
    Copy-Item $ExtJsonSource $ExtJsonDest
}

try {
    $gitAvailable = Get-Command git -ErrorAction SilentlyContinue
} catch { $gitAvailable = $null }
$gitDir = Join-Path $ScriptDir ".git"
if ($gitAvailable -and (Test-Path $gitDir)) {
    $commitHash = git -C $ScriptDir rev-parse HEAD 2>$null
    if ($LASTEXITCODE -eq 0 -and $commitHash) {
        Set-Content (Join-Path $LiftoffDir ".liftoff-version") $commitHash -Encoding UTF8
    }
}
