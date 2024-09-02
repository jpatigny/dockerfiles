function Install-MSI {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$MSIPath, # Path to the MSI file

        [Parameter(Mandatory=$false, Position=1)]
        [string]$LogFile = "$env:temp\MSIInstall.log", # Path to the log file (default is in temp directory)

        [Parameter(Mandatory=$false, Position=2)]
        [string]$InstallArgs = "/quiet /norestart" # Default MSI installation arguments
    )

    # Verify the MSI file exists
    if (-Not (Test-Path -Path $MSIPath)) {
        Write-Error "The MSI file '$MSIPath' does not exist."
        return
    }

    # Build the MSIExec command
    $msiexecCmd = "/i `"$MSIPath`" $InstallArgs /log `"$LogFile`""

    # Execute the command
    try {
        Write-Host "Installing MSI: $MSIPath" -ForegroundColor Green
        $process = Start-Process -FilePath "msiexec.exe" -ArgumentList $msiexecCmd -Wait -PassThru

        # Check for a successful installation
        if ($process.ExitCode -eq 0) {
            Write-Host "MSI installed successfully." -ForegroundColor Green
        } else {
            Write-Error "MSI installation failed with exit code $($process.ExitCode). Check the log file at '$LogFile' for more details."
        }
    } catch {
        Write-Error "An error occurred during the MSI installation: $_"
    }
}