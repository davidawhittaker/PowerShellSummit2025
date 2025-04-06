Function Find-BookType
{
param($Book)

    SWITCH -Regex ($Book)
    {
        "ACT \w+[.]? SCENE \w+[.]?\n" {"Play"  }
        "\n\s+\d+[\s]*?\n"            {"Sonnet"}
        Default                       {"Unknown"}
    }
}
