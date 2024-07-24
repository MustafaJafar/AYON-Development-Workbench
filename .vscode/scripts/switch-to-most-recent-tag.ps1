
Set-Location $ARGS[0]
$tag= Invoke-Expression -Command "git describe --tags --abbrev=0"
Write-Host "Most recent tag is: $tag"
git fetch origin $tag
git checkout tags/$tag
