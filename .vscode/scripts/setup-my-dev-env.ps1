# Very basic pyenv setup
# I chose to install it in C drive as spaces in user names caused issues when using poetry.
# More info: https://community.ynput.io/t/poetry-installation-failed/1522
# For advanced pyenv setup script: https://github.com/pyenv-win/pyenv-win/blob/master/docs/installation.md#powershell

$installation_path = "C:\.pyenv"
Write-Host "Cloning Pyenv to $installation_path"
git clone https://github.com/pyenv-win/pyenv-win.git $installation_path 

Write-Host "Setting necessary environment variables 'PYENV', 'PYENV_ROOT' and 'PYENV_HOME' to '$installation_path\pyenv-win\'"
[System.Environment]::SetEnvironmentVariable('PYENV',"$installation_path\pyenv-win\","User")
[System.Environment]::SetEnvironmentVariable('PYENV_ROOT',"$installation_path\pyenv-win\","User")
[System.Environment]::SetEnvironmentVariable('PYENV_HOME',"$installation_path\pyenv-win\","User")

Write-Host "Appending '$installation_path\pyenv-win\bin' and '$installation_path\pyenv-win\shims' to 'PATH'"
[System.Environment]::SetEnvironmentVariable('path', "$installation_path\pyenv-win\bin;" + "$installation_path\pyenv-win\shims;" + [System.Environment]::GetEnvironmentVariable('path', "User"),"User")


# [!NOTE]
# It's recommended to remove any python installations on the machine.
#
# [!TIP]
# VSCode Terminal
# VSCode overrides pyenv execuatbles making pyenv global or local (.python-version file) useless when using VScode terminal.
# More info, https://github.com/microsoft/vscode-python/issues/20881
# VSCode Tasks
# It works as expected. VsCode doesn't inject any environments there.
# So, using .python-version works and you only need to cd the directoty containing it.

# Retrieve PATH
[System.Environment]::GetEnvironmentVariable('Path',[System.EnvironmentVariableTarget]::User);

# Install Python Version
pyenv install 3.9.13
pyenv install 3.11.5

pyenv global 3.9.13

# Install poetry
pip install poetry

# Set poetry config
poetry config virtualenvs.in-project true
poetry config virtualenvs.create true
poetry config virtualenvs.path "{project-dir}\\.venv"

# Install dependencies of upload-addon
Set-Location $PSScriptRoot
poetry install --no-root 