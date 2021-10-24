SET scriptpath=%~dp0
powershell Invoke-WebRequest -Uri "https://www.proxycap.com/download/pcap536_x64.msi" -OutFile "%scriptpath%\pcap536_x64.msi"
