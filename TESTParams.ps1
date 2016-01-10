function TestParams
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
param(

[Parameter(Mandatory=$true,
           ValueFromPipelineByPropertyName=$False,
           Position=0)]
[string]
$NewModuleName,

[Parameter(Mandatory=$true,
           ValueFromPipelineByPropertyName=$False,
           Position=0)]
[string]
$Author,

[Parameter(Mandatory=$true,
           ValueFromPipelineByPropertyName=$False,
           Position=0)]
[string]
$Description,

[Parameter(Mandatory=$False,
           ValueFromPipelineByPropertyName=$False,
           Position=0)]
[string]
$TargetxModulesDirectory = "$(Join-Path -Path ((Get-Item -Path $env:USERPROFILE).FullName) -ChildPath '\Documents\xModules')",

[Parameter(Mandatory=$False,
           ValueFromPipelineByPropertyName=$False,
           Position=0)]
[string]
$CompanyName,

[Parameter(Mandatory=$False,
           ValueFromPipelineByPropertyName=$False,
           Position=0)]
[string]
$Copyright,

[Parameter(Mandatory=$False,
           ValueFromPipelineByPropertyName=$False,
           Position=0)]
[System.Version]
$ModuleVersion,

[Parameter(Mandatory=$False,
           ValueFromPipelineByPropertyName=$False,
           Position=0)]
[System.Reflection.ProcessorArchitecture]
$ProcessorArchitecture,

[Parameter(Mandatory=$False,
           ValueFromPipelineByPropertyName=$False,
           Position=0)]
[System.Version]
$PowerShellVersion,

[Parameter(Mandatory=$False,
           ValueFromPipelineByPropertyName=$False,
           Position=0)]
[System.Version]
$ClrVersion,

[Parameter(Mandatory=$False,
           ValueFromPipelineByPropertyName=$False,
           Position=0)]
[System.Version]
$DotNetFrameworkVersion,

[Parameter(Mandatory=$False,
           ValueFromPipelineByPropertyName=$False,
           Position=0)]
[string]
$PowerShellHostName,

[Parameter(Mandatory=$False,
           ValueFromPipelineByPropertyName=$False,
           Position=0)]
[System.Version]
$PowerShellHostVersion,

[Parameter(Mandatory=$False,
           ValueFromPipelineByPropertyName=$False,
           Position=0)]
[object[]]
$RequiredModules,

[Parameter(Mandatory=$False,
           ValueFromPipelineByPropertyName=$False,
           Position=0)]
[string[]]
$RequiredAssemblies

)

begin{}
Process{
    
    $ManifestInfo = $PSCmdlet.MyInvocation.BoundParameters

    $ManifestInfo.Add("Path",(Join-Path -Path $NewModuleDirectory.FullName -ChildPath ($NewModuleName + '.psd1')))
    $ManifestInfo.Add("RootModule",('.\' + $NewModuleName + '.psm1'))

    $ManifestInfo.Remove("NewModuleName")
    $ManifestInfo.Remove("TargetxModulesDirectory")
    
}
end{}



}