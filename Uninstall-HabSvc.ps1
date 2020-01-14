function Stop-HabSvc
{
    $serviceName = 'Habitat'

    Write-Host "Stopping $serviceName service..."

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
        Write-Host "Service is stopped..."
        return $true
    }
    elseif($service.Status -ne [System.ServiceProcess.ServiceControllerStatus]::Stopped){
        Write-Host "Service did not stop..."
        return $false
    }
}

function Remove-HabSvc
{
    $serviceName = 'Habitat'

    $stopped = Stop-HabSvc
    if($stopped) {
        sc.exe delete $serviceName
        Write-Host "Purging C:\Hab"
        Remove-Item C:\Hab -Recurse -Force
        Write-Host "Purging C:\ProgramData\Habitat"
        Remove-Item C:\ProgramData\Habitat -Recurse -Force
    }
}

function Uninstall-HabSvc
{
    Stop-HabSvc
    Remove-HabSvc
}

Uninstall-HabSvc
