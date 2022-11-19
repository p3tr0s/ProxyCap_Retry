@echo off
SET RootDir=%~dp0
SET ExeName=pcap536_x64.msi
SET LookForRegKey=%RootDir%files\Registration.reg
SET LookForExe=%RootDir%files\%ExeName%
REM Get installation dir from registry
FOR /F "skip=2 tokens=2,*" %%A IN ('reg.exe query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "ProxyCap"') DO set "InstallDir=%%B"
SET WindowsSBdir=%systemroot%\system32\WindowsSandbox.exe

if not exist %RootDir%files\ mkdir %RootDir%files\

reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT
if %OS%==32BIT GOTO Arc_x86
if %OS%==64BIT GOTO Arc_x64

:Arc_x86
	echo This is a 32bit operating system - this script is for 64bit OS
	GOTO Closethis

:Arc_x64
	echo 64bit OS detected...

setlocal
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
if "%version%" GEQ  "10.0" (goto CheckForVM) else (goto versionCheck)
endlocal

:versionCheck
	echo You need Windows 10 or greater...
	TIMEOUT /T 5 >nul
	exit

:CheckForVM
	IF EXIST %WindowsSBdir% GOTO CheckForWSBfile
	echo You need to have the Windows 10 Sandbox option enabled/installed...
	TIMEOUT /T 5 >nul
	exit
	
:CheckForWSBfile
	IF EXIST %RootDir%\files\sandbox.wsb GOTO CheckForCore
	echo ^<Configuration^>>%RootDir%\files\sandbox.wsb
	echo  ^<Networking^>Disabled^</Networking^>>>%RootDir%\files\sandbox.wsb
	echo  ^<MappedFolders^>>>%RootDir%\files\sandbox.wsb
	echo    ^<MappedFolder^>>>%RootDir%\files\sandbox.wsb
	echo      ^<HostFolder^>%RootDir%files^</HostFolder^>>>%RootDir%\files\sandbox.wsb
	echo      ^<ReadOnly^>false^</ReadOnly^>>>%RootDir%\files\sandbox.wsb
	echo    ^</MappedFolder^>>>%RootDir%\files\sandbox.wsb
	echo  ^</MappedFolders^>>>%RootDir%\files\sandbox.wsb
	echo  ^<LogonCommand^>>>%RootDir%\files\sandbox.wsb
	echo    ^<Command^>powershell -command "while (!(Test-PathC:\\Users\\WDAGUtilityAccount\\Desktop\\files\\core.bat)) { Start-Sleep 1 } Start-Process C:\\Users\\WDAGUtilityAccount\\Desktop\\files\\core.bat" ^</Command^>>>%RootDir%\files\sandbox.wsb
	echo  ^</LogonCommand^>>>%RootDir%\files\sandbox.wsb
	echo ^</Configuration^>>>%RootDir%\files\sandbox.wsb

:CheckForCore
	IF EXIST %RootDir%\files\core.bat GOTO check_Permissions
	echo ^@echo off>%RootDir%files\core.bat
	echo set proxycap_file=C:/Users/WDAGUtilityAccount/Desktop/files/%ExeName%>>%RootDir%files\core.bat
	echo echo Extracting Proxycap registration key...>>%RootDir%files\core.bat
	echo echo please wait ...>>%RootDir%files\core.bat
	echo "%%proxycap_file%%" /qn /norestart>>%RootDir%files\core.bat
	echo rem get Registration Key for x64>>%RootDir%files\core.bat
	echo "reg" "export" "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Proxy Labs\ProxyCap\Registration" "C:/Users/WDAGUtilityAccount/Desktop/files/Registration.reg" /Y>>%RootDir%files\core.bat
	echo echo [DONE] Extracting Proxycap registration key...>>%RootDir%files\core.bat
	echo echo Sandbox closing...>>%RootDir%files\core.bat
	echo TIMEOUT /T 10 ^>nul>>%RootDir%files\core.bat


:check_Permissions
    net session >nul 2>&1
    if %errorLevel% == 0 (
        goto :DownloadEXE
    ) else (
		echo Please run as administrator for the registry key to be updated automatically...
		TIMEOUT /T 5 >nul
		goto :DownloadEXE
    )
	
:DownloadEXE
	IF EXIST %LookForExe% GOTO START
	echo Downloading %ExeName% ...
	powershell Invoke-WebRequest -Uri "https://www.proxycap.com/download/%ExeName%" -OutFile "%RootDir%files\%ExeName%"

:START
	cls
	echo [DONE] Downloading %ExeName% ...
	echo Terminating pcapui.exe...
	taskkill /F /IM "pcapui.exe" >nul
	cls
	echo [Done] Terminating pcapui.exe...
	echo Deleting previous extracted key...
	del %LookForRegKey% >nul
	cls	
	echo [DONE] Terminating pcapui.exe...
	echo [Done] Deleting previous extracted key...
	echo Starting Windows Sandbox...
	start %WindowsSBdir% %RootDir%\files\sandbox.wsb
	cls
	echo [DONE] Terminating pcapui.exe...
	echo [DONE] Starting Windows Sandbox...
	TIMEOUT /T 13 >nul
	cls
	echo [DONE] Terminating pcapui.exe...
	echo [DONE] Starting Windows Sandbox...
	echo Waiting for the new registry key to be extracted...
	GOTO CheckForFile

:CheckForFile
	IF EXIST %LookForRegKey% GOTO FoundIt
	TIMEOUT /T 2 >nul
	GOTO CheckForFile

:FoundIt
	cls
	echo [DONE] Terminating pcapui.exe...
	echo [DONE] Starting Windows Sandbox...
	echo [DONE] Waiting for the new registry key to be extracted...
	echo Terminating Windows Sandbox...
	TIMEOUT /T 3 >nul
	taskkill /F /IM "WindowsSandbox.exe" >nul
	taskkill /F /IM "WindowsSandboxClient.exe" >nul
	cls
	echo [DONE] Terminating pcapui.exe...
	echo [DONE] Starting Windows Sandbox...
	echo [DONE] Waiting for the new registry key to be extracted...
	echo [DONE] Terminating Windows Sandbox...

	cls
	echo [DONE] Terminating pcapui.exe...
	echo [DONE] Starting Windows Sandbox...
	echo [DONE] Waiting for the new registry key to be extracted...
	echo [DONE] Terminating Windows Sandbox...
	net session >nul 2>&1
    if %errorLevel% == 0 (
		echo Importing the new registry key...
        reg import %LookForRegKey%
		TIMEOUT /T 2 >nul
    ) else (
		echo [CAUTION] Remember to import the Registration.reg to your registry OR run this script as administrator... [CAUTION]
		TIMEOUT /T 5 >nul
    )
	cls
	echo [DONE] Terminating pcapui.exe...
	echo [DONE] Starting Windows Sandbox...
	echo [DONE] Waiting for the new registry key to be extracted...
	echo [DONE] Terminating Windows Sandbox...
	net session >nul 2>&1
	if %errorLevel% == 0 (
		echo [DONE] Importing the new registry key...
    ) else (
		echo [CAUTION] Remember to import the Registration.reg to your registry OR run the script as administrator... [CAUTION]
    )
	echo Starting pcapui.exe
	START "" "%InstallDir%"
	
	cls
	echo [DONE] Terminating pcapui.exe...
	echo [DONE] Starting Windows Sandbox...
	echo [DONE] Waiting for the new registry key to be extracted...
	echo [DONE] Terminating Windows Sandbox...
	net session >nul 2>&1
	if %errorLevel% == 0 (
		echo [DONE] Importing the new registry key...
    ) else (
		echo [CAUTION] Remember to import the Registration.reg to your registry OR run the script as administrator... [CAUTION]
    )
	echo [DONE] Starting pcapui.exe
	GOTO Closethis

:Closethis
	echo Exiting...
	TIMEOUT /T 5 >nul
	exit
