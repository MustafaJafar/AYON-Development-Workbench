@echo off
@REM %1 -> Current Directory

@REM This is hardcoded.
cd /d %1
for %%i in (
    ayon-applications,
    ayon-blender,
    ayon-core,
    ayon-deadline,
    ayon-dependencies-tool,
    ayon-documentation,
    ayon-houdini,
    ayon-launcher,
    ayon-maya,
    ayon-nuke,
    ayon-ocio,
    ayon-python-api,
    ayon-third-party,
    ayon-traypublisher,
    example-studio-addon,
    ayon-backend
) do (
    if exist %1/%%i (echo %1/%%i exists) else (git clone https://github.com/ynput/%%i.git)
)