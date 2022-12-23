#Requires -RunAsAdministrator

param($servicesFilePath, $action)

# checks for the first argument
if ($null -eq $servicesFilePath) {
    Write-Host "Please specify the services file path as a first parameter" -Fore 'red' -BackgroundColor 'black'
    Exit
}

if (!(Test-Path $servicesFilePath)) {
    Write-Host "Services file not found in the giving path '$servicesFilePath'" -Fore 'red' -BackgroundColor 'black'
    Exit
}

# checks for the second argument
if ($null -eq $action) {
    Write-Host "Please specify the action you want to operate on the services" -Fore 'red' -BackgroundColor 'black'
    Exit
}

$supportedActions = @('start', 'stop', 'restart')

if ($supportedActions -notcontains $action) {
    Write-Host "Service action '$action' not supported" -Fore 'red' -BackgroundColor 'black'
    Exit
}

# start processing
$content = Get-Content -Path $servicesFilePath
$truckedServices = $content -Split "\r\n"

while ($true) {
    $runningServices = Get-Service

    foreach ($service in $truckedServices) {
        $neededService = $runningServices | Where-Object { $_.DisplayName -eq $service }

        if ($neededService) {
            if ($action -eq 'start' -and $neededService.Status -eq 'Running') {
                Write-Host "INFO: Service '$service' already running" -Fore 'Cyan' -BackgroundColor 'black'
                continue
            }

            if ($action -eq 'stop' -and $neededService.Status -eq 'Stopped') {
                Write-Host "INFO: Service '$service' already stopped" -Fore 'Cyan' -BackgroundColor 'black'
                continue
            }
            
            $uppercasedAction = (Get-Culture).TextInfo.ToTitleCase($($action).ToLower())
            invoke-expression "$uppercasedAction-Service -DisplayName '$service'"

            $neededService.Refresh()

            # stop panding
            if ($action -eq 'stop' -and $neededService.Status -eq 'StopPending') {
                Write-Warning "Service '$service' is stop pending ..."
                continue
            }

            # stop
            if ($action -eq 'stop' -and $neededService.Status -eq 'Stopped') {
                Write-Host "SUCCESS: Service '$service' stopped with success" -Fore 'green' -BackgroundColor 'black'
                continue
            }

            # start
            if ($action -eq 'start' -and $neededService.Status -eq 'Running') {
                Write-Host "SUCCESS: Service '$service' started with success" -Fore 'green' -BackgroundColor 'black'
                continue
            }
        }
        else {
            Write-Warning "Service '$service' is not exist"
        }
    }

    start-sleep -seconds 10
}