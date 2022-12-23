$truckedServices = 
    "Background Intelligent Transfer Service", 
    "Delivery Optimization", 
    "Windows Update", 
    "Microsoft Office Click-to-Run Service"

while ($true) {
    $runningServices = Get-Service | Where-Object { $_.Status -eq "Running" }

    foreach ($service in $truckedServices) {
        $neededService = $runningServices | Where-Object { $_.DisplayName -eq $service }

        if ($neededService) {
            Stop-Service -DisplayName $service
            if ($neededService.Status -eq 'Running') {
                Write-Host "Error: Couldn't stop service $service"
            }
        }
        else {
            Write-Host "Warning: Service $service is either not running or not exist."
        }
    }

    start-sleep -seconds 1
}