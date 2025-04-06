Function Find-BookTitle
{
param($Book)

    Return $Book.TrimStart("`n").Split("`n")[0]
}
