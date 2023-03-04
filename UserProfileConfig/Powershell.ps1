# Install Modules
$modulesToInstall = $(
    "Microsoft.PowerShell.SecretManagement",
    "Microsoft.PowerShell.SecretStore",
    "Importexcel",
    "psyml",
    "az",
    "SecretManagement.JustinGrote.CredMan",
    "subnet"
)

Set-PSRepository PSGallery -InstallationPolicy Trusted
$isntalledModules = Get-InstalledModule 
foreach ($module in $($modulesToInstall | Where-Object {$_ -notin $isntalledModules.name})){
    Install-Module -Name $module  -Repository PSGallery -Scope CurrentUser -Confirm:$false
}
update-module -Confirm:$false

# Setup secret vault
Register-SecretVault -Name credMan -ModuleName SecretManagement.JustinGrote.CredMan

