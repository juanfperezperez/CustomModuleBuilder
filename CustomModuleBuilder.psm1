$ModuleFile = $MyInvocation.MyCommand.Path
$ModuleRoot = Split-Path -Path $ModuleFile -Parent

Write-Verbose "Importing Functions"
#Import everything in the "Functions" folder
"$ModuleRoot\Functions\*.ps1" |
    Resolve-Path |
        Where-Object {-not ($_.ProviderPath.Contains(".Tests."))} |
            ForEach-Object {. $_.ProviderPath; Write-Verbose $_.ProviderPath}

$availableModules = Get-Module -ListAvailable -Name Pester,PSScriptAnalyzer | Select-Object -ExpandProperty Name

if(('Pester' -notin $availableModules) -or ('PSScriptAnalyzer' -notin $availableModules)){
    Write-Debug  -Message "Pester and PSScriptAnalyzer are required to run the tests included in this module"
}