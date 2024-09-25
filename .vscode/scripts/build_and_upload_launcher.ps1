$cwd=$ARGS[0]

get-content $cwd\.vscode\scripts\.env | ForEach-Object {
    $name, $value = $_.split('=')
    if ($value)
        {
            Set-Item env:$name -Value $value
        }
}

Set-Location $cwd/ayon-launcher

tools/manage.ps1 --build-make-installer
tools/manage.ps1 upload --server $env:AYON_SERVER_URL --api-key $env:AYON_API_KEY