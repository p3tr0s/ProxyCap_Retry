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

Requirements (for v538):
<li>Edit the script [line:7] remove "rem" and change localhost to a url with your .prs config file for persistance between software reloads
<li>Run as administrator in order to delete old registry keys.
<li>The START.bat script will try to download `pcap53*_x64.msi` from the `<a href="https://www.proxycap.com/">official site</a>` in the `./files/` dir if it's not already there.
<li>If the version changes you need to modify the var with the name of the .exe in the script.
<li>It will silently reinstall ProxyCap (no prompts or restart)
<li>It will finish by running the "refreshed" proxycap.

You could add the START_53*.bat to a recurring (every ~25 days) scheduled task in Windows, with some conditions, for maximum carelessness(?)
