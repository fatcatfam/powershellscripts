function Stop-HabSvc
{
    $serviceName = 'Habitat'

    Write-Host "Stopping $serviceName..."

    $service = Get-Service $serviceName
    while($service.Status -ne [System.ServiceProcess.ServiceControllerStatus]::Stopped)
    {
        if ($service.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Running){
            Stop-Service $serviceName
            Start-Sleep -s 3
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
    $stopped = Stop-HabSvc
    if($stopped) {
        Remove-Item C:\Hab -Recurse -Force
        sc.exe delete $serviceName
    }
}

function Verify-Uninstalled
{
    $serviceName = 'Habitat'
    $service = Get-Service -DisplayName $serviceName

    $uninstalled = Remove-HavSvc
    if($uninstalled) {
        if($service.Length -gt 0) {
            Write-Host "Verification failed, service still exists... Please contact Kris.Clark-Berroth@aig.com"
        }
    }
}

function Uninstall-HabSvc
{
    Stop-HabSvc
    Remove-HabSvc
    Verify-Uninstalled
}

Write-Host "Starting"
Uninstall-HabSvc
Write-Host "Done"
