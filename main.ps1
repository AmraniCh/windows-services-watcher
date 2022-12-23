param($servicesFilePath)

if (!(Test-Path $servicesFilePath)) {
    Write-Error "Services file not found in the giving path '$servicesFilePath'"
    Exit
}

$content = Get-Content -Path $servicesFilePath
$truckedServices = $content -Split "\r\n"

while ($true) {
    $runningServices = Get-Service | Where-Object { $_.Status -eq "Running" }

    foreach ($service in $truckedServices) {
        $neededService = $runningServices | Where-Object { $_.DisplayName -eq $service }

        if ($neededService) {
            Stop-Service -DisplayName $service
            if ($neededService.Status -eq 'Running') {
                Write-Warning "Could not stop service '$service'"
            }
        }
        else {
            Write-Warning "Service '$service' is either not running or not exist."
        }
    }

    start-sleep -seconds 1
}