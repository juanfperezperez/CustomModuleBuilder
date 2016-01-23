#CustomModuleBuilder

This is a powershell module used to create a basic structure for powershell modules.The product
you see here is based on the work of Kevin Marquette (https://www.youtube.com/user/ithinkincode)
on his "Pester in action" series and his "Quick and Dirty Powershell modules" video.

Resulting file structure of the New-CustomModule cmdlet for a new module named MyNewCustomModule

* xModules
    * MyNewCustomModule
        * Functions
            * Get-MyNewCustomModuleModuleInformation.ps1
            * Other cmdlets and pester tests
        * ModuleResources
            * resorces used by the module (templates, images, etc.)
        * RequiredModules
            * Required modules shipped with the module
        * RequiredModulesLoader.ps1
        * MyNewCustomModule.psd1
        * MyNewCustomModule.psm1

##NOTES:
###Functions
This folder is intended to contain all the functions to be exported by the module. The assumption here is that every cmdlet will have its own separate ps1 file. Every file that	does not match the pattern "*.Tests.*" will be imported into the module.

###ModuleResources
This folder is intended for any additional files needed by the functions or other scripts in the module. Some examples are: Templates, images, DLLs.

###RequiredModules
This folder is intended for storing other modules that need to be loaded into the caller's session before loading this module. In the case of this module, I ship Pester and PSScriptAnalyzer. The modules will only be loaded if they are not found on the system running this module.

###RequiredModulesLoader.ps1
This script checks if the modules in the RequiredModules folder are already present on the system. If they are, it will load them. If they are not, it will attempt to load them from the RequiredModules folder.

###MyNewCustomModule.psm1
This is the root script module. This is the file that loads the functions from the Functions folder.

###MyNewCustomModule.psd1
This is the module manifest.

###Get-MyNewCustomModuleModuleInformation.ps1
This is the first function created in the new module. It is a wrapper for the Get-Module cmdlet.