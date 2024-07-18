@echo off
@REM %1 -> Current Directory
@REM %2 -> output directory


@REM  Clear packages dir
if exist %2 (
    RMDIR %2 /S /Q  && echo Dir '%2' has been cleared. && MKDIR %2
)

@REM Create Addons - This is hardcoded.
for %%i in (
    ayon-applications,
    ayon-blender,
    ayon-core,
    ayon-deadline,
    ayon-houdini,
    ayon-maya,
    ayon-nuke,
    ayon-ocio,
    ayon-third-party,
    ayon-traypublisher,
    example-studio-addon
) do (
    call python %1/%%i/create_package.py -o %2
)

@REM Upload addons
call python %1/.vscode/scripts/upload-addon.py --package-dir %2
