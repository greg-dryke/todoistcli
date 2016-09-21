$userLocation = $env:PSModulePath -split ";" | Where-Object {$_ -like "*users*"} | Select-Object -First 1
$location = Join-path $userLocation "TodoistCli"
if (-not (Test-Path $location))
{
    mkdir $location
}
cp todoistcli.psd1 $location
cp todoistcli.psm1 $location
