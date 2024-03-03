$TempFolder = "C:\TEMP"
New-Item -ItemType Directory -Force -Path $TempFolder

netsh advfirewall firewall set rule group="Network Discovery" new enable=No

### Open RDP
netsh advfirewall firewall add rule name="Open Port 3389" dir=in action=allow protocol=TCP localport=3389

New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -name fDenyTSConnections -PropertyType DWORD -Value 0 -Force