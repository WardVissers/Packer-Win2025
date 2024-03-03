# Variables
$downloadfolder = 'd:\packer\'


# Go to the Packer download folder
Set-Location $downloadfolder

# Show Packer Version
.\packer.exe -v

# Download Packer plugins
.\packer.exe init "${downloadfolder}basis.pkr.hcl"

# Validate 
.\packer.exe validate "${downloadfolder}windows2025.json.pkr.hcl"


# Packer build Server 2025
.\packer.exe build -force -var-file="${downloadfolder}windowsserver2025.auto.pkrvars.hcl" "${downloadfolder}windows2025.json.pkr.hcl"