# -------------------------------------- #
#      GITHUB RELEASE UPDATE SCRIPT      #
# -------------------------------------- #
$ErrorActionPreference = 'Stop'

# variables
$github_repo   = 'prometheus'
$application   = 'blackbox_exporter'
$dockerfiles   = 'dockerfile'
$regex_version = 'ARG VERSION=(.+)$'

# Retrieve latest release from github
$query = Invoke-RestMethod -UseBasicParsing -uri "https://api.github.com/repos/$($github_repo)/$($application)/releases/latest"

if (!$query) { Write-Host -ForegroundColor Red 'Unable to query github website !' ; exit 1 }

[Version]$LastVersion = $($query.tag_name) -replace '^v',''
Write-Host "Last version found from github: $LastVersion"

# git config
git config --global user.name 'jpatigny'
git config --global user.email 'jpatigny@users.noreply.github.com'

# Compare latest version from github with dockerfile(s)
$changes = $false

foreach ($file in $dockerfiles) {
  if (Test-Path $file) {
    [Version]$CurrentVersion = Get-Content $file | Select-String $regex_version | ForEach-Object { $_.Matches[0].Groups[1].Value }
    Write-Host "Current version found in $($file): $CurrentVersion"
    
    if ($LastVersion -gt $CurrentVersion) {
      Write-Host "A new release version has been found for $application : $LastVersion"
  
      # Updating dockerfile
      Get-ChildItem -Path $file | ForEach-Object {
          (Get-Content $_.FullName) -replace $CurrentVersion,$LastVersion | Set-Content $_.FullName -Verbose
      }
  
      # commit and push
      git add $file
      $changes = $true
    }
    else {
        Write-Host "Current version is already latest..."
    }
  }
}

if ($changes) {
  git commit -m "[AU] Updating version: $CurrentVersion > $LastVersion"
  git push 2>&1 | Write-Host -ForegroundColor Green
}