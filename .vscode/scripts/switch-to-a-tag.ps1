
$cwd=$ARGS[0]
$tag=$ARGS[1]

Set-Location $cwd

Write-Host "Switch to tag: $tag"
git fetch origin $tag
git checkout FETCH_HEAD #tags/$tag
