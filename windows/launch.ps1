# Life Dashboard - runs at Windows sign-in. Waits for internet, then opens the dashboard.
$url = 'https://claude.ai/artifact/YOUR_ARTIFACT_ID'
$log = Join-Path $PSScriptRoot 'startup-log.txt'
function Log($m) { try { Add-Content -Path $log -Value ("{0:yyyy-MM-dd HH:mm:ss}  {1}" -f (Get-Date), $m) } catch {} }
try { if ((Test-Path $log) -and ((Get-Item $log).Length -gt 50KB)) { Remove-Item $log -Force } } catch {}

Log 'Launcher started'
$ok = $false
for ($i = 0; $i -lt 45; $i++) {
  try { [void][System.Net.Dns]::GetHostAddresses('claude.ai'); $ok = $true; break } catch { Start-Sleep -Seconds 2 }
}
Log ("Internet ready: {0} (waited {1}s)" -f $ok, ($i * 2))
Start-Sleep -Seconds 3

$candidates = @(
  "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
  "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
  "$env:LocalAppData\Google\Chrome\Application\chrome.exe",
  "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
  "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe"
)
$browser = $candidates | Where-Object { $_ -and (Test-Path $_) } | Select-Object -First 1
try {
  if ($browser) { Start-Process -FilePath $browser -ArgumentList @("--app=$url", '--start-maximized'); Log "Opened with $browser" }
  else { Start-Process $url; Log 'Opened with default browser' }
} catch { Log ('Could not open: ' + $_.Exception.Message) }
