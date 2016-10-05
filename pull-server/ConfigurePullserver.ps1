configuration ConfigurePullServer
{ 
    param  
    ( 
            [string[]]$NodeName = 'localhost',             
            [string] $certificateThumbPrint='AllowUnencryptedTraffic',
            [Parameter(Mandatory)]
            [ValidateNotNullOrEmpty()]
            [string] $RegistrationKey 
     ) 

     Import-DSCResource -ModuleName xPSDesiredStateConfiguration 

     Node $NodeName 
     {                        
         WindowsFeature NET-Framework-Core 
         { 
             Ensure = 'Present'
             Name   = 'NET-Framework-Core'  
             IncludeAllSubFeature = $true            
         } 

         WindowsFeature DSCServiceFeature 
         { 
             DependsOn = '[WindowsFeature]NET-Framework-Core'
             Ensure = 'Present'
             Name   = 'DSC-Service'  
             IncludeAllSubFeature = $true                    
         } 

        File RegistrationKeyFile
        {
            Ensure          = 'Present'
            Type            = 'File'
            DestinationPath = "$($env:ProgramFiles)\WindowsPowerShell\DscService\RegistrationKeys.txt"
            Contents = $RegistrationKey
            Force = $true
        }

         xDscWebService PSDSCPullServer 
         { 
             Ensure                  = 'Present' 
             EndpointName            = 'PSDSCPullServer' 
             Port                    = 80
             PhysicalPath            = "$env:SystemDrive\inetpub\wwwroot\PSDSCPullServer" 
             CertificateThumbPrint   = "$certificateThumbPrint"                       
             ModulePath              = "C:\DSCPull\Modules" 
             ConfigurationPath       = "C:\DSCPull\Configuration" 
             State                   = 'Started'
             DependsOn               = '[WindowsFeature]DSCServiceFeature'                         
         }       
    }
}


