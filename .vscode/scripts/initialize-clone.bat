@echo off
@REM %1 -> Current Directory
@REM %2 -> Repo name


cd /d %1
if exist %1/%2 (echo %1/%2 exists) else (git clone https://github.com/ynput/%2.git)