@echo off

REM remote script URL – default to the latest version on the repo's main branch.
REM Change owner/repo/path if you host elsewhere. Using the raw.githubusercontent link
REM ensures this batch always pulls the current file without manual edits.
set REMOTE_URL=https://raw.githubusercontent.com/mespp/kfcverse-server/main/setup.ps1

REM temporary location for downloaded script
set TEMP_SCRIPT=%TEMP%\setup.ps1

REM download the script using PowerShell
powershell -NoProfile -Command "Invoke-WebRequest -Uri '%REMOTE_URL%' -OutFile '%TEMP_SCRIPT%'"
if not exist "%TEMP_SCRIPT%" (
    echo Failed to download remote script from %REMOTE_URL%.
    pause
    exit /b 1
)

REM ensure execution policy is configured for future runs too
powershell -NoProfile -Command "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force"

REM execute the downloaded script with policy override
powershell -NoProfile -ExecutionPolicy RemoteSigned -File "%TEMP_SCRIPT%" %*

REM remove the temporary script file after execution
del /f /q "%TEMP_SCRIPT%"
