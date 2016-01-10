$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$file = Get-ChildItem "$here\$sut"
. "$here\$sut"


Describe "$sut" -Tags Unit{
    #region Top Data
    $DesiredUserProfile = Get-Item -Path TestDrive:\
    
    Mock -CommandName Get-Item -ParameterFilter {$path -eq $env:USERPROFILE} -MockWith {$DesiredUserProfile}

    It "has test drive information for $((Get-PSDrive -Name TestDrive).Root)"{
        (Get-PSDrive -Name TestDrive).Root | Should Exist
    }
    
    It "Mocks $((Get-Item -Path TestDrive:).FullName) correctly"{
        (Get-Item -Path $env:USERPROFILE).FullName | Should Be (Get-Item -Path TestDrive:).FullName
    }
    #endregion Top Data#>

    #region Script File Text Context
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
    }
    #endregion Script File Text Context

    #region New-CustomModule without TargetxModulesDirectory argument
    Context "New-CustomModule without TargetxModulesDirectory argument" {
        #region context truths
        $TestModuleName = "TESTMODULENAME"
        $TestxModulesFolderPath = 'TestDrive:\Documents\xModules'
        $TestModuleNameFolderPath = "$TestxModulesFolderPath\TESTMODULENAME"
        $TestModuleFunctionsFolder = "$TestModuleNameFolderPath\Functions"
        
        $TestModuleModuleResourcesFolder = "$TestModuleNameFolderPath\ModuleResources"
        $TestModuleRequiredModulesFolder = "$TestModuleNameFolderPath\RequiredModules"

        $TestModuleManifestFile = "$TestModuleNameFolderPath\TESTMODULENAME.psd1"
        $TestModuleModuleFile = "$TestModuleNameFolderPath\TESTMODULENAME.psm1"

        $TestModuleRequiredModulesLoaderFile = "$TestModuleNameFolderPath\RequiredModulesLoader.ps1"

        $TestModuleInfoFunctionfile = "$TestModuleFunctionsFolder\get-TESTMODULENAMEModuleInformation.ps1"
        #endregion
        #region tests
        It "Runs successfully without the TargetxModulesDirectory argument" {

            {New-CustomModule -NewModuleName $TestModuleName -author PesterTest -description "Test Description"} | Should Not Throw
            
        }

        It "Gets the users profile by the environment variable" {
        
            Assert-MockCalled -CommandName Get-Item -Times 1 -ParameterFilter {$path -eq $env:USERPROFILE} -Scope Context -Exactly

        }

        It "Creates an xModules folder" {
        
            $TestxModulesFolderPath | Should Exist
        
        }
        
        It "Creates a module folder for this module" {
        
            $TestModuleNameFolderPath | Should Exist
        
        }
        
        It "Creates a Functions folder"{
        
            $TestModuleFunctionsFolder | Should Exist
        
        }
        
        It "Creates a ModuleResources folder"{
        
            $TestModuleModuleResourcesFolder | Should Exist
        
        }
        
        It "Creates a RequiredModules folder"{
        
            $TestModuleRequiredModulesFolder | Should Exist
        
        }
        
        It "Creates a manifest file"{
        
            $TestModuleManifestFile | Should Exist
        
        }

        It "The manifest is valid powershell (has no script errors)" {
    
            $content = Get-Content -Path $TestModuleManifestFile -ErrorAction Stop
            $errors = $null
            $null = [System.Management.Automation.PSParser]::Tokenize($content,[ref]$errors)
    
            $errors.Count | Should Be 0
        }
        
        It "Creates a module file"{
        
            $TestModuleModuleFile | Should Exist
        
        }

        It "The module is valid powershell (has no script errors)" {
    
            $content = Get-Content -Path $TestModuleModuleFile -ErrorAction Stop
            $errors = $null
            $null = [System.Management.Automation.PSParser]::Tokenize($content,[ref]$errors)
    
            $errors.Count | Should Be 0
        }

        It "Passes the PSScriptAnalyzer analysis on the module file"{
            (Invoke-ScriptAnalyzer -Path $TestModuleModuleFile) | Should BeNullOrEmpty
        }
        
        It "Creates a RequiredModulesLoader file"{
        
            $TestModuleRequiredModulesLoaderFile | Should Exist
        
        }

        It "The RequiredModulesLoader file is valid powershell (has no script errors)" {
    
            $content = Get-Content -Path $TestModuleRequiredModulesLoaderFile -ErrorAction Stop
            $errors = $null
            $null = [System.Management.Automation.PSParser]::Tokenize($content,[ref]$errors)
    
            $errors.Count | Should Be 0
        }

        It "Passes the PSScriptAnalyzer analysis on RequiredModulesLoader"{
            (Invoke-ScriptAnalyzer -Path $TestModuleRequiredModulesLoaderFile) | Should BeNullOrEmpty
        }

        It "Creates the info function"{
        
            $TestModuleInfoFunctionfile | Should Exist

        }

        It "The info function is valid powershell (has no script errors)" {
    
            $content = Get-Content -Path $TestModuleInfoFunctionfile -ErrorAction Stop
            $errors = $null
            $null = [System.Management.Automation.PSParser]::Tokenize($content,[ref]$errors)
    
            $errors.Count | Should Be 0
        }

        It "Passes the PSScriptAnalyzer analysis on the info function"{
            (Invoke-ScriptAnalyzer -Path $TestModuleInfoFunctionfile) | Should BeNullOrEmpty
        }
        #endregion
    }
    #endregion New-CustomModule without TargetxModulesDirectory argument#>

    #region New-CustomModule with TargetxModulesDirectory argument
    Context "New-CustomModule with TargetxModulesDirectory argument" {
        #region Context Truths
        $TestModuleName = "TESTMODULENAMEwARG"
        $TestxModulesFolderPath = 'TestDrive:\TESTMODULEFolder'
        $TestModuleNameFolderPath = "$TestxModulesFolderPath\TESTMODULENAMEwARG"
        $TestModuleFunctionsFolder = "$TestModuleNameFolderPath\Functions"

        $TestModuleModuleResourcesFolder = "$TestModuleNameFolderPath\ModuleResources"
        $TestModuleRequiredModulesFolder = "$TestModuleNameFolderPath\RequiredModules"

        $TestModuleManifestFile = "$TestModuleNameFolderPath\TESTMODULENAMEwARG.psd1"
        $TestModuleModuleFile = "$TestModuleNameFolderPath\TESTMODULENAMEwARG.psm1"

        $TestModuleRequiredModulesLoaderFile = "$TestModuleNameFolderPath\RequiredModulesLoader.ps1"

        $TestModuleInfoFunctionfile = "$TestModuleFunctionsFolder\get-TESTMODULENAMEwARGModuleInformation.ps1"
        #endregion

        It "Runs successfully with the TargetxModulesDirectory argument" {

            {New-CustomModule -NewModuleName $TestModuleName -author PesterTest -description "Test Description" -TargetxModulesDirectory $TestxModulesFolderPath} | Should Not Throw
            $TestModuleNameFolderPath | Should Exist
        
        }

        It "Does not get the users profile by the environment variable" {
        
            Assert-MockCalled -CommandName Get-Item -Times 0 -ParameterFilter {$path -eq $env:USERPROFILE} -Scope Context -Exactly

        }

        It "Creates an module folder for this module" {
        
            $TestModuleNameFolderPath | Should Exist
        
        }

        It "Creates a Functions folder"{
        
            $TestModuleFunctionsFolder | Should Exist
        
        }

        It "Creates a ModuleResources folder"{
        
            $TestModuleModuleResourcesFolder | Should Exist
        
        }
        
        It "Creates a RequiredModules folder"{
        
            $TestModuleRequiredModulesFolder | Should Exist
        
        }
        
        It "Creates a manifest file"{
        
            $TestModuleManifestFile | Should Exist
        
        }

        It "The manifest is valid powershell (has no script errors)" {
    
            $content = Get-Content -Path $TestModuleManifestFile -ErrorAction Stop
            $errors = $null
            $null = [System.Management.Automation.PSParser]::Tokenize($content,[ref]$errors)
    
            $errors.Count | Should Be 0
        }
        
        It "Creates a module file"{
        
            $TestModuleModuleFile | Should Exist
        
        }

        It "The module is valid powershell (has no script errors)" {
    
            $content = Get-Content -Path $TestModuleModuleFile -ErrorAction Stop
            $errors = $null
            $null = [System.Management.Automation.PSParser]::Tokenize($content,[ref]$errors)
    
            $errors.Count | Should Be 0
        }

        It "Passes the PSScriptAnalyzer analysis on the module file"{
            (Invoke-ScriptAnalyzer -Path $TestModuleModuleFile) | Should BeNullOrEmpty
        }

        It "Creates the info function"{
        
            $TestModuleInfoFunctionfile | Should Exist

        }

        It "The info function is valid powershell (has no script errors)" {
    
            $content = Get-Content -Path $TestModuleInfoFunctionfile -ErrorAction Stop
            $errors = $null
            $null = [System.Management.Automation.PSParser]::Tokenize($content,[ref]$errors)
    
            $errors.Count | Should Be 0
        }

        It "Passes the PSScriptAnalyzer analysis on the info function"{
            (Invoke-ScriptAnalyzer -Path $TestModuleInfoFunctionfile) | Should BeNullOrEmpty
        }
    }
    #endregion New-CustomModule with TargetxModulesDirectory argument#>

    #region New-CustomModule with whatif

    #endregion
}
