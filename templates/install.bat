@echo off
set INSTALLER_DIR=<%= @install_dir %>
set INSTALLER=<%= @installer %>
set INSTALL_CMD=msiexec /quiet /i
set STATUSFILE=%appdata%\<%= @statusfile %>\installation.status

%INSTALL_CMD% %INSTALLER_DIR%\%INSTALLER%

rem The status file is created by the installer. In case there was an agent installed earlier it could still be 
rem there so we wait until the installer had the chance to remove it.

IF EXIST "%STATUSFILE%" (
	ping -n 30 127.0.0.1 > NUL
)

rem At the end of the installation the status file will be written with the exit code for the installation.

Set COUNT=0
:waitloop
IF EXIST "%STATUSFILE%" GOTO waitloopend
ping -n 5 127.0.0.1 >NUL 
Set /A COUNT+=1
IF %COUNT% gtr 60 GOTO timeout
goto waitloop
:waitloopend

set /p STATUSCODE=<%= '<%STATUSFILE%' %>

if %STATUSCODE% EQU 0 (
	ECHO "Install of oneAgent succeeded!"
	EXIT 0
) ELSE (
	ECHO "Error while installing oneAgent!"
	EXIT 1
)

:timeout
ECHO Timeout while installing oneAgent!
EXIT 2
