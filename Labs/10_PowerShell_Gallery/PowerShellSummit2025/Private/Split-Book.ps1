Function Split-Book
{
param($FilePath)

    # Read contents of complete file
    $Books = Get-Content -Raw $FilePath

    # Split into individual books in memory
    $Books = $Books -Split "\n\d{4}\n"

    # Discard copyright page
    $Books = $Books | Select-Object -Skip 1

    Return $Books
}
