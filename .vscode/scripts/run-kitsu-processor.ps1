$cwd=$ARGS[0]

# `ayon_api.init_service()` expects these two environment variable
#   in order to get the service context properly.
$env:AYON_ADDON_NAME= "kitsu"
$env:AYON_ADDON_VERSION= Invoke-Expression -Command "python -c ""content={};f=open('$cwd/ayon-kitsu/package.py');exec(f.read(),content);f.close();print(content['version'])"""

Set-Location $cwd/ayon-kitsu/services/processor
invoke-expression -Command "./manage.ps1 run"