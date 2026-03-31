$cwd=$ARGS[0]
$bundle=$ARGS[1]

Set-Location $cwd/ayon-shotgrid/service_tools/

# I have to set the cacerts manually on my side when running the service live from code
# cert file is brought from https://github.com/certifi/python-certifi/blob/master/certifi/cacert.pem
$env:SHOTGUN_API_CACERTS="E:/Ynput/extras/cacert.pem"
invoke-expression -Command "./manage.ps1 services"
