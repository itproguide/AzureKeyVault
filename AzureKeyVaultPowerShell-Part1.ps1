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

$nameofcert="MYCERT"
# Creat a certificate
Add-AzKeyVaultCertificate -VaultName $keyVaultName -Name $nameofcert -CertificatePolicy $Policy

Get-AzKeyVaultCertificate -VaultName $keyVaultName -Name $nameofcert

Remove-AzResourceGroup -Name "$ResourceGroup"
