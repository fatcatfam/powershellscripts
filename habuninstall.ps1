# Original Author: Kris Clark.Berroth
# Check the installation state and service state, and uninstall or exit if installed.

function installation_status($service_name)
{

    if (!(Get-Service $service_name -ErrorAction SilentlyContinue).DisplayName){
        Write-Host "Service is not installed"
        $directories = @("C:\Hab", "C:\ProgramData\Habitat")
        foreach ($dir in $directories){
            if (Test-Path $dir -ErrorAction SilentlyContinue){
                Write-Host "Directory: $dir exists."
                return $true
            }
                elseif (!(Test-Path $dir -ErrorAction SilentlyContinue)){
                Write-Host "$service_name is not installed"
                return $false
            }
        }
    }
        
    if (Get-Service $service_name -ErrorAction SilentlyContinue){
        Write-Host "$service_name is installed"
        return $true
    }
    Write-Host "$service_name is not installed"
    return $false

}

function stop_service($service_name)
{
    $exists = installation_status($service_name)
    if ($exists)
    {
        $service = Get-Service $service_name -ErrorAction SilentlyContinue
        while($service.Status -ne [System.ServiceProcess.ServiceControllerStatus]::Stopped)
        {
            if ($service.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Running){
                Write-Host "$service_name is running"
                Write-Host "Stopping $service_name..."
                Stop-Service $service_name
            }
            Start-Sleep -s 10
            $service = Get-Service $service_name -ErrorAction SilentlyContinue
        }
        if($service.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Stopped){
            Write-Host "$service_name is stopped"
            return $true
        }
        elseif($service.Status -ne [System.ServiceProcess.ServiceControllerStatus]::Stopped){
            Write-Output "$service_name did not stop. Please contact administrator for support. Exiting."
            return $false
            exit
        }
    }
}

function uninstall_service($service_name)
{
    $stopped = stop_service($service_name)
    if ($stopped)
    {
        Write-Host "Uninstalling $service_name..."
        hab pkg exec core/windows-service uninstall
        Start-Sleep -s 10

        Write-Host "Checking $service_name directories..."

        if (!(Get-Service $service_name -ErrorAction SilentlyContinue)){
            $directories = @("C:\Hab", "C:\ProgramData\Habitat")
            foreach ($dir in $directories){
                if (Test-Path $dir -ErrorAction SilentlyContinue){
                    Write-Host "Directory: $dir deleted."
                    Remove-Item $dir -Recurse -Force
                }
                elseif (!(Test-Path $dir -ErrorAction SilentlyContinue)){
                    Write-Host "Directory: $dir does not exist."
                }
            }
        }
    }
}

uninstall_service 'Habitat' 
