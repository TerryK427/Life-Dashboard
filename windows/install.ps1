# Life Dashboard - installs the sign-in launcher (v2).
$ErrorActionPreference = 'Stop'
$url = 'https://claude.ai/artifact/YOUR_ARTIFACT_ID'
$launcher = Join-Path $PSScriptRoot 'launch.ps1'
$shell = New-Object -ComObject WScript.Shell

$candidates = @(
  "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
  "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
  "$env:LocalAppData\Google\Chrome\Application\chrome.exe",
  "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
  "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe"
)
$browser = $candidates | Where-Object { $_ -and (Test-Path $_) } | Select-Object -First 1

# 1. Startup shortcut -> hidden launcher that waits for internet
$startup = [Environment]::GetFolderPath('Startup')
$startupLnk = Join-Path $startup 'Life Dashboard.lnk'
$lnk = $shell.CreateShortcut($startupLnk)
$lnk.TargetPath = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"
$lnk.Arguments = "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$launcher`""
$lnk.WindowStyle = 7
$lnk.WorkingDirectory = $PSScriptRoot
if ($browser) { $lnk.IconLocation = "$browser,0" }
$lnk.Description = 'Opens your Life Dashboard at sign-in'
$lnk.Save()

# 2. Make sure Windows has it switched ON under Startup apps
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\StartupFolder'
if (-not (Test-Path $key)) { New-Item -Path $key -Force | Out-Null }
New-ItemProperty -Path $key -Name 'Life Dashboard.lnk' -PropertyType Binary -Value ([byte[]](2,0,0,0,0,0,0,0,0,0,0,0)) -Force | Out-Null

# 3. Manual shortcut in this folder
$open = $shell.CreateShortcut((Join-Path $PSScriptRoot 'Open Life Dashboard.lnk'))
if ($browser) { $open.TargetPath = $browser; $open.Arguments = "--app=$url --start-maximized"; $open.IconLocation = "$browser,0" }
else { $open.TargetPath = 'explorer.exe'; $open.Arguments = $url }
$open.Save()

Write-Host ''
Write-Host 'Installed (v2). Life Dashboard will open about 5-10 seconds after you sign in to Windows.'
Write-Host 'Keep this folder on your Desktop: the launcher and its log live here.'
Write-Host 'Testing the launcher now...'
Start-Process -FilePath $startupLnk
