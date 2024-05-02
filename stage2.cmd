@echo off
@REM powershell Start-Process powershell.exe -windowstyle
@REM "$env:temp/p.ps1"
@REM powershell Start-Process powershell.exe -windowstyle
@REM "$env:temp/l.ps1"

powershell -c "Invoke-WebRequest -Uri 'http://ipv4.download.thinkbroadband.com/10MB.zip' -OutFile 'test.zip'"