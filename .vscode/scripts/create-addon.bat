@echo off
@REM %1 -> Current Directory
@REM %2 -> addon repo name


@REM Create Addon.
call python %1/%2/create_package.py

@REM Upload addons
call python %1/.vscode/scripts/upload-addon.py --addon %1/%2
