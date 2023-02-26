# Sample Shells
#PowerShell version 
$PSVersionTable.PSVersion

#Azure Connect
Connect-AzAccount
# Parameters
$ResourceGroup = "azKeytestg123";
$location="eastus";
$keyVaultName = "aztestvault2021"; #Must be unique

#Create a Resource Group
New-AzResourceGroup -Name $ResourceGroup -Location $location

#Create a KeyVault
New-AzKeyVault -Name $keyVaultName -ResourceGroupName $ResourceGroup -Location $location

#Certificate Policy parameters
$SubjectName = "CN=MYTestCA.com"
$IssuerName = "Self" 
$validity = 6
$KeySize = 2048
$RenewDays = 10
$DnsName = "MYTestCA.com"
$KeyType = "RSA"
$oid1= "1.3.6.1.5.5.7.3.1"
$oid1= "1.3.6.1.5.5.7.3.2"
$KeyUsage1 = "DigitalSignature"
$KeyUsage2 = "KeyCertSign"

# Setup the policy to create a certificate
$Policy = New-AzKeyVaultCertificatePolicy -SecretContentType "application/x-pkcs12" -SubjectName $SubjectName -IssuerName $IssuerName -ValidityInMonths $validity -ReuseKeyOnRenewal -KeySize $KeySize -RenewAtNumberOfDaysBeforeExpiry $RenewDays -CertificateTransparency 0 -DnsName $DnsName -KeyType $KeyType -Ekus $oid1,$oid1 -KeyUsage $KeyUsage1,$KeyUsage2

$nameofcert="MYCERT1"
# Creat a certificate
$certificateOps = Add-AzKeyVaultCertificate -VaultName $keyVaultName -Name $nameofcert -CertificatePolicy $Policy

#PrintCSR
$certificateOps.CertificateSigningRequest

#Create a file for CSR
$csrFile = "C:\cert\cert1.csr"

#Add content to csr format
Add-Content -Path $csrFile -Value "-----BEGIN CERTIFICATE REQUEST-----" -Encoding Ascii
Add-Content -Path $csrFile -Value $certRequest.CertificateSigningRequest -Encoding Ascii
Add-Content -Path $csrFile -Value "-----END CERTIFICATE REQUEST-----" -Encoding Ascii

########################
# copy the csr, Sign a CA using CSR. 
# import to CA 
########################


$crtFile = "C:\cert\cert1.cer"
$Name = "MYCERT1"
#Import certificate to the keyvault
Import-AzKeyVaultCertificate -VaultName $keyVaultName -Name $Name -FilePath $crtFile

#Certificate Status
Get-AzKeyVaultCertificate -VaultName $keyVaultName -Name $nameofcert

########################
# import a pfx certificate 
########################

$pfxPassword = "123"

$Password = ConvertTo-SecureString -String $pfxPassword -AsPlainText -Force
$filePath = "C:\cert\MyCertificate.pfx"
$Name = "m365proguide"
Import-AzKeyVaultCertificate -VaultName $keyVaultName -Name $Name -FilePath $filePath -Password $Password
Get-AzKeyVaultCertificate -VaultName $keyVaultName -Name $Name
########################
# remove the resource group  
########################

#Remove Azure Resource Group
Remove-AzResourceGroup -Name "$ResourceGroup"
