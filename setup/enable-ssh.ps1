# Set network connections profile to Private mode.
Write-Output 'Setting the network connection profiles to Private...'
do {
    $connectionProfile = Get-NetConnectionProfile
    Start-Sleep -Seconds 10
} while ($connectionProfile.Name -eq 'Identifying...')
Set-NetConnectionProfile -Name $connectionProfile.Name -NetworkCategory Private
 
# Install the OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
 
# Start the sshd service
Start-Service sshd
 
# Start the SSH service automatic at startup
Set-Service -Name sshd -StartupType 'Automatic'
 
# Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify
if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
  Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
  New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} else {
  Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
}