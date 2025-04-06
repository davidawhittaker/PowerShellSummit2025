Function Split-Module
{
    PARAM
    (
        [Parameter(Mandatory = $true)]
        [String]$Name
    )

    # Declare Variables
    $Commands = @()
    $Module   = @()

    $Module = Import-Module $Name -PassThru
    $Module = Import-Module $Module.Path -Force -PassThru

    $Commands = Get-Command -Module $Module.Name

    FOREACH ($Command in $Commands)
    {
        Write-Output "Function $($Command.Name) `n{`n$($Command.Definition)`n}" | Out-File -FilePath "$($Module.ModuleBase)/$($Command.Name).ps1" -Force
    }
}