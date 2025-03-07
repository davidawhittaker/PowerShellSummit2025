Function Find-BookTitle($Book)
{
    Return $Book.TrimStart("`n").Split("`n")[0]
}
Function Split-Books($FilePath)
{
    # Read contents of complete file
    $Books = Get-Content -Raw $FilePath

    # Split into individual books in memory
    $Books = $Books -Split "\n\d{4}\n"

    # Discard copyright page
    $Books = $Books | Select-Object -Skip 1

    Return $Books
}
Function Initialize-OutputPath($OutputPath)
{
    IF (!(Test-Path $OutputPath))
    {
        New-Item -ItemType Directory -Path $OutputPath
    }
}
Function Find-BookType($Book)
{
    SWITCH -Regex ($Book)
    {
        "ACT \w+[.]? SCENE \w+[.]?\n" {"Play"  }
        "\n\s+\d+[\s]*?\n"            {"Sonnet"}
        Default                       {"Unknown"}
    }
}
Function Out-Book ($BookType)
{
    # Find scene titles
    $SceneTitles = SWITCH ($BookType)
    {
        "Play"   {$Book.Split("`n") | Where-Object {$_ -match "ACT \w+[.]? SCENE \w+[.]?"}}
        "Sonnet" {$Book.Split("`n") | Where-Object {$_ -match "^\W+\d+\W*$"}}
        Default  {$Book.Split("`n") | Where-Object {$_ -match $BookTitle}}
    }
    $SceneTitles = $SceneTitles.TrimStart("")
    $SceneTitles = $SceneTitles.TrimEnd("")
    $Scenes = SWITCH ($BookType)
    {
        "Play"   {$Book -Split "ACT \w+[.]? SCENE \w+[.]?"}
        "Sonnet" {$Book -Split "\n\s+\d+[\s]*?\n"}
        Default  {$Book}
    }

    # Create counter
    $i = 0

    FOREACH ($Scene in $Scenes)
    {
        # Declare variables
        $SceneTitle = @()

        # Format scene titles
        IF ($i -eq 0)
        {
            $SceneTitle = SWITCH -Regex ($BookType)
            {
                "Play|Sonnet" {"Dramatis Personae"}
                "Unknown"     {"$BookTitle"}
            }
        }
        ELSE
        {
            $SceneTitle = $SceneTitles[($i - 1)].Replace(".", "")
        }

        # Remove copyright disclaimer
        $Scene = ($Scene -Split "<<")[0]

        # Output scenes to file
        SWITCH -Regex ($BookType)
        {
            "Play|Unknown"
            {
                $Scene | Out-File "$OutputPath\$BookTitle\$i - $SceneTitle.txt"
            }
            "Sonnet"
            {
                IF ($i -gt 0)
                {
                    $Scene | Out-File "$OutputPath\$BookTitle\$i - Sonnet $SceneTitle.txt"
                }
            }
        }
        # Increment counter
        $i++
    }
}
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