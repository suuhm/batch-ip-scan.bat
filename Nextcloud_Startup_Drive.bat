@echo off
SETLOCAL EnableDelayedExpansion
::
:: (c) Suuhmer - 2021
:: All rights reserved
::
:: ########################################################################################
:: ###################################### :: INIT:: #######################################
:: ########################################################################################
::
:: set up on logon or webclient at services.msc ?

:: #####################################
:: #### SETUP ##########################
:: #####################################

set "_HOST=host.domain.com"
set "_USER=username"
REM set "_PASS=pa$$word"
REM set "_PASS=pa$$word"
set "_DBG=FALSE"

REM ----------------------------------------------
REM !!! USE SIMPLE B64 ECODING IN SEPARATE DIR !!!
REM ----------------------------------------------

REM File path for the encrypted password file
set PASSFILE=%APPDATA%\ncpw.key

REM Check if the encrypted password file exists
if not exist "!PASSFILE!" (
    echo The encrypted password file does not exist.
    pause
    exit /b 1
)

REM Decrypt the password
REM for /f %%A in ('certutil -decode "!PASSFILE!" -') do set "PASSWORD=%%A"

REM Decrypt the password using certutil and store it in a temporary file
certutil -decode "!PASSFILE!" "%TEMP%\decrypted_password.tmp" > nul
set /p _PASS=<"%TEMP%\decrypted_password.tmp"
del "%TEMP%\decrypted_password.tmp" > nul

REM echo DEBUG: password is: !PASSWORD!

:: #####################################
:: #####################################


set LOGVAR= & set _N_M=0 & set _COUNT=0 & set SLEEP=3000 &REM 3*1000 Millisecs
set N_L=^& echo\

:: wait 10 secs
:: ping -w %SLEEP% -n 1 2.0.0.0 >nul

:: net use P: /delete
:: net stop webclient
:: net start webclient

:Check_If_Host_Alive
Color 0E
ping -w %SLEEP% -n 1 2.0.0.0 >nul
echo\
echo [*] Check_If_Host_Alive...
echo\
ping -w 1000 -n 1 2.0.0.0 >nul	
call :getCLStatus %_HOST% "2"

if /I "%_DBG%"=="FALSE" (
	set "_PASSOUT=******"
) else (
	set "_PASSOUT=!_PASS!"
)
echo [*] Setup NetDrive %_HOST% USER: %_USER% - PASS: %_PASSOUT% ...

net use P: \\%_HOST%@SSL\remote.php\dav\files\%_USER% /persistent:yes !_PASS! /user:%_USER%

echo Done. bye.
pause


:: ########################################################################################
:: ################################### :: GET STATUS:: ####################################
:: ########################################################################################
:getCLStatus

    setlocal enableextensions disabledelayedexpansion

    if "%~1"=="" goto :eof

    call :isOnline "%~1"
    if not errorlevel 1 ( 
    	Color 0A
    	echo\
    	echo [+] SUCCESS ONLINE! 
    	echo\
    	ping -w %SLEEP% -n 1 2.0.0.0 >nul
    	Color 0E
    	) else (
    	Color 0C
    	echo;
    	echo [!] SEEMS TO BE OFFLINE!
    	echo Retry...
    	echo\
    	ping -w %SLEEP% -n 1 2.0.0.0 >nul
    	Color 0E
    	cls
    	goto :Check_If_Host_Alive
    	)

    endlocal
    exit /b

:isOnline address pingCount
    setlocal enableextensions disabledelayedexpansion

    :: send only one ping packed unless it is indicated to send more than one
    set /a "pingCount=0", "pingCount+=%~2" >nul 2>nul 
    if %pingCount% lss 1 set "pingCount=1"

    :: a temporary file is needed to capture ping output for later processing
    set "tempFile=%temp%\%~nx0.%random%.tmpo"

    :: ping the indicated address getting command output and errorlevel
    ping -w 1000 -n %pingCount% "%~1" > "%tempFile%" && set "pingError=" || set "pingError=1"

	::	
	:: Inspired by: https://stackoverflow.com/a/27532745
    ::
    :: When pinging, the behaviours of ipv4 and ipv6 are different
    ::
    :: we get errorlevel = 1 when
    ::    ipv4 - when at least one packet is lost. When sending more than one packet
    ::           the easiest way to check for reply is search the string "TTL=" in 
    ::           the output of the command.
    ::    ipv6 - when all packet are lost.
    ::
    :: we get errorlevel = 0 when
    ::    ipv4 - all packets are received. BUT pinging a inactive host on the same  
    ::           subnet result in no packet lost. It is necessary to check for "TTL=" 
    ::           string in the output of the ping command
    ::    ipv6 - at least one packet reaches the host
    ::
    :: We can try to determine if the input address (or host name) will result in 
    :: ipv4 or ipv6 pinging, but it is easier to check the result of the command
    ::
    ::                          +--------------+-------------+
    ::                          | TTL= present |    No TTL   | 
    ::  +-----------------------+--------------+-------------+
    ::  | ipv4    errorlevel 0  |      OK      |    ERROR    |
    ::  |         errorlevel 1  |      OK      |    ERROR    | 
    ::  +-----------------------+--------------+-------------+ 
    ::  | ipv6    errorlevel 0  |              |      OK     |
    ::  |         errorlevel 1  |              |    ERROR    |
    ::  +-----------------------+----------------------------+
    ::
    :: So, if TTL= is present in output, host is online. If TTL= is not present,  
    :: errorlevel is 0 and the address is ipv6 then host is online. In the rest 
    :: of the cases host is offline.
    ::
    :: To determine the ip version, a regular expresion to match a ipv6 address is 
    :: used with findstr. As it will be only tested in the case of no errorlevel, 
    :: the ip address will be present in ping command output.

    set "exitCode=1"
    >nul 2>nul (
        find "TTL=" "%tempFile%" && ( set "exitCode=0" ) || (
            if not defined pingError (
            	REM IPV6-CHECHREGEX
                findstr /r /c:" [a-f0-9:][a-f0-9]*:[a-f0-9:%%]*[a-f0-9]: " "%tempFile%" && set "exitCode=0"
            )
        )
        del /q "%tempFile%"
    )

    :: cleanup and return errorlevel: 0=online , 1=offline 
    endlocal & exit /b %exitCode%

    :: cleanup and return errorlevel: 0=online , 1=offline 
    endlocal & exit /b %exitCode%
