@echo off
@REM %1 -> Current Directory

@REM This is hardcoded.
cd /d %1
for %%i in (
    ayon-documentation,
    ayon-backend,
    ayon-python-api,
    ayon-dependencies-tool,
    ayon-launcher,
    ayon-third-party,
    ayon-ocio,
    ayon-applications,
    ayon-core,
    ayon-traypublisher,
    ayon-blender,
    ayon-deadline,
    ayon-houdini,
    ayon-maya,
    ayon-nuke,
    ayon-usd,
) do (
    if exist %1/%%i (echo %1/%%i exists) else (git clone https://github.com/ynput/%%i.git)
)