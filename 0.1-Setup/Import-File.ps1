# Declare variables
$FilePath = 'C:\Users\David\Downloads\Shakespeare.txt'
$Books = @()

# Read contents of complete file
$Books = Get-Content -Raw $FilePath

# Split into individual books in memory
$Books = $Books -Split "\n\d{4}\n"

# Discard copyright page
$Books = $Books | Select-Object -Skip 1

# \n\s+\d+[\s]*?\n