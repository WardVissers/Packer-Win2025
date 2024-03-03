<#
  This script will change or remove the drive letter of all CDROM
  & DVD Drives found. If changing the drive letters, it will start
  from whatever is set as $LastDriveLetter, working backwards until
  it finds an available drive letter.

  Example 1: If you have 1 CDROM/DVD drive mounted as D: and there
             is nothing using Z:, it will change the CDROM/DVD to
             Z: However, if Z: is already in use, it will use Y:
             instead, and so on.

  Example 2: If you have 2 CDROM/DVD drives mounted as D: and E:, 
             it will change the CDROM/DVD on E: to Z: and D: to Y:.
             However, if Z: or Y: are already in use, it will use
             the next available drive letter.

  The whole point is to get them out of the way so that they
  don't interfere with DiskPart, etc.

  Remember that if you're running the script from an MDT Task
  Sequence, you're deployment share will already be mapped to Z:
  drive, so you're CDROM/DVD drive will typically end up as Y:.

  Syntax Examples:

  - Run the script without parameters to default to Z as the
    drive letter to start from:
      ChangeCDRomDriveLetter.ps1

  - To specify T as the drive letter to start from:
      ChangeCDRomDriveLetter.ps1 -LastDriveLetter:t

  - To remove the drive letter from existing CDROM/DVD drive(s):
      ChangeCDRomDriveLetter.ps1 -Remove

  Script Name: ChangeCDRomDriveLetter.ps1
  Release 1.3
  Written by Jeremy@jhouseconsulting.com 8th December 2014
  Modified by Jeremy@jhouseconsulting.com 14th May 2016

#>
#-------------------------------------------------------------
param([string]$LastDriveLetter,[switch]$Remove)

# Set Powershell Compatibility Mode
Set-StrictMode -Version 2.0

# Enable verbose output
$VerbosePreference = 'Continue' 

If ([String]::IsNullOrEmpty($LastDriveLetter)) {
  $LastDriveLetter = "z"
}

#-------------------------------------------------------------

Get-WmiObject win32_logicaldisk -filter 'DriveType=5' | Sort-Object -property DeviceID -Descending | ForEach-Object { 
    Write-Verbose "Found CDROM drive on $($_.DeviceID)"
    $a = mountvol $_.DeviceID /l
    # Get first free drive letter starting from Z: and working backwards.
    # Many scripts on the Internet recommend using the following line:
    # $UseDriveLetter = Get-ChildItem function:[d-$LastDriveLetter]: -Name | Where-Object {-not (Test-Path -Path $_)} | Sort-Object -Descending | Select-Object -First 1
    # However, if you run Test-Path on a CD-ROM or other drive letter
    # without any media, it will return False even though the drive letter
    # itself is in use. So to ensure accuracy we use the following line:
    $UseDriveLetter = Get-ChildItem function:[d-$LastDriveLetter]: -Name | Where-Object { (New-Object System.IO.DriveInfo($_)).DriveType -eq 'NoRootDirectory' } | Sort-Object -Descending | Select-Object -First 1
    If ($UseDriveLetter -ne $null -AND $UseDriveLetter -ne "") {
      If ($Remove -eq $False) {
        Write-Verbose "$UseDriveLetter is available to use"
        Write-Verbose "Changing $($_.DeviceID) to $UseDriveLetter"
      }
      mountvol $_.DeviceID /d
      Write-Verbose "Unmounted volume for $($_.DeviceID) completed with an exit code of $LastExitCode"
      If ($Remove -eq $False) {
        $a = $a.Trim()
        mountvol $UseDriveLetter $a
        Write-Verbose "Mounting volume to $UseDriveLetter completed with an exit code of $LastExitCode"
      }
    } else {
      Write-Verbose "No available drive letters found."
    }
  }

$ExitCode = 0
Write-Verbose "Completed with an exit code of $ExitCode"
Exit $ExitCode
