<#
.Synopsis
   Creates a new custom module 
.DESCRIPTION
   Creates a new custom module with a single cmdlet that outputs basic module information. The module files are created in the users documents folder ina folder called xModules
.EXAMPLE
   New-CustomModule
.EXAMPLE
   Another example of how to use this cmdlet
#>
function New-CustomModule
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # Specifies the module name.
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$False,
                   Position=0)]
        [string]
        $NewModuleName,

        # Specifies the module author.
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$False,
                   Position=0)]
        [string]
        $Author,

        # Describes the contents of the module.
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$False,
                   Position=0)]
        [string]
        $Description,

        # Specifies the path where the new module will be created. Default is "%USERPROFILE%\Documents\xModules".
        [Parameter(Mandatory=$False,
                   ValueFromPipelineByPropertyName=$False,
                   Position=0)]
        [string]
        $TargetxModulesDirectory = "$(Join-Path -Path ((Get-Item -Path $env:USERPROFILE).FullName) -ChildPath '\Documents\xModules')",

        # Identifies the company or vendor who created the module.
        [Parameter(Mandatory=$False,
                   ValueFromPipelineByPropertyName=$False,
                   Position=0)]
        [string]
        $CompanyName,

        # Specifies a copyright statement for the module.
        [Parameter(Mandatory=$False,
                   ValueFromPipelineByPropertyName=$False,
                   Position=0)]
        [string]
        $Copyright,

        # Specifies the version of the module.
        [Parameter(Mandatory=$False,
                   ValueFromPipelineByPropertyName=$False,
                   Position=0)]
        [System.Version]
        $ModuleVersion,

        # Specifies the processor architecture that the module requires. Valid values are x86, AMD64, IA64, and None (unknown or unspecified).
        [Parameter(Mandatory=$False,
                   ValueFromPipelineByPropertyName=$False,
                   Position=0)]
        [System.Reflection.ProcessorArchitecture]
        $ProcessorArchitecture,

        # Specifies the minimum version of Windows PowerShell that will work with this module. For example, you can enter 1.0, 2.0, or 3.0 as the value of this parameter.
        [Parameter(Mandatory=$False,
                   ValueFromPipelineByPropertyName=$False,
                   Position=0)]
        [System.Version]
        $PowerShellVersion,

        # Specifies the minimum version of the Common Language Runtime (CLR) of the Microsoft .NET Framework that the module requires.
        [Parameter(Mandatory=$False,
                   ValueFromPipelineByPropertyName=$False,
                   Position=0)]
        [System.Version]
        $ClrVersion,

        # Specifies the minimum version of the Microsoft .NET Framework that the module requires.
        [Parameter(Mandatory=$False,
                   ValueFromPipelineByPropertyName=$False,
                   Position=0)]
        [System.Version]
        $DotNetFrameworkVersion,

        # Specifies the name of the Windows PowerShell host program that the module requires. Enter the name of the host program, such as "Windows PowerShell ISE Host" or "ConsoleHost". Wildcards are not permitted.
        [Parameter(Mandatory=$False,
                   ValueFromPipelineByPropertyName=$False,
                   Position=0)]
        [string]
        $PowerShellHostName,

        # Specifies the minimum version of the Windows PowerShell host program that works with the module. Enter a version number, such as 1.1
        [Parameter(Mandatory=$False,
                   ValueFromPipelineByPropertyName=$False,
                   Position=0)]
        [System.Version]
        $PowerShellHostVersion,

        # Specifies modules that must be in the global session state. If the required modules are not in the global session state, Windows PowerShell imports them. If the required modules are not available, the Import-Module command fails.
        [Parameter(Mandatory=$False,
                   ValueFromPipelineByPropertyName=$False,
                   Position=0)]
        [object[]]
        $RequiredModules,

        # Specifies the assembly (.dll) files that the module requires. Enter the assembly file names.
        [Parameter(Mandatory=$False,
                   ValueFromPipelineByPropertyName=$False,
                   Position=0)]
        [string[]]
        $RequiredAssemblies,

        # Includes the PSDynamicParameters module in the Functions directory.
        [Parameter(Mandatory=$False,
                   Position=0)]
        [switch]
        $IncludeDynamicParametersModule
    )

    Begin{
        $ShouldProces = $PSCmdlet.ShouldProcess((Join-Path -Path $TargetxModulesDirectory -ChildPath $NewModuleName))
        $Verbosity = $PSBoundParameters['Verbose'] -eq $true
        $WhatIf = $PSBoundParameters['WhatIf'] -eq $true
        $Confirm = $PSBoundParameters['Confirm'] -eq $true
        $ConfirmStop = ($Confirm -eq $true) -and ($ShouldProces -eq $False)
        
        if(-not $ConfirmStop){
            #region Experimental Modules location variables
            $xModulesDirectory = If(-not (Test-Path $TargetxModulesDirectory)){
                if($ShouldProces){New-Item -Path $TargetxModulesDirectory -ItemType Directory -Force -Verbose:$Verbosity -WhatIf:$WhatIf}
                else{New-Object -TypeName psobject -Property @{FullName = $TargetxModulesDirectory}}
            }else{
                if($ShouldProces){Get-Item -Path $TargetxModulesDirectory -Verbose:$Verbosity}
                else{New-Object -TypeName psobject -Property @{FullName = $TargetxModulesDirectory}}
            }
            $xModulesDirectoryPath = $xModulesDirectory.FullName
            #endregion
        
            # add the current location to the stack
            Push-Location -StackName ModuleBuilderLocationStack -Verbose:$Verbosity
        
            #set location for running the function
            if($ShouldProces){Set-Location -Path $xModulesDirectoryPath -Verbose:$Verbosity}
        }
    }

    Process{
        if(-not $ConfirmStop){

            #region Create xModulePath variable and the module starting file structure
        
            #Creates the root module directory which will contain all else
            $NewModuleDirectory = New-Item -ItemType Directory -Path $xModulesDirectoryPath -Name $NewModuleName -Verbose:$Verbosity -WhatIf:$WhatIf
            if(-not $ShouldProces){$NewModuleDirectory = New-Object -TypeName psobject -Property @{FullName=(Join-Path -Path $xModulesDirectoryPath -ChildPath $NewModuleName)}}

            #Creates the Functions directory which will contain all the function scripts
            $NewModuleFunctionsDirectory = New-Item -ItemType Directory -Path $NewModuleDirectory.FullName -Name 'Functions' -Verbose:$Verbosity -WhatIf:$WhatIf
            if(-not $ShouldProces){$NewModuleFunctionsDirectory = New-Object -TypeName psobject -Property @{FullName=(Join-Path -Path $NewModuleDirectory.FullName -ChildPath 'Functions')}}

			#Copies the PSDynamicParameters to the Functions directory
			if($IncludeDynamicParametersModule){Copy-Item -Path (Join-Path -Path $ModuleRoot -ChildPath "Functions\PSDynamicParameters.psm1") -Destination $NewModuleFunctionsDirectory}

            #Creates the ModuleResources directory which will contain additional files needed by the module
            $NewModuleResourcesDirectory = New-Item -ItemType Directory -Path $NewModuleDirectory.FullName -Name 'ModuleResources' -Verbose:$Verbosity -WhatIf:$WhatIf
            if(-not $ShouldProces){$NewModuleResourcesDirectory = New-Object -TypeName psobject -Property @{FullName=(Join-Path -Path $NewModuleDirectory.FullName -ChildPath 'ModuleResources')}}
            #Write-Verbose -Message "New module resources driectory is $(Resolve-Path -Path $NewModuleResourcesDirectory.FullName -Relative)" -Verbose:$Verbosity
            
            #endregion

            #region Generate the module manifest
            $ManifestInfo = $PSCmdlet.MyInvocation.BoundParameters

        
            Write-Verbose -Message "Setting Manifest Path to $(Join-Path -Path $NewModuleDirectory.FullName -ChildPath ($NewModuleName + '.psd1'))" -Verbose:$Verbosity
            $ManifestInfo.Add("Path",(Join-Path -Path $NewModuleDirectory.FullName -ChildPath ($NewModuleName + '.psd1')))
        
            Write-Verbose -Message "Setting Manifest RootModule to $('.\' + $NewModuleName + '.psm1')" -Verbose:$Verbosity
            $ManifestInfo.Add("RootModule",('.\' + $NewModuleName + '.psm1'))

            $ManifestInfo.Remove("NewModuleName") | Out-Null

            $ManifestInfo.Remove("TargetxModulesDirectory") | Out-Null

            $ManifestInfo.Remove("Confirm") | Out-Null

			$ManifestInfo.Remove("IncludeDynamicParametersModule") | Out-Null


            New-ModuleManifest @ManifestInfo #-Verbose:$Verbosity
            #endregion Generate the module manifest

            #region Generate Module loader for all the functions
            $ModuleLoader = Get-Content -Path (Join-Path -Path $ModuleRoot -ChildPath "\ModuleResources\ModuleLoaderScriptTemplate.txt") -Raw -Verbose:$Verbosity
            Set-Content -Value $ModuleLoader -Path (Join-Path -Path $NewModuleDirectory.FullName -ChildPath ($NewModuleName + '.psm1')) -Verbose:$Verbosity -WhatIf:$WhatIf
            #endregion Generate Module loader
        
            #region Generate Module data function  NOTE: this should be moved to a resources folder
            $ModuleDataFunctionLoader = (Get-Content -Path (Join-Path -Path $ModuleRoot -ChildPath "\ModuleResources\ModuleDataFunctionLoader.txt") -Raw -Verbose:$Verbosity) -replace '<<<<NEWMODULENAME>>>>',$NewModuleName
            Set-Content -Value $ModuleDataFunctionLoader -Path (Join-Path -Path $NewModuleFunctionsDirectory.FullName -ChildPath ('\Get-' + $NewModuleName + 'ModuleInformation.ps1')) -Verbose:$Verbosity -WhatIf:$WhatIf
            #endregion

            return $NewModuleDirectory
        }

    }

    End
    {
        Pop-Location -StackName ModuleBuilderLocationStack -Verbose:$Verbosity
    }
}