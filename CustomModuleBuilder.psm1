$ModuleFile = $MyInvocation.MyCommand.Path
$ModuleRoot = Split-Path -Path $ModuleFile -Parent

Remove-Module -Name RequiredModulesLoader

Write-Verbose "Importing Functions"
#Import everything in the "Functions" folder
"$ModuleRoot\Functions\*.ps1" |
    Resolve-Path |
        Where-Object {-not ($_.ProviderPath.Contains(".Tests."))} |
            ForEach-Object {. $_.ProviderPath; Write-Verbose $_.ProviderPath}
