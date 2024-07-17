@echo off
@REM %1 -> Current Directory
@REM %2 -> output directory


@REM  Clear packages dir
if exist %2 (
    RMDIR %2 /S /Q  && echo Dir '%2' has been cleared. && MKDIR %2
) else (
    MKDIR %2
)

@REM Create Addons - This is hardcoded.
call python %1/ayon-applications/create_package.py -o %2
call python %1/ayon-blender/create_package.py -o %2
call python %1/ayon-core/create_package.py -o %2
call python %1/ayon-deadline/create_package.py -o %2
call python %1/ayon-houdini/create_package.py -o %2
call python %1/ayon-maya/create_package.py -o %2
call python %1/ayon-nuke/create_package.py -o %2
call python %1/ayon-ocio/create_package.py -o %2
call python %1/ayon-third-party/create_package.py -o %2
call python %1/ayon-traypublisher/create_package.py -o %2
call python %1/example-studio-addon/create_package.py -o %2

@REM Upload addons
call python %1/.vscode/scripts/upload-addon.py --package-dir %2
