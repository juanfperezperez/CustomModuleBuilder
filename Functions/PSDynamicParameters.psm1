
<#
.Synopsis
   Creates a RuntimeDefinedParameter with a validate set.
.DESCRIPTION
   Creates a RuntimeDefinedParameter with a validate set.
.EXAMPLE

This will create the Test-Dyn1 function with parameters Param1 and Param2. Validation ist changes will only take effect if the changes are made to the $params variable (outside the function).

$list1 = "Item11","Item12","Item13","Item14"
$list2 = "Item21","Item22","Item23","Item24"

$params = @(
    New-ParameterValidateSet -Name Param1 -Set $list1
    New-ParameterValidateSet -Name Param2 -Set $list2
)


function Test-Dyn1
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    ()
    DynamicParam{
        return New-RuntimeParameterDictionary -RuntimeParameter $params
    }


    Begin
    {
        $params = $PSBoundParameters
    }
    Process
    {
        $params
    }
    End
    {
    }
}

.EXAMPLE

This will create the Test-Dyn2 function with parameters Param1 and Param2. Validation list changes will only take effect if the changes are made to the $list1 and $list2 variables (outside the function).

$list1 = "Item11","Item12","Item13","Item14"
$list2 = "Item21","Item22","Item23","Item24"


function Test-Dyn2
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    ()
    DynamicParam{
        $params = @(
            New-ParameterValidateSet -Name Param1 -Set $list1
            New-ParameterValidateSet -Name Param2 -Set $list2
        )

        return New-RuntimeParameterDictionary -RuntimeParameter $params
    }


    Begin
    {
        $params = $PSBoundParameters
    }
    Process
    {
        $params
    }
    End
    {
    }
}
#>
function New-RuntimeDefinedParameter
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([System.Management.Automation.RuntimeDefinedParameter])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   Position=0)]
        [ValidatePattern("^[A-Za-z][A-Za-z0-9]+$")]
        $Name,

        # Param1 help description
        [Parameter(Mandatory=$false,
                   Position=1)]
        [string[]]
        $ValidateSet,

        # Param1 help description
        [Parameter(Mandatory=$false,
                   Position=2)]
        [int]
        $Position,
        
        # Param2 help description
        [Parameter(Mandatory=$false,
                   Position=3)]
        [switch]
        $Mandatory
    )

    Begin{}
    Process
    {
        $AttributeCollection = New-Object -TypeName 'System.Collections.ObjectModel.Collection[System.Attribute]'
        
        $ParameterAttribute =  New-Object -TypeName 'System.Management.Automation.ParameterAttribute'
        
        $ParameterAttribute.Mandatory = $Mandatory
        
        if($PSBoundParameters.ContainsKey("Position")){$ParameterAttribute.Position = $Position}

        $AttributeCollection.Add($ParameterAttribute)

        if($PSBoundParameters.ContainsKey("ValidateSet")){
            $ValidateSetAttribute = New-Object -TypeName System.Management.Automation.ValidateSetAttribute($ValidateSet)
            $AttributeCollection.Add($ValidateSetAttribute)
        }

        $Output = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter($Name,[string],$AttributeCollection)

        return $Output
    }
    End{}
}

<#
.Synopsis
   Creates a RuntimeDefinedParameterDictionary.
.DESCRIPTION
   Creates a RuntimeDefinedParameterDictionary.
.EXAMPLE

This will create the Test-Dyn1 function with parameters Param1 and Param2.

$list1 = "Item11","Item12","Item13","Item14"
$list2 = "Item21","Item22","Item23","Item24"

$params = @(
    New-ParameterValidateSet -Name Param1 -Set $list1
    New-ParameterValidateSet -Name Param2 -Set $list2
)


function Test-Dyn1
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    ()
    DynamicParam{
        return New-RuntimeParameterDictionary -RuntimeParameter $params
    }


    Begin
    {
        $params = $PSBoundParameters
    }
    Process
    {
        $params
    }
    End
    {
    }
}

.EXAMPLE

This will create the Test-Dyn2 function with parameters Param1 and Param2.

$list1 = "Item11","Item12","Item13","Item14"
$list2 = "Item21","Item22","Item23","Item24"


function Test-Dyn2
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    ()
    DynamicParam{
        $params = @(
            New-ParameterValidateSet -Name Param1 -Set $list1
            New-ParameterValidateSet -Name Param2 -Set $list2
        )

        return New-RuntimeParameterDictionary -RuntimeParameter $params
    }


    Begin
    {
        $params = $PSBoundParameters
    }
    Process
    {
        $params
    }
    End
    {
    }
}
#>
function New-RuntimeParameterDictionary
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([System.Management.Automation.RuntimeDefinedParameterDictionary])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   Position=0)]
        [System.Management.Automation.RuntimeDefinedParameter[]]
        $RuntimeParameter
    )

    Begin{}
    Process
    {
        
        $output = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameterDictionary
        foreach ($param in $RuntimeParameter){
            $output.Add($param.Name,$param)
        }

        return $output
    
    }
    End{}
}

