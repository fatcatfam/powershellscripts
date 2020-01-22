 function service_exists($name)
{
    if ( Get-Service $name -ErrorAction SilentlyContinue)
    {
        Write-Host "Service installed"
        return $true
    }
    Write-Host "Service not installed - Exiting"
    return $false
}

function remove_if_exists($name)
{
    $exists = service_exists $name
    if ($exists)
    {
        Write-Host "Uninstalling service..."
        #hab pkg exec core/windows-service uninstall
        Stop-Service $name
        Start-Sleep -s 10
        $directories = @("C:\", "C:\ProgramData\Habitat")
        foreach ($dir in $directories)
        {
            if (Test-Path $dir -ErrorAction SilentlyContinue){
                Remove-Item -Recurse -Force}
            }
            Write-Host "Directory: $dir does not exist."
    }

}

remove_if_exists 'Windows Time' 
