@echo off
SET RootDir=%~dp0
SET ExeName=pcap538_x64.msi
SET LookForExe=%RootDir%files\%ExeName%
SET SettingsBackupDir=%RootDir%settingsBackup
REM Get installation dir from registry
FOR /F "skip=2 tokens=2,*" %%A IN ('reg.exe query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "ProxyCap"') DO set "InstallDir=%%B"
rem Add below a url with your settings backup for persistance
rem SET settingsUrl="http://localhost/proxycap_backup_settings.prs"
set BackupFile=%date:~10,4%%date:~7,2%%date:~4,2%_machine.prs
if not exist %SettingsBackupDir% mkdir %SettingsBackupDir%
copy %ProgramData%\ProxyCap\machine.prs "%RootDir%settingsBackup\%BackupFile%"
SET BackupFile="%RootDir%settingsBackup\%BackupFile%"

if not exist %RootDir%files\ mkdir %RootDir%files\

reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT
if %OS%==32BIT GOTO Arc_x86
if %OS%==64BIT GOTO Arc_x64

:Arc_x86
	echo This is a 32bit operating system - this script is for 64bit OS
	GOTO Closethis

:Arc_x64
	echo 64bit OS detected...

:check_Permissions
    net session >nul 2>&1
    if %errorLevel% == 0 (
        goto DownloadEXE
    ) else (
		echo Please run as administrator...
		TIMEOUT /T 5 >nul
		GOTO Closethis
    )
	
:DownloadEXE
	IF EXIST %LookForExe% GOTO START
	echo Downloading %ExeName% ...
	powershell Invoke-WebRequest -Uri "https://www.proxycap.com/download/%ExeName%" -OutFile "%RootDir%files\%ExeName%"

:START
	cls
	echo [DONE] Downloading %ExeName% ...
	echo Terminating pcapui.exe...
	net stop pcapsvc
	taskkill /F /IM "pcapui.exe" >nul
	reg delete "HKEY_LOCAL_MACHINE\Software\WOW6432Node\Proxy Labs" /f
	reg delete "HKEY_LOCAL_MACHINE\Software\WOW6432Node\SB" /f
	reg delete "HKEY_LOCAL_MACHINE\System\ControlSet001\Services\pcapsvc" /f
	reg delete "HKEY_LOCAL_MACHINE\System\ControlSet001\Services\Tcpip\Parameters\Arp" /f
	cls
	echo [DONE] Deleting old registry keys...
	echo [DONE] Terminating pcapui.exe...
	echo "Repairing" ProxyCap...
	IF [%settingsUrl%] == [] GOTO NOSETTINGS
:SETTINGS
	cmd /c %LookForExe% /qn /norestart PROXYCAPRULESETURL=%settingsUrl%
	GOTO REPAIR
:NOSETTINGS
	cmd /c %LookForExe% /qn /norestart
:REPAIR
	cls
	echo [Done] Repairing ProxyCap...
	TIMEOUT /T 1 >nul
	net start pcapsvc
	START "" "%InstallDir%"
	GOTO Closethis

:Closethis
	cls
	echo We are done (probably)...
	echo Exiting...
	TIMEOUT /T 5 >nul
	exit
