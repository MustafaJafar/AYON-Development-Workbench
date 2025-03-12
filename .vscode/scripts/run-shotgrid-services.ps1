$cwd=$ARGS[0]
$bundle=$ARGS[1]

Set-Location $cwd/ayon-shotgrid/service_tools/

# I have to set the cacerts manually on my side when running the service live from code
$env:SHOTGUN_API_CACERTS="$cwd/ayon-shotgrid/service_tools/.venv/Lib/site-packages/shotgun_api3/lib/httplib2/cacerts.txt"
invoke-expression -Command "./manage.ps1 services --variant $bundle"
