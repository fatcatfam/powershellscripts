$freeSpace = (Get-Volume -DriveLetter C).SizeRemaining/1GB

if ($freeSpace -lt 2){
    Write-EventLog -LogName Application -Source Application -EventID 0 -EntryType Warning -Message "Insufficient disk space. Habitat not installed."
    Write-Host "Insufficient disk spack on C disk. Habitat not installed."
    Exit
} 
