#require -version 5
param(
    $pullclientname = 'CR840814',
    $pullservername = "CR840814" 
);

$dir = Split-Path $PSCommandPath;
$buildDir = Join-Path $dir 'build'
Write-Host "Build path $builddir";

# Find a suitable CA 
# $CASubject = "CA=fianbakken"
#$cert = Get-childItem Cert:\LocalMachine\CA|Where-Object {$_.Subject -eq $CASubject}|select -First 1
#$thumbPrint = $cert.Thumbprint;
# If there's no valid cert, use unencryted
$thumbPrint = 'AllowUnencryptedTraffic';

# Random guid for a new setup
$guid = [Guid]::NewGuid();
# Or use predefined one for consistency
$guid = '6fb77d5a-0c67-42a9-8e8d-79c6941de085';

# Use this for ConfigurePullServer and Pull-client

# Include 
. "$dir\pull-server\ConfigurePullserver.ps1"
. "$dir\pull-client\ConfigureInsecurePullClient.ps1"


Write-Host "Compiling pull server mofs with registrationKey $guid and $thumbPrint"
Write-Host "Please write the registration key  - When configuring clients in pull mode, this needs to match";

ConfigurePullServer -certificateThumbPrint $thumbPrint -RegistrationKey $guid -NodeName $pullservername -Verbose -OutputPath $buildDir;
Write-Host "Compiling pull client mofs with $guid ";

ConfigureInsecurePullClient -NodeName $pullclientname -pullserverName $pullservername -RegistrationKey $guid -OutputPath $buildDir;

# Start the configurations43
if(-not $pullserverCredential){
    $pullserverCredential = Get-Credential -Message 'Enter credentials for pullserver' "$($pullservername)\Administrator" ;    
} 

Start-DscConfiguration -ComputerName $pullservername -Wait -Verbose -Credential $pullserverCredential -Path $buildDir -Force -Debug;

if(-not $pullclientCredential){
    $pullclientCredential = Get-Credential -Message 'Enter credentials for pullclient' -UserName "$($pullclientName)\Administrator";    
}

Set-DscLocalConfigurationManager -ComputerName $pullclientname -Path $buildDir -Credential $pullclientCredential -Verbose -Force;
#Set-DscLocalConfigurationManager -ComputerName $pullclientname -Path $buildDir -Credential $pullclientCredential -Verbose -Force;


function Get-Report
{
    param($AgentId = "$((Get-DscLocalConfigurationManager).AgentId)", $serviceURL = "http://$(pullserverName)/PSDSCPullServer.svc")
    $requestUri = "$serviceURL/Nodes(AgentId= '$AgentId')/Reports"
    $request = Invoke-WebRequest -Uri $requestUri  -ContentType "application/json;odata=minimalmetadata;streaming=true;charset=utf-8" `
               -UseBasicParsing -Headers @{Accept = "application/json";ProtocolVersion = "2.0"} `
               -ErrorAction SilentlyContinue -ErrorVariable ev
    $object = ConvertFrom-Json $request.content
    $report=$object.value           
    $report|Add-Member -MemberType NoteProperty -Name 'StatusData' -Value ($report.StatusData|ConvertFrom-json) -Force    
    return $report
}