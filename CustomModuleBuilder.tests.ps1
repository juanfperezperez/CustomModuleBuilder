#Requires -Module PSScriptAnalyzer

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$module = Split-Path -Leaf $here

Describe "Module: $module" -Tags Unit {
    
    Context "Module Configuration" {
        
        It "Has a root module file ($module.psm1)"{
        
            "$here\$module.psm1" | Should Exist

        }

        It "Is valid PowerShell (has no script errors)" {
        
            $content = Get-Content -Path "$here\$module.psm1" -ErrorAction Stop
            $errors = $null
            $null = [System.Management.Automation.PSParser]::Tokenize($content,[ref]$errors)
            $errors.Count | Should Be 0
        
        }

        It "Passes the PSScriptAnalyzer analisys on the root module"{
            (Invoke-ScriptAnalyzer -Path "$here\$module.psm1") | Should BeNullOrEmpty
        }

        It "Has a manifest file ($module.psd1)" {
        
            "$here\$module.psd1" | Should Exist

        }

        It "Contains a root module path in the manifest (RootModule = '.\$module.psm1')"{
        
            "$here\$module.psd1" | Should Exist
            "$here\$module.psd1" | Should Contain "\.\\$module.psm1"
        
        }

        It "Contains the RequiredModulesLoader path in the manifest (ScriptsToProcess = @('RequiredModulesLoader.ps1'))"{
        
            "$here\$module.psd1" | Should Exist
            "$here\$module.psd1" | Should Contain "RequiredModulesLoader.ps1"
        
        }

        It "Passes the Test-ModuleManifest test on the manifest file"{
        
            {Test-ModuleManifest -Path "$here\$module.psd1"} | Should Not Throw
        
        }

        It "Has a functions folder"{
        
            "$here\functions" | Should Exist

        }

        It "Has functions in the functions folder" {
        
            "$here\functions\*.ps1" | Should Exist
        
        }

        It "Has a ModuleResources folder"{
        
            "$here\ModuleResources" | Should Exist

        }

        It "Has a RequiredModules folder"{
        
            "$here\RequiredModules" | Should Exist

        }

    }
    
    $Functions = Get-ChildItem "$here\functions\*.ps1" -ErrorAction SilentlyContinue |
            Where-Object {$_.Name -notmatch "Tests.ps1"}

    foreach($CurrentFunction in $Functions){

        Context "Function $module::$($CurrentFunction.BaseName)"{
                
            It "Has a pester test"{
                
                $CurrentFunction.FullName.Replace(".ps1",".Tests.ps1") | Should Exist
                
            }
            
            It "Has a show help comment block"{
                
                $CurrentFunction.FullName | Should Contain '<#'
                $CurrentFunction.FullName | Should Contain '#>' 
                
            }

            It "Show help comment block has a synopsis"{
                
                $CurrentFunction.FullName | Should Contain '\.SYNOPSIS'
                
            }
                
            It "Show help comment block has a example"{
                
                $CurrentFunction.FullName | Should Contain '\.EXAMPLE'
                
            }
                
            It "Is an advanced function"{
                
                $CurrentFunction.FullName | Should Contain 'function'
                $CurrentFunction.FullName | Should Contain 'cmdletbinding'
                $CurrentFunction.FullName | Should Contain 'param'
                
            }

            It "Is valid PowerShell (has no script errors)" {
                
                $content = Get-Content -Path $CurrentFunction.FullName -ErrorAction Stop
                $errors = $null
                $null = [System.Management.Automation.PSParser]::Tokenize($content,[ref]$errors)
                $errors.Count | Should Be 0
                
            }

            It "Passes the PSScriptAnalyzer analisys"{
                (Invoke-ScriptAnalyzer -Path $CurrentFunction.FullName) | Should BeNullOrEmpty
            }
        }
    }
}
