@echo off
setlocal
:: Check if the user passed at least 1 argument
if “%1%” == “” (
echo Remoted Desktop connection with user and password
echo.
echo Missing arguments. Syntax:
echo %~nx0% “servername” “username” “password”
pause
goto :eof
)
:: Next line removes surrounding quotes from server name
set sServer=%~1%
:: Keep the quotes for the username and password (in case spaces exists)
set sUser=%2%
set sPass=%3%
:: Seconds to wait before clearing the newly added password from the vault (see control panel, manage your credentials)
:: You may want to modify this if the server takes longer to connect (WAN). You could add this as a fourth argument.
set sSeconds=120
:: Add a new connection definition method to the vault
cmdkey /generic:TERMSRV/%sServer% /user:%sUser% /pass:%sPass%
:: Connect to the server as a new task
start mstsc /v:%sServer%
EXIT /B %ERRORLEVEL%
:: ping ourselves for x seconds (acts like a pause) then removes the newly added password from the vault
::ping -n %sSeconds% 127.0.0.1 >nul:
::cmdkey /delete:TERMSRV/%sServer%