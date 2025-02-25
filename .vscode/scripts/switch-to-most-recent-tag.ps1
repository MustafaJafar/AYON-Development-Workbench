
Set-Location $ARGS[0]

git fetch origin --tags

$tag= Invoke-Expression -Command "git describe --tags --abbrev=0"
Write-Host "Most recent tag is: $tag"
git checkout tags/$tag
