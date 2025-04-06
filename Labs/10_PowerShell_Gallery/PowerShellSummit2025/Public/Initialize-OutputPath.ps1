Function Initialize-OutputPath
{
    # .EXTERNALHELP
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High", DefaultParameterSetName = "Folder")]
    PARAM
    (
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "Folder", ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("OutputPath")]
        [String[]]$FolderPath,

        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "File")]
        [ValidateNotNullOrEmpty()]
        [String[]]$FilePath
    )

    BEGIN
    {
        $ItemType = SWITCH ($PSCmdlet.ParameterSetName)
        {
            "Folder" {"Directory"}
            "File"   {"File"}
        }
        Write-Verbose "ParameterSetName is $Itemtype."
    }
    PROCESS
    {
        $NewPaths = SWITCH ($PSCmdlet.ParameterSetName)
        {
            "Folder" {$FolderPath}
            "File"   {$FilePath}
        }
        FOREACH ($NewPath in $NewPaths)
        {
            IF ($PSCmdlet.ShouldProcess($NewPath, "Create $($PSCmdlet.ParameterSetName)"))
            {
                Write-Verbose "Testing $NewPath..."
                SWITCH (Test-Path $NewPath)
                {
                    $false
                    {
                        TRY
                        {
                            Write-Verbose "$($PSCmdlet.ParameterSetName) $NewPath does not exist. Creating...."
                            New-Item -ItemType $ItemType -Path $NewPath -WhatIf:$WhatIfPreference -Verbose:$Global:VerbosePreference
                            Write-Verbose "Success!"
                        }
                        CATCH
                        {
                            Throw
                        }
                    }
                    $true
                    {
                        Write-Warning "$($PSCmdlet.ParameterSetName) $NewPath already exists."
                        Get-Item -Path $NewPath -Verbose:$Global:VerbosePreference
                    }
                }
            }
        }
    }
}