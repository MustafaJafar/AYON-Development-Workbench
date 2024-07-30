$cwd=$ARGS[0]

# # Not mandatory. But, I like to enable them globally anyway.
# poetry config virtualenvs.in-project true
# poetry config virtualenvs.create true
# poetry config virtualenvs.path "{project-dir}\\.venv"

Copy-Item "$cwd/.vscode/scripts/.env" -Destination "$cwd/ayon-kitsu/services/processor"

Set-Location $cwd/ayon-kitsu/services/processor
poetry install --no-root 