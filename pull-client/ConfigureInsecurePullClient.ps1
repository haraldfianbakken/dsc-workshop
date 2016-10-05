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
            #ConfigurationID = "9D81A5A6-8A23-11E6-80BA-00155D865100"                     
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

        
        PartialConfiguration ClientConfig {
            RefreshMode = 'Pull'
            ConfigurationSource = '[ConfigurationRepositoryWeb]PullServerConfig'
            ResourceModuleSource = '[ResourceRepositoryWeb]ResourceServer'
        }

    }
}

