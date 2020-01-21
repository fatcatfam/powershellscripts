# Author: Kris.Clark-Berroth@aig.com
# Stop the Habitat service, delete the Habitat service, purge Hab and Habitat directories

function Stop-HabSvc
{
    $serviceName = 'Habitat'

    Write-Host "Stopping $serviceName service..."

    $service = Get-Service $serviceName
    while($service.Status -ne [System.ServiceProcess.ServiceControllerStatus]::Stopped)
    {
        if ($service.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Running){
            Stop-Service $serviceName
            Start-Sleep -s 10
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
    $service_name = 'Habitat'

    $stopped = Stop-HabSvc
    if($stopped) {
        hab exec core/windows-service uninstall
        Write-Host "Purging C:\Hab"
        Remove-Item C:\Hab -Recurse -Force
        Write-Host "Purging C:\ProgramData\Habitat"
        Remove-Item C:\ProgramData\Habitat -Recurse -Force
    }
}

function habuninstall
{
    Remove-HabSvc
}

habuninstall
