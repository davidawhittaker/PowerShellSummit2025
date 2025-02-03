# In order to bypass this limitation, we can create an advanced function, which contains Begin, Process, and End blocks. If a collection of items is passed from the pipeline, the function will invoke any code inside the process block on a per-item basis. Code inside the Begin and End blocks will only be invoked once. It's a good practice to declare empty variables that will be used inside the function, since this will provide a clean workspace inside the function's scope, and prevent overlap with any variables of the same name that might exist elsewhere in your PowerShell environment.
Function Find-BookTitle
{
    PARAM
    (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Book
    )

    BEGIN
    {
        # Declare an empty output object
        $Results = @()
    }
    PROCESS
    {
        # Declare variables
        $Title = @()

        # Find first line in the string
        $Book.TrimStart("`n").Split("`n")[0]

        # Add to results
        $Results += $Title
    }
    END
    {
        Return $Results
    }
}

# Find book titles
$Books | Find-BookTitle