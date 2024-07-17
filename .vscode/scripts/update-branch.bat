@echo off
@REM %1 -> Current Directory
@REM %2 -> Repo name


cd /d %1
git checkout %2
git pull origin %2