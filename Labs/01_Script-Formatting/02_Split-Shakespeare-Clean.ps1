# This script will split the complete works of Shakespeare from a single text file into individual text files for each scene of each book.

# Declare variables
$FilePath   = 'C:\Users\David\Downloads\Shakespeare.txt'
$OutputPath = "$PSScriptRoot\Books"
$Books      = @()

# Create base output directory if it doesn't exist
IF (!(Test-Path $OutputPath))
{
    New-Item -ItemType Directory -Path $OutputPath
}

# Read contents of complete file
$Books = Get-Content -Raw $FilePath

# Split into individual books in memory
$Books = $Books -Split "\n\d{4}\n"

# Discard copyright page
$Books = $Books | Select-Object -Skip 1

FOREACH ($Book in $Books)
{
    # Declare variables
    $BookTitle   = @()
    $Scenes      = @()
    $SceneTitles = @()

    # Find book title
    $BookTitle = $Book.TrimStart("`n").Split("`n")[0]

    # Create output directory if it doesn't exist
    IF (!(Test-Path $OutputPath\$BookTitle))
    {
        New-Item -ItemType Directory -Path $OutputPath\$BookTitle
    }

    # Play
    IF ($Book -match "ACT \w+[.]? SCENE \w+[.]?\n")
    {
        Write-Output "$BookTitle - Play"

        # Find scene titles
        $SceneTitles = $Book.Split("`n") | Where-Object {$_ -match "ACT \w+[.]? SCENE \w+[.]?"}
        $SceneTitles = $SceneTitles.TrimStart("")
        $SceneTitles = $SceneTitles.TrimEnd("")
        $Scenes      = $Book -Split "ACT \w+[.]? SCENE \w+[.]?"

        # Create counter
        $i = 0

        FOREACH ($Scene in $Scenes)
        {
            # Declare variables
            $SceneTitle = @()

            # Format scene titles
            IF ($i -eq 0)
            {
                $SceneTitle = "Dramatis Personae"
            }
            ELSE
            {
                $SceneTitle = $SceneTitles[($i - 1)].Replace(".", "")
            }

            # Remove copyright disclaimer
            $Scene = ($Scene -Split "<<")[0]

            # Output scenes to file
            $Scene | Out-File "$OutputPath\$BookTitle\$i - $SceneTitle.txt"

            # Increment counter
            $i++
        }
    }
    # Sonnets
    ELSEIF ($Book -match "\n\s+\d+[\s]*?\n")
    {
        Write-Output "$BookTitle - Sonnet"

        # Find scene titles
        $SceneTitles = $Book.Split("`n") | Where-Object {$_ -match "^\W+\d+\W*$"}
        $SceneTitles = $SceneTitles.TrimStart("")
        $SceneTitles = $SceneTitles.TrimEnd("")
        $Scenes      = $Book -Split "\n\s+\d+[\s]*?\n"

        # Create counter
        $i = 0

        FOREACH ($Scene in $Scenes)
        {
            # Declare variables
            $SceneTitle = @()

            # Format scene titles
            IF ($i -eq 0)
            {
                $SceneTitle = "Dramatis Personae"
            }
            ELSE
            {
                $SceneTitle = $SceneTitles[($i - 1)].Replace(".", "")
            }

            # Remove copyright disclaimer
            $Scene = ($Scene -Split "<<")[0]

            # Output scenes to file, excluding title file
            IF ($i -gt 0)
            {
                $Scene | Out-File "$OutputPath\$BookTitle\$i - Sonnet $SceneTitle.txt"
            }

            $i++
        }
    }
    # Output to a single file
    ELSE
    {
        Write-Output "$BookTitle - Other"

        # Find scene titles
        $SceneTitles = $Book.Split("`n") | Where-Object {$_ -match $BookTitle}
        $SceneTitles = $SceneTitles.TrimStart("")
        $SceneTitles = $SceneTitles.TrimEnd("")
        $Scenes = $Book

        # Create counter
        $i = 0

        FOREACH ($Scene in $Scenes)
        {
            # Declare variables
            $SceneTitle = @()

            # Format scene titles
            IF ($i -eq 0)
            {
                $SceneTitle = $BookTitle
            }
            ELSE
            {
                $SceneTitle = $SceneTitles[($i - 1)].Replace(".", "")
            }

            # Remove copyright disclaimer
            $Scene = ($Scene -Split "<<")[0]

            # Output scenes to file
            $Scene | Out-File "$OutputPath\$BookTitle\$i - $SceneTitle.txt"

            $i++
        }
    }
}