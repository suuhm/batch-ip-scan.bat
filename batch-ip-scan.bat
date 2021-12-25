@echo off
SETLOCAL EnableDelayedExpansion
::
:: (c) Suuhmer - 2021
:: All rights reserved
::
:: ########################################################################################
:: ###################################### :: INIT:: ######################################
:: ########################################################################################

set LOGVAR= & set _N_M=0 & set _COUNT=0 & set SLEEP=6000 &REM 6*1000 Millisecs
set strt=1 & set strta=0 & set strtb=0 & set strtd=0
set N_L=^& echo\

:: getIPAdress() - IPv4 only yet.
for /f "tokens=13 delims= " %%z in ('ipconfig ^|findstr "IPv4"') do set _MYIP=%%z
set LOGF=SCAN__%_MYIP%--%date%.txt
echo Start logging %date% - %time%: >%LOGF% & echo --------------------------------------- >>%LOGF%

:_SETTINGS
cls & Color 0E
echo\
echo  ^_           ^_       ^_           ^_                                 
echo ^| ^|^_^_   ^_^_ ^_^| ^|^_ ^_^_^_^| ^|^_^_       ^(^_^)^_ ^_^_        ^_^_^_  ^_^_^_ ^_^_ ^_ ^_ ^_^_  
echo ^| '^_ \ / ^_` ^| ^_^_/ ^_^_^| '^_ \ ^_^_^_^_^_^| ^| '^_ \ ^_^_^_^_^_/ ^_^_^|/ ^_^_/ ^_` ^| '^_ \ 
echo ^| ^|^_^) ^| ^(^_^| ^| ^|^| ^(^_^_^| ^| ^| ^|^_^_^_^_^_^| ^| ^|^_^) ^|^_^_^_^_^_\^_^_ \ ^(^_^| ^(^_^| ^| ^| ^| ^|
echo ^|^_.^_^_/ \^_^_,^_^|\^_^_\^_^_^_^|^_^| ^|^_^|     ^|^_^| .^_^_/      ^|^_^_^_/\^_^_^_\^_^_,^_^|^_^| ^|^_^|
echo  ^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=   ^|^_^|    ^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=                           
echo  ^=^=^=  S U P E R  S I M P L E  S M A L L  S C A N   
echo  ^=^=^=  		^&  S U B N E T - C A L C U L A T O R.
echo  ^=^=^=
echo  ^=^=^=  ^(C^)2021 - By suuhm - See more: https://github.com/suuhm 
echo  ^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^= & echo\ 

set /p _IPNET=Enter Network to scan (!_MYIP!): 
if "%_IPNET%"=="" (set _IPNET=!_MYIP!)

set /p _NETMASK=Netmask CIDR format (0 - 32): 
if "!_NETMASK!"=="" (
	Color 0C
    echo\ & echo Error 7 - You must enter something
    Timeout /T 3 /NoBreak>nul
	goto _SETTINGS
)
if !_NETMASK! GTR 32 (
	Color 0C
    echo Error 7 - Wrong Netmask: Please Enter 0 - 32
    Timeout /T 3 /NoBreak>nul
	goto _SETTINGS
)
:: NetmaskCIDR = 32-(2^24-2)
if !_NETMASK! LEQ 0 (
	set n=4294967294 & :: Interger on 32Bit LIMIT > (2^31)-1
	set _NETMASK=32
)

:: set ip_nm=%_IPNET:~0,-1% /24 NET CUT FROM RIGHT SIDE
for /f "tokens=1 delims=." %%u in ('echo !_IPNET! ^|findstr /r "[1-9]"') do set I=%%u
for /f "tokens=2 delims=." %%v in ('echo !_IPNET! ^|findstr /r "[1-9]"') do set II=%%v
for /f "tokens=3 delims=." %%w in ('echo !_IPNET! ^|findstr /r "[1-9]"') do set III=%%w
for /f "tokens=4 delims=." %%m in ('echo !_IPNET! ^|findstr /r "[1-9]"') do set IV=%%m

:: ################################################################################################
:: ######################################  :: CALCULATING :: ######################################
:: ################################################################################################

:: _NETBLOCK = (n+2)/256 - 2^11 / 256 = 8 (-1)
if !_NETMASK! EQU 32 (
	set n=1	& set _N_M=1 & set _NETMASK=1 
) else (
	set /a _NETMASK=32-%_NETMASK%
	set n=1
	for /l %%i in (1,1,!_NETMASK!) do set /a n*=2
	set /a n-=2
)

:: SET /0 -> G-CLASS NETWORK 256^3
if %_NETMASK% GEQ 25 (
	if %_NETMASK% EQU 32 (
		set _NETBLOCK=255
	)
	if %_NETMASK% EQU 31 (
		set /a _NETBLOCK=^(^(%n%+2^)/16777216^)*-1-1
	)
	if %_NETMASK% LSS 31 (
		set /a _NETBLOCK=^(%n%+2^)/16777216-1
	)

	set II=0& set III=0& set IV=0

	set /a I=!I!/^(!_NETBLOCK!+1^)*^(!_NETBLOCK!+1^)
	echo !I! un !_NETBLOCK!
	set /a _FA=^(!I!+0^) & set strtd=!_FA! & set _FA=!_FA!.0.0.1
	echo !_NETBLOCK!
	set /a _LA=!I!+!_NETBLOCK! & set _BC=!_LA!.255.255.255
	set D=!_LA! & set _LA=!_LA!.255.255.254

	set A=255
	set B=255
	set C=254
	set /a _SNMT=255-!_NETBLOCK! & set _SNM=!_SNMT!.0.0.0
	goto _SCAN
)

:: SET /8 -> A-CLASS NETWORK 256^2
if %_NETMASK% GEQ 17 (
	set /a _NETBLOCK=^(%n%+2^)/65536-1

	set /a II=!II!/^(!_NETBLOCK!+1^)*^(!_NETBLOCK!+1^)
	set /a _FA=^(!II!+0^) & set strta=!_FA! & set _FA=!I!.!_FA!.0.1
	set /a _LA=!II!+!_NETBLOCK! & set _BC=!I!.!_LA!.255.255
	set A=!_LA! & set _LA=!I!.!_LA!.255.254

	set III=0& set IV=0
	set B=255
	set C=254
	set /a _SNMT=255-!_NETBLOCK! & set _SNM=255.!_SNMT!.0.0
	goto _SCAN
)

:: SET /16 -> B-CLASS NETWORK 256^1
if %_NETMASK% GEQ 9 (
	set /a _NETBLOCK=^(%n%+2^)/256-1

	set /a III=!III!/^(!_NETBLOCK!+1^)*^(!_NETBLOCK!+1^)
	set /a _FA=^(!III!+0^) & set strtb=!_FA! & set _FA=!I!.!II!.!_FA!.1
	set /a _LA=!III!+!_NETBLOCK! & set _BC=!I!.!II!.!_LA!.255
	set B=!_LA! & set _LA=!I!.!II!.!_LA!.254

	set IV=0
	set D=0
	set A=0
	set C=254
	set /a _SNMT=255-!_NETBLOCK! & set _SNM=255.255.!_SNMT!.0
	goto _SCAN
)

:: SET /24 -> D-CLASS NETWORK 256^0
if %_NETMASK% GEQ 0 (
	set /a _NETBLOCK=^(%n%+2^)/1-1
	set /a IV=!IV!/^(!_NETBLOCK!+1^)*^(!_NETBLOCK!+1^)
	set /a _FA=^(!IV!+1^) & set strt=!_FA! & set _FA=!I!.!II!.!III!.!_FA!
	set /a _LB=!IV!+!_NETBLOCK!-!_N_M! & set _BC=!I!.!II!.!III!.!_LB!
	set /a _LA=!IV!+!_NETBLOCK!-1 & set C=!_LA! & set _LA=!I!.!II!.!III!.!_LA!
	set D=0
	set A=0
	set B=0
	set /a IV+=!_N_M!
	set /a _SNMT=255-!_NETBLOCK!+^(!_N_M!*2^) & set _SNM=255.255.255.!_SNMT!
	goto _SCAN
)

:: ################################################################################################
:: #####################  :: NETINFO SUMMARY AND START SCANNING RANGE :: ##########################
:: ################################################################################################

:_SCAN
echo\
echo ---------------------------------------------------
echo ^| Scanning Hosts: %n%
echo ---------------------------------------------------
echo ---------------------------------------------------
echo ^| Hosts from:     %_FA% to %_LA%
echo ---------------------------------------------------
echo ^| Netadress:      !I!.!II!.!III!.!IV!
echo ---------------------------------------------------
echo ^| Broadcast:      !_BC!
echo ---------------------------------------------------
echo ^| Netmask:        %_SNM%
echo ---------------------------------------------------
echo\ & echo Press Enter if you want continue: & pause>nul
set erl=0

for /l %%d in (!strtd!,1,%D%) do (
	for /l %%a in (!strta!,1,%A%) do (
		for /l %%b in (!strtb!,1,%B%) do (
			for /l %%x in (!strt!,1,%C%) do (
			   REM set /A ip_fu=%ip_nm%%%x
			   REM echo set_debug: %%x : IV = %IV%
			   set IV=%%x 
			   set IP_FOO=!I!.!II!.!III!.!IV!
			   echo ----------------------------------------------
			   echo ^> Now Pinging: !IP_FOO! ...
			   REM echo Now Pinging: !I!.!II!.!III!.!IV!
			   echo ----------------------------------------------
			   ping -w 10 -n 1 !IP_FOO! | findstr /r /c:"[0-9] *ms" >nul
			   set erl=!errorlevel!
			   if !erl! neq 0 (
			       echo * Sry, host unreachable! Try next one ... & echo\
			   ) else (
			       REM getHostnameifAvailable
			       set _host=
			       Color 0A
			       set /a _COUNT+=1
				   for /f "tokens=5 delims= " %%x in ('ping -w 0 -n 1 -a !IP_FOO! ^|findstr /r "[a-Z].+\ \["') do set _host=%%x
			       REM set "LOGVAR=!LOGVAR! %N_L% Host: %ip_nm%%%x & echo.Success Reachable!"
			       echo * Success Reachable * &echo\* Host: !IP_FOO! [!_host!] & echo\
			       echo * Success Reachable * Host: !IP_FOO! [!_host!] >>%LOGF%
			       ping -w %SLEEP% -n 1 2.0.0.0 >nul
			       Color 0E
			   	)
			)
			set /a III+=1
			set strt=0
			
		)
		set /a II+=1
		set III=0
	)
	set /a I+=1
	set II=0
)

echo\ & echo ^> Finishing the Scan, Found !_COUNT! Hosts. 
echo ^> Please see %LOGF% for more infos! & echo\
pause
