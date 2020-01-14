function Stop-HabSvc
{
    $serviceName = 'Habitat'

    Write-Host "Stopping $serviceName..."

    $service = Get-Service $serviceName
    while($service.Status -ne [System.ServiceProcess.ServiceControllerStatus]::Stopped)
    {
        if ($service.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Running){
            Stop-Service $serviceName
            Start-Sleep -s 5
            $service = Get-Service $serviceName
        }
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
