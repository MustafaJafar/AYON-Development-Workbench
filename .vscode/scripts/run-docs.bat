@echo off
@REM %1 -> ayon-documentation repo path

cd /d %1/website
if exist .docusaurus (
    RMDIR .docusaurus/S /Q  && echo .docusaurus cache has been cleared. && MKDIR %2
)

yarn start
