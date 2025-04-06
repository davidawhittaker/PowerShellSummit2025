Function Initialize-OutputPath
{
    PARAM($OutputPath)

    IF (!(Test-Path $OutputPath))
    {
        New-Item -ItemType Directory -Path $OutputPath
    }
}
