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
    echo MsgBox "Line 1" ^& vbCrLf ^& "Line 2",262192, "Title"
)> popup.vbs

start popup.vbs

@REM cd back to original directory
cd "%VAR%"
del initial.cmd