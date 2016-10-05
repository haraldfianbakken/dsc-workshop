Configuration SimpleConfig {
    
    Import-DscResource -ModuleName PSDesiredStateconfiguration;
    
    Node localhost {

        LocalConfigurationManager {
            RefreshMode = 'Push'
            RebootNodeIfNeeded = $true
        }

        File Test {
            Ensure = 'Present'            
            Type = 'File' 
            DestinationPath = 'C:\tmp\Test.txt'
            Contents = 'Hello world'
            Checksum = 'SHA-1'
            Force = $true 
        }
    }

}