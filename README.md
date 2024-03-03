# Packer-Win2025
As Windows Server 2025 Preview is officially released, I wanted to test a  automated build of the Windows Server 2025 Preview release. So that I can deploy this in my home lab and going to test the new features.
  
About Hashicorp Packer 
Hashicorp Packer is a self-contained executable producing quick and easy operating system builds across multiple platforms. Using Packer and a couple of HCL2 files, you can quickly create fully automated template(s) with latest Windows Updates en VMware Tools. When you schedule a fresh builds after patch Tuesday  you have always an up-to-date and fully secured template.
When using VMware customization tools. You can spin up vm’s in minutes.
Automated Windows Server 2025 “Preview” Packer Build

What files are needed? The files and versions I am using at the time of this writing are as follows:
•	Packer 1.10.1 or higher
•	Windows Server 2025 Preview



Outside of downloading both Packer and Windows Server 2022 Preview build, you will need the following files:
•	windowsserver2025.auto.pkrvars.hcl – houses the variable values you want to define. What is the significance of the auto in the file? With the auto appended in the front of the pkrvars.hcl extension, Packer knows to include the file with the build run automatically.
•	windows2025.json.pkr.hcl – the Packer build file
•	Answer file – Generated from Windows System Image Manager (SIM) or copy mine below
•	Custom script file(s) – optional

Other considerations and tasks you will need to complete:
•	Copy the Windows Server 2025 ISO file to a vSphere datastore

Windows Server 2025 Answer file for the automated Packer Build
Like other automated approaches to installing Windows Server, the automated Windows Server 2025 Packer build requires an answer file to provide answers to the GUI automatically and other installation prompts that you normally see in a manual installation of Windows Server. 
You will find the scripts here: https://github.com/WardVissers/Packer-Win2025

