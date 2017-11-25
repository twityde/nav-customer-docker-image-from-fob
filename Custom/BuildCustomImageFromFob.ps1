$SqlServiceName = 'MSSQL$SQLEXPRESS'
$SqlWriterServiceName = "SQLWriter"
$SqlBrowserServiceName = "SQLBrowser"
$NavServiceName = 'MicrosoftDynamicsNavServer$NAV'
$serviceTierFolder = (Get-Item "C:\Program Files\Microsoft Dynamics NAV\*\Service").FullName
$databaseName = $env:databaseName
$databaseServer = "localhost"
$databaseInstance = "SQLEXPRESS"

if (!([string]::IsNullOrEmpty($databaseInstance))){
    $databaseServerAndInstance = "$($databaseServer)\$($DatabaseInstance)"
} else
{
    $databaseServerAndInstance = $databaseServer
}

# start the SQL Server
Write-Host "Starting Local SQL Server"
Start-Service -Name $SqlBrowserServiceName -ErrorAction Ignore
Start-Service -Name $SqlWriterServiceName -ErrorAction Ignore
Start-Service -Name $SqlServiceName -ErrorAction Ignore

# start NST
Write-Host "Starting NAV Service Tier"
Start-Service -Name $NavServiceName -WarningAction Ignore

# import FOBs
$roleTailoredClientFolder = (Get-Item "C:\Program Files (x86)\Microsoft Dynamics NAV\*\RoleTailored Client").FullName
$NavIde = Join-Path $roleTailoredClientFolder "finsql.exe"
if (Test-Path "$roleTailoredClientFolder\Microsoft.Dynamics.Nav.Ide.psm1") {
    Import-Module "$roleTailoredClientFolder\Microsoft.Dynamics.Nav.Ide.psm1" -wa SilentlyContinue
}
if (Test-Path "$roleTailoredClientFolder\Microsoft.Dynamics.Nav.Apps.Management.psd1") {
    Import-Module "$roleTailoredClientFolder\Microsoft.Dynamics.Nav.Apps.Management.psd1" -wa SilentlyContinue
}
if (Test-Path "$roleTailoredClientFolder\Microsoft.Dynamics.Nav.Apps.Tools.psd1") {
    Import-Module "$roleTailoredClientFolder\Microsoft.Dynamics.Nav.Apps.Tools.psd1" -wa SilentlyContinue
}
if (Test-Path "$roleTailoredClientFolder\Microsoft.Dynamics.Nav.Model.Tools.psd1") {
    Import-Module "$roleTailoredClientFolder\Microsoft.Dynamics.Nav.Model.Tools.psd1" -wa SilentlyContinue
}

$files = Get-ChildItem c:\Custom\Objects\*.fob
Import-Module "$serviceTierFolder\Microsoft.Dynamics.Nav.Management.psm1"

Write-Host "Spinup NAV Service"
Get-NAVCompany -ServerInstance "NAV"

foreach ($file in $files) {
    $path = $file.Fullname
    Write-Host "Import file $path"
    Import-NAVApplicationObject -Path $path -DatabaseName $databaseName -NavServerName "localhost" -NavServerInstance "NAV" -ImportAction Overwrite -Confirm:$false
}

# stop the SQL Server
Write-Host "Stopping Local SQL Server"
Stop-Service -Name $SqlBrowserServiceName -ErrorAction Ignore
Stop-Service -Name $SqlWriterServiceName -ErrorAction Ignore
Stop-Service -Name $SqlServiceName -ErrorAction Ignore

# stop NST
Write-Host "Stopping NAV Service Tier"
Stop-Service -Name $NavServiceName -WarningAction Ignore

# done
Write-Host "Done."