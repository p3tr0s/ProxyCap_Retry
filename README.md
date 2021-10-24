# Retry Proxycap

Inspired by <a href="https://github.com/lianshufeng/proxycap_crack">lianshufeng/proxycap_crack</a>

A very badly written batch script to reset the 30 day trial of Proxycap. It utilizes the Windows 10 Sandbox to extract a fresh 30 day trial key.<br>

Requirements:<br>
<li>Have Windows 10 (x64) and the Sandbox enabled
<li>The root folder of the script needs to be placed in C:\ otherwise you need to modify the var %RootDir% in START.bat
<li>The START.bat script will try to download pcap536_x64.msi from the <a href="https://www.proxycap.com/">official site</a> in the ./files/ dir if it's not already there
<li>If the version changes you need to modify the vars in START.bat and ./files/sandbox.wsb

If you run START.bat as administrator the registry key will be imported automatically otherwise use regedit to import the ./files/Registration.reg

It's advisable to restart your PC after you are done.
  
You could add the START.bat to a recurring (every ~25 days) scheduled task in Windows, with some conditions, for maximum carelessness(?)
