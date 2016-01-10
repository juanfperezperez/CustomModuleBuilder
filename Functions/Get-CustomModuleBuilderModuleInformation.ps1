<#
.Synopsis
   Gets custom module information for module CustomModuleBuilder
.DESCRIPTION
   Gets custom module information for module CustomModuleBuilder
.EXAMPLE
   Get-CustomModuleBuilderModuleInformation
#>
function Get-CustomModuleBuilderModuleInformation
{
    [CmdletBinding()]
    [Alias()]
    Param()
    Begin{}
    Process
    {
        If($null -ne (Get-Module -Name CustomModuleBuilder)){
            Get-Module -Name CustomModuleBuilder | Select-Object -Property Name,Author,Description,GUID
        }Else{
        
            Throw 'Module not found'
        
        }
    }
    End{}
}
