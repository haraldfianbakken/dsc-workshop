[DSCLocalConfigurationManager()]
configuration ConfigureInsecurePullClient
{
    param  
    ( 
        [string[]]$NodeName = 'localhost',
        [string]$pullserverName,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $RegistrationKey 
    );

    Node $NodeName
    {
        Settings
        {
            RefreshMode          = 'Pull'
            RefreshFrequencyMins = 30 
            RebootNodeIfNeeded   = $true
            AllowModuleOverwrite  = $true;
            
            # Previous in WMF 5
            # ConfigurationID = "GUID"                     
        }

        ConfigurationRepositoryWeb PullServerConfig
        {
            ServerURL          = "http://$($pullserverName)/PSDSCPullServer.svc"
            RegistrationKey    = $RegistrationKey
            ConfigurationNames = @('ClientConfig')
            AllowUnsecureConnection = $true
        }   

        ResourceRepositoryWeb ResourceServer
        {
            ServerURL          = "http://$($pullserverName)/PSDSCPullServer.svc"
            RegistrationKey    = $RegistrationKey
            AllowUnsecureConnection = $true
        }

        ReportServerWeb ReportServer
        {
            ServerURL       = "http://$($pullserverName)/PSDSCPullServer.svc"            
            RegistrationKey    = $RegistrationKey
            AllowUnsecureConnection = $true
        }
    }
}

