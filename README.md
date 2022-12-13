<p align="center"><img title="proxycap" src="https://img.shields.io/badge/Requires-ProxyCap-green"><br>
<img title="Version" src="https://img.shields.io/badge/For Version-5.3.6-yellow">
<img title="Version" src="https://img.shields.io/badge/Status-Tested-green">
<br>
<img title="Version" src="https://img.shields.io/badge/For Version-5.3.8-green">
<img title="Version" src="https://img.shields.io/badge/Status-Tested-green">
</p>
# Retry Proxycap

Inspired by <a href="https://github.com/lianshufeng/proxycap_crack">lianshufeng/proxycap_crack</a>

A very badly written batch script to reset the 30 day trial of Proxycap. <br>

It utilizes the Windows 10 Sandbox to extract a fresh 30 day trial key.

Requirements:
<li>Have Windows 10 (x64) and the Sandbox enabled (<a href="https://letmegooglethat.com/?q=how+to+enable+sandbox+in+windows+10">How To...</a>)
<li>The START.bat script will try to download `pcap53*_x64.msi` from the `<a href="https://www.proxycap.com/">official site</a>` in the `./files/` dir if it's not already there.
<li>If the version changes you need to modify the var with the name of the .exe in the script.
<li>After any changes in the variables it would be best to delete the contents of ./files dir so the script recreates the necessary files with the correct information.

<li>If you run `START_53*.bat` as administrator the registry key will be imported automatically otherwise use regedit to import the `./files/Registration.reg`
  
You could add the START.bat to a recurring (every ~25 days) scheduled task in Windows, with some conditions, for maximum carelessness(?)
