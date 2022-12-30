param (
    $moduleName,
    $description,
    $author = 'Karol Cyrankowski',
    $gitPath = "C:\Users\Karol\Repos\HomePowershellScripts\Modules"
)

$path = Join-Path $gitPath -ChildPath $moduleName
$ModulePath = Join-Path $path "$moduleName.psm1"
$moduleSettings = @{
    RootModule        = $($ModulePath | Split-Path -Leaf)
    ModuleVersion     = '1.0'
    # CompatiblePSEditions = @()
    GUID              = (New-Guid).Guid
    Author            = $Author
    CompanyName       = 'Unknown'
    Copyright         = "(c) 2022 $Author. All rights reserved."
    Description       = $description
    PowerShellVersion = 5.1
    # PowerShellHostName = ''
    # PowerShellHostVersion = ''
    # DotNetFrameworkVersion = ''
    # CLRVersion = ''
    # ProcessorArchitecture = ''
    # RequiredModules = @()
    # RequiredAssemblies = @()
    # ScriptsToProcess = @()
    # TypesToProcess = @()
    # FormatsToProcess = @()
    # NestedModules = @()
    # FunctionsToExport = @()
    # CmdletsToExport = @()
    # VariablesToExport = '*'
    # AliasesToExport = @()
    # DscResourcesToExport = @()
    # ModuleList = @()
    # FileList = @()
    #PrivateData       = @{
    #    PSData = @{
    # Tags = @()
    # LicenseUri = ''
    # ProjectUri = ''
    # IconUri = ''
    # ReleaseNotes = ''
    #    } # End of PSData hashtable
    #} # End of PrivateData hashtable
    # HelpInfoURI = ''
    # DefaultCommandPrefix = ''
}

$psm1Content = @"
# Created by $author 
# Created on $(Get-Date -Format "yyyy-MM-dd") 

#Functions
#Function test-Mouduleimport {"Module Imported"} 
#mainScript 

#Export-ModuleMember -Function * -Alias ""

"@




if (test-path $path) {
    Write-Host "Module exists.. please delete that or chose a diffrent name"
    break 
}

Write-Host "Creating manifest.."
[void](New-Item -ItemType Directory -Path $path)
$ModuleManifestPath = Join-Path $path "$moduleName.psd1"
New-ModuleManifest -Path $ModuleManifestPath @moduleSettings


$psm1Content | Out-File -FilePath $ModulePath -Encoding UTF8


