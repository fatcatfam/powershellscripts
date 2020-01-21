function service_exists($name)
{
    if ( Get-Service $name -ErrorAction SilentyContinue)
    {
        return $true
    }
    return $false
}

function remove_if_exists($name)
{
    $exists = service_exists $name
    if ($exists)
    {
        hab pkg exec core/windows-service uninstall
        $directories = @("C:\", "C:\ProgramData\Habitat")
        foreach ($dir in $directories) {
            if (Test-Path)
        }
        Write-Host "Purging C:\Hab"
        Remove-Item C:\Hab -Recurse -Force
        Write-Host "Purging C:\ProgramData\Habitat"
        Remove-Item C:\ProgramData\Habitat -Recurse -Force
    }
}

remove_if_exists 'Habitat'