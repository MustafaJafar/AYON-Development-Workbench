@echo off
@REM %1 -> Repo Directory
@REM %2 -> Branch name


cd /d %1
git checkout %2
git pull origin %2