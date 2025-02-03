# Declare variables
$FilePath = 'C:\Users\David\Downloads\Shakespeare.txt'
$OutputPath = "$PSScriptRoot\Books"
$Books = @()

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

    #Create output directory if it doesn't exist
    IF (!(Test-Path $OutputPath\$BookTitle))
    {
        New-Item -ItemType Directory -Path $OutputPath\$BookTitle
    }

    # Play
    IF ($Book -match "ACT \w+[.]? SCENE \w+[.]?\n")
    {
        echo "$BookTitle - Play" #<----------------------------------------------------------------------------------------------------------------------------------------

        $SceneTitles = $Book.Split("`n") | Where-Object {$_ -match "ACT \w+[.]? SCENE \w+[.]?"}
        $SceneTitles = $SceneTitles.TrimStart("")
        $SceneTitles = $SceneTitles.TrimEnd("")
        $Scenes      = $Book -Split "ACT \w+[.]? SCENE \w+[.]?"
        $i           = 0

        FOREACH ($Scene in $Scenes)
        {
            # Declare variables
            $SceneTitle = @()

            IF ($i -eq 0)
            {
                $SceneTitle = "Dramatis Personae"
            }
            ELSE
            {
                $SceneTitle = $SceneTitles[($i-1)].Replace(".","")
            }

            $Scene | Out-File "$OutputPath\$BookTitle\$i - $SceneTitle.txt"

            $i++
        }
    }
    # Sonnets
    ELSEIF ($Book -match "\n\s+\d+[\s]*?\n")
    {
        echo "$BookTitle - Sonnet" #<----------------------------------------------------------------------------------------------------------------------------------------
    }
    # Output to a single file
    ELSE
    {
        echo "$BookTitle - Other" #<----------------------------------------------------------------------------------------------------------------------------------------
    }
}