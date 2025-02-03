# This is a quick and dirty function that finds the first line of text from input and assumes it's a book title
Function Find-BookTitle ($Book)
{
    Return $Book.TrimStart("`n").Split("`n")[0]
}

# Let's try passing the first book (after excluding the copyright page) to our function. This doesn't work because the pipeline passes an array of objects to our function, but the function doesn't have any logic to handle this.
$Books[1..($Books.Count-1)] | Find-BookTitle -Book $PSItem

# As a result, we have to wrap our function inside a foreach loop. This serializes the input and reruns the function repeatedly inside the loop.
$Books[1..($Books.Count-1)] | ForEach-Object {Find-BookTitle -Book $PSItem}

