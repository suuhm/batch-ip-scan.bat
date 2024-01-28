@echo off
setlocal enabledelayedexpansion

::
:: (c) Suuhmer - 2021
:: All rights reserved
::
:: ########################################################################################
:: ###################################### :: INIT:: #######################################
:: ########################################################################################
::

echo\
echo   ad8888888888ba
echo  dP'         `"8b,
echo 8  ,aaa,       "Y888a     ,aaaa,     ,aaa,  ,aa,
echo 8  8' `8           "88baadP""""YbaaadP"""YbdP""Yb
echo 8  8   8              """        """      ""    8b
echo 8  8, ,8         ,aaaaaaaaaaaaaaaaaaaaaaaaddddd88P
echo 8  `"""'       ,d8""
echo Yb,         ,ad8"    KEY GENERATOR FOR NEXTCLOUD LOGIN
echo  "Y8888888888P"
echo\

REM File path for the encrypted password file
set PASSFILE=%APPDATA%\ncpw.key
set PASSFILET=%APPDATA%\ncpw.tkey

echo\
echo * Passwordfile saved at: !PASSFILE!
echo\
REM Check if the encrypted password file exists, and create it if not
if not exist "!PASSFILE!" (
    REM echo. > "!PASSFILE!"
    echo Create pw file
)

REM Prompt the user for the password
set /p "PASSWORD=Please enter your password: "

REM cd "!CD!"
echo !PASSWORD! > "!PASSFILET!"

REM Encrypt the password and save it to the file
certutil -encode "!PASSFILET!" "!PASSFILE!"

echo Password successfully encrypted and saved to "!PASSFILE!".
del /F /Q !PASSFILET!
pause
exit /b 0
