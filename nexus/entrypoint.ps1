Set-Location ~/scoop/apps/nexus-repository-oss/current/nexus/bin
Write-Host "Starting nexus. It might take a while..."
Start-Process "nexus.exe" -ArgumentList "/run"

$nexusUri = "http://127.0.0.1:8081" 
Write-Host "Waiting on Nexus Web UI to be available at '$($nexusUri)'"
while ($response.StatusCode -ne '200' -and $Timer.Elapsed.TotalMinutes -lt 3) {
  try {
    $response = Invoke-WebRequest -Uri $nexusUri -UseBasicParsing
  } catch {
    Write-Verbose "Waiting on Nexus Web UI to be available at '$($nexusUri)'"
    Start-Sleep -Seconds 1
  }
}

$Timer = $null

if ($Response.StatusCode -eq '200') {
  Write-Host "Nexus is ready!"
} else {
  Write-Error "Nexus did not r
  espond to requests at '$($nexusUri)' within 3 minutes of the service being started."
}

$cred = Get-Content ~/scoop/apps/nexus-repository-oss/current/sonatype-work/nexus3/admin.password
Write-Host "Admin password: $cred"