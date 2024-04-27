@echo off
@REM initial stager
@REM author vadill0

@REM variables
set "var=%cd%"

@REM cd into directory
cd C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup

@REM write payloads
(echo MsgBox "Line 1" ^& vbCrLf ^& "Line 2",262192, "Title")> popup.vbs

@REM cd back to original directory
cd "%var%"
(echo MsgBox "Line 1" ^& vbCrLf ^& "Line 2",262192, "Title")> popup.vbs
