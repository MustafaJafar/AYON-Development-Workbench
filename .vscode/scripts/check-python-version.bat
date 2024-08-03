@echo off
@REM %1 -> Directory

cd /d %1
call pyenv version
call python --version