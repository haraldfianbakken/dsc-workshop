# DSC Workshop 

A DSC & Powershell Workshop

1. <a href="01.md">DSC basics</a>    
2. <a href="02.md">Remoting and modules</a>    
3. <a href="03.md">Packagemanagement</a>   
4. <a href="04.md">Composite resources</a>
5. <a href="05.md">Pull server - Extended</a>
6. <a href="06.md">Azure Automation</a>

## Other stuff

# Setting up certificates Create certificate on target 

$cert = New-SelfSignedCertificate -Type DocumentEncryptionCertLegacyCsp -DnsName 'DscEncryptionCert' -HashAlgorithm SHA256
$cert | Export-Certificate -FilePath "$env:temp\DscPublicKey.cer" -Force

# Then import on authoring
Import-Certificate -FilePath "$env:temp\DscPublicKey.cer" -CertStoreLocation Cert:\LocalMachine\My

# Create certificate on author
cert = New-SelfSignedCertificate -Type DocumentEncryptionCertLegacyCsp -DnsName 'DscEncryptionCert' -HashAlgorithm SHA256
$mypwd = ConvertTo-SecureString -String "YOUR_PFX_PASSWD" -Force -AsPlainText
$cert | Export-PfxCertificate -FilePath "$env:temp\DscPrivateKey.pfx" -Password $mypwd -Force
$cert | Export-Certificate -FilePath "$env:temp\DscPublicKey.cer" -Force
$cert | Remove-Item -Force
Import-Certificate -FilePath "$env:temp\DscPublicKey.cer" -CertStoreLocation Cert:\LocalMachine\My

# Import on target
$mypwd = ConvertTo-SecureString -String "YOUR_PFX_PASSWD" -Force -AsPlainText
Import-PfxCertificate -FilePath "$env:temp\DscPrivateKey.pfx" -CertStoreLocation Cert:\LocalMachine\Root -Password $mypwd > $null

#https://msdn.microsoft.com/en-us/powershell/dsc/securemof