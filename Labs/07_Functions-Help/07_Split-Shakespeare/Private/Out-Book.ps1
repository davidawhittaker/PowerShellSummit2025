Function Out-Book 
{
param($BookType)

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
