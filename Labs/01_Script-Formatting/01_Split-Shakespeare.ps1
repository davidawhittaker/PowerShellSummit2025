$mybookobj=@()
IF(!(Test-Path $PSScriptRoot\Books)){ni -ItemType Directory -Path $PSScriptRoot\Books}
$mybookobj=gc -Raw "$PSScriptRoot\..\..\Source\Shakespeare.txt"
$mybookobj=$mybookobj -Split "\n\d{4}\n"|select -Skip 1
FOREACH($bookobj in $mybookobj){
$mytitleobj=@()
$myscenesobj=@()
$myheaderobj=@()
$mytitleobj=$bookobj.TrimStart("`n").Split("`n")[0]
IF(!(Test-Path $PSScriptRoot\Books\$mytitleobj)){ni -ItemType Directory -Path $PSScriptRoot\Books\$mytitleobj}
IF($bookobj -match "ACT \w+[.]? SCENE \w+[.]?\n"){
echo "$mytitleobj - Play"
$myheaderobj=($bookobj.Split("`n")|?{$_ -match "ACT \w+[.]? SCENE \w+[.]?"}).TrimStart("").TrimEnd("")
$myscenesobj=$bookobj -Split "ACT \w+[.]? SCENE \w+[.]?"
$i=0
FOREACH($sceneobj in $myscenesobj){
$myscenestitleobj = @()
IF($i -eq 0){$myscenestitleobj="Dramatis Personae"}
ELSE{$myscenestitleobj = $myheaderobj[($i-1)].Replace(".","")}
$sceneobj=($sceneobj -Split "<<")[0]
$sceneobj|Out-File "$PSScriptRoot\Books\$mytitleobj\$i - $myscenestitleobj.txt"
$i++}}
ELSEIF($bookobj -match "\n\s+\d+[\s]*?\n"){
echo "$mytitleobj - Sonnet"
$myheaderobj=($bookobj.Split("`n")|?{$_ -match "^\W+\d+\W*$"}).TrimStart("").TrimEnd("")
$myscenesobj=$bookobj -Split "\n\s+\d+[\s]*?\n"
$i=0
FOREACH($sceneobj in $myscenesobj){
$myscenestitleobj=@()
IF($i -eq 0){$myscenestitleobj="Dramatis Personae"}
ELSE{$myscenestitleobj=$myheaderobj[($i-1)].Replace(".","")}
$sceneobj = ($sceneobj -Split "<<")[0]
IF ($i -gt 0){$sceneobj | Out-File "$PSScriptRoot\Books\$mytitleobj\$i - Sonnet $myscenestitleobj.txt"}
$i++}}
ELSE{
echo "$mytitleobj - Other"
$myheaderobj=($bookobj.Split("`n")|?{$_ -match $mytitleobj}).TrimStart("").TrimEnd("")
$myscenesobj=$bookobj
$i=0
FOREACH($sceneobj in $myscenesobj){
$myscenestitleobj = @()
IF ($i -eq 0){$myscenestitleobj=$mytitleobj}
ELSE{$myscenestitleobj=$myheaderobj[($i-1)].Replace(".","")}
$sceneobj = ($sceneobj -Split "<<")[0]
$sceneobj|Out-File "$PSScriptRoot\Books\$mytitleobj\$i - $myscenestitleobj.txt"
$i++}}}