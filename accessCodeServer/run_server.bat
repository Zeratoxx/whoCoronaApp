@echo off
if exist conf.ini (
    set /P ipv4_address=<conf.ini
) else (
    set ipv4_address=NONE
)
echo Current saved IP-Address %ipv4_address%.
echo Is that correct?
setlocal
choice /n /C "YN" /m "(Y / N)"
if errorlevel 2 goto enterIp
if errorlevel 1 goto start

:enterIp
set /P ipv4_address=Enter your IP-Address:
if exist conf.ini del /S/Q conf.ini
echo %ipv4_address%>conf.ini

:start
echo Starting server...
set /P ipv4_address=<conf.ini
@start /b cmd /c @python "accessCodeServer.py" %ipv4_address%
@start /b cmd /c start "" http://%ipv4_address%:8080
@pause > nul

:eof