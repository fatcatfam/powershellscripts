$outFile = "D:\NTAdmin\ScheduledTasks\Out-File\Services.txt"

function StopService ($serviceName, $retryCount)
{
    Get-Date | Add-Content $outFile
    Write-Output "Stopping $serviceName" | Add-Content $outFile

    $service = Get-Service $serviceName
    while($service.Status -ne [System.ServiceProcess.ServiceControllerStatus]::Stopped -and $retryCount -gt 0)
    {
        if ($service.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Running){
            Stop-Service $serviceName
        }
        $retryCount = $retryCount - 1
        Start-Sleep -s 10
        $service = Get-Service $serviceName
    }

    if($service.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Stopped){
        Write-Output "Service is stopped..." | Add-Content $outFile
        return $true
    }
    elseif($service.Status -ne [System.ServiceProcess.ServiceControllerStatus]::Stopped){
        Write-Output "Service did not stop..." | Add-Content $outFile
        return $false
    }
}


function StartService ($serviceName, $retryCount)
{
    Get-Date | Add-Content $outFile
    Write-Output "Starting $serviceName" | Add-Content $outFile

    $service = Get-Service $serviceName
    while($service.Status -ne [System.ServiceProcess.ServiceControllerStatus]::Running -and $retryCount -gt 0)
    {
        if ($service.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Stopped){
            Start-Service $serviceName
        }
        $retryCount = $retryCount - 1
        Start-Sleep -s 10
        $service = Get-Service $serviceName
    }

    if($service.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Running){
        Write-Output "Service is running..." | Add-Content $outFile
        return $true
    }
    elseif($service.Status -ne [System.ServiceProcess.ServiceControllerStatus]::Running){
        Write-Output "Service did not start..." | Add-Content $outFile
        return $false
    }
}


function RestartService ($serviceName, $retryCount)
{
    $stopped = StopService $serviceName 2
    if($stopped) {
        StartService $serviceName 2
    }
}

RestartService '<insert windows service name here>' <insert number of retries here>