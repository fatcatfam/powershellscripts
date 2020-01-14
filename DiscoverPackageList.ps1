function DiscoverPackageList
{
    Write-Host "Discovering Package List..."

    $packageList = @()

    $MatchRegex = "Octopus\.Action\[([^\]]+)\]\.Name"

    $actionNames = $OctopusParameters.GetEnumerator() | Where-Object { $_.Key -match $MatchRegex } | % { $_.Value }

    foreach($actionName in $actionNames)
    {
        Write-Host $('Step: {0}' -f $actionName)
        $packageId = $OctopusParameters["Octopus.Action[" + $actionName + "].Package.NuGetPackageId"]
        if ($OctopusParameters["Octopus.Action.Name"] -eq $actionName){
            continue;
        }
        elseif ($packageId -ne $null){
            $packageVersion = $OctopusParameters["Octopus.Action[" + $actionName + "].Package.NuGetPackageVersion"]
            Write-Host $("Found Package")
            Write-Host $("PackageId: $packageId")
            Write-Host $("PackageVersion: {0}" -f $packageVersion)
            $packageList += @{
                PackageId = $packageId;
                PackageVersion = $packageVersion
            }
        }
        else{
            Write-Host 'No Package Found'
        }
    }
    Write-Host "Returning Package List.."
    return $packageList
}

function PushToNugetFeed($packageList)
{
    $ProgressPreference = "SilentlyContinue"
    foreach($package in $packageList)
    {
        $source = "http://proget.com/api/v2/package/AppNugetFeed/{0}/{1}" -f $package.PackageId, $package.PackageVersion
        $destination = "D:\Proget_RetentionPolicy\Data\{0}.{1}.nupkg" -f $package.PackageId, $package.PackageVersion
        Write-Host $("Pushing Package")
        Write-Host $("PackageId: {0}" -f $package.PackageId)
        Write-Host $("PackageVersion: {0}" -f $package.PackageVersion)
        Write-Host $("Source: $source")
        Write-Host $("Destination: $destination")
        Write-Host $("Downloading Package")
        Invoke-WebRequest $source -Outfile $destination
        Write-Host $("Downloaded Package, Pushing")
        D:\nuget\nuget.exe push $destination -Source http://proget.com/nuget/ProdAppNugetFeed -ApiKey key-should-go-here
        Write-Host $("Completed Pushing Package")
    }
    $progressPreference = "Continue"
}

function GetAndPushAllPackagesToNuget
{
    Write-Host "Calling DiscoverPackageList"
    $packageList = DiscoverPackageList
    Write-Host "Call PushToNugetFeed"
    PushToNugetFeed $packageList
}

Write-Host "Starting"
GetAndPushAllPackagesToNuget
Write-Host "DONE"