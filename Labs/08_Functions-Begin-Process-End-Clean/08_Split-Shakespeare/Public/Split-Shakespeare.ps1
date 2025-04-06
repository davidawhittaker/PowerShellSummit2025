Function Split-Shakespeare
{
    # This script will split the complete works of Shakespeare from a single text file into individual text files for each scene of each book.

    PARAM
    (
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({Test-Path $PSItem})]
        $FilePath = "$PSScriptRoot\..\..\Source\Shakespeare.txt",

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        $OutputPath = "$PSScriptRoot\Books"
    )
    $Books = @()
    Initialize-OutputPath $OutputPath
    $Books = Split-Books $FilePath
    FOREACH ($Book in $Books)
    {
        $BookTitle   = @()
        $BookType    = @()
        $Scenes      = @()
        $SceneTitles = @()
        $BookTitle = Find-BookTitle $Book
        Initialize-OutputPath $OutputPath\$BookTitle
        $BookType = Find-BookType $Book
        Out-Book $BookType
    }
}
