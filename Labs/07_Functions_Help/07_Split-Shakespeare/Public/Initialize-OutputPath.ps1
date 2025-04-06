Function Initialize-OutputPath
{
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High", DefaultParameterSetName = "Folder")]
    PARAM
    (
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "Folder")]
        [ValidateNotNullOrEmpty()]
        [Alias("OutputPath")]
        $FolderPath,

        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "File")]
        [ValidateNotNullOrEmpty()]
        $FilePath
    )

    $NewPath = SWITCH ($PSCmdlet.ParameterSetName)
    {
        "Folder" {$FolderPath}
        "File"   {$FilePath}
    }
    $ItemType = SWITCH ($PSCmdlet.ParameterSetName)
    {
        "Folder" {"Directory"}
        "File"   {"File"}
    }
    IF ($PSCmdlet.ShouldProcess($NewPath, "Create $($PSCmdlet.ParameterSetName)"))
    {
        Write-Verbose "Testing $NewPath..."
        SWITCH (Test-Path $NewPath)
        {
            $false
            {
                Write-Verbose "$($PSCmdlet.ParameterSetName) $NewPath does not exist. Creating...."
                New-Item -ItemType $ItemType -Path $NewPath -WhatIf:$WhatIfPreference -Verbose:$Global:VerbosePreference
                Write-Verbose "Success!"
            }
            $true
            {
                Write-Warning "$($PSCmdlet.ParameterSetName) $NewPath already exists."
                Get-Item -Path $NewPath -Verbose:$Global:VerbosePreference
            }
        }
    }
}