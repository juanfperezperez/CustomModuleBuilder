#Requires -Module PSScriptAnalyzer
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$file = Get-ChildItem "$here\$sut"
. "$here\$sut"

Describe "$sut" -Tags Unit {
    
    Context "Script File test" {
        It "Is valid powershell (has no script errors)" {
    
            $content = Get-Content -Path $file -ErrorAction Stop
            $errors = $null
            $null = [System.Management.Automation.PSParser]::Tokenize($content,[ref]$errors)
    
            $errors.Count | Should Be 0
        }

        It "Passes the PSScriptAnalyzer analysis"{
            (Invoke-ScriptAnalyzer -Path $file) | Should BeNullOrEmpty
        }

        It "Has the module loaded"{
        
            (Get-Module -Name CustomModuleBuilder) | Should Not Be $null
        
        }
    }

    Context "Running behavior" {
    
        It "Runs without errors" {
        
            {(Get-CustomModuleBuilderModuleInformation)} | Should Not Throw
        
        }

    }
    
}