$script:ThisScript = $MyInvocation.MyCommand.Path
$script:ModuleRoot = Split-Path -Path $ThisScript -Parent

$IncludedModules = Get-ChildItem -Directory -Path "$script:ModuleRoot\RequiredModules\"

$ImportedModules = @()
foreach ($IncludedModule in $IncludedModules){
    If($null -ne (Get-Module -ListAvailable -Name $IncludedModule.BaseName)){
        $Module = Get-Module -ListAvailable -Name $IncludedModule.BaseName
    }
    else{
        $Module = Get-Module -ListAvailable -Name $IncludedModule.FullName
    }
    If(($null -ne $Module) -and ($Module.ExportedCommands.Count -gt 0)){
        $ImportedModules += $Module | Import-Module -PassThru
    }
}
