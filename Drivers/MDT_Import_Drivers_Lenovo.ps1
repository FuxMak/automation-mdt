#Requires -RunAsAdministrator

#############################################################################################################
#  Script		    :		MDT Driver Import (Lenovo)
#  Author		    :		Marco Fuchs (https://github.com/FuxMak)
#  Description  	:		Automation of MDT driver download and import for Lenovo clients
#  Credits			:		Johan Arwidmark (@jarwidmark), Gary Blok’s (@gwblok), Ryan Ephgrave (@ephingposh), Valentin Popescu (@txvalp)
#############################################################################################################
#  Development/Release Notes:
#  - First draft sourced from client management script for HP clients
#  - Integrated webscraping from Lenovo driver catalog (online)
#  - Adapted MDT default script to support total control (automated) driver integration into imaging
#    M:\Imaging_Buildshare\Scripts\ZTIGather.wsf
#############################################################################################################


#---------------------------------------------------------[Variables]--------------------------------------------------------

# HPE Client MGMT / Image Assistant
$scriptName = "MDT_Import_Drivers_Lenovo"


# Driver specific
$ExtractedDir = "M:\_Source\Drivers\Win10\Lenovo"


$Lenovo_OS = "Win10"
$Lenovo_OSVER = "21H1"
$Lenovo_CatalogURL = "https://download.lenovo.com/cdrt/td/catalogv2.xml"


# MDT / WDS
$deploymentshare = "M:\Imaging_Buildshare"
$MDTModule = "D:\THIRDPARTY\Microsoft\Microsoft Deployment Toolkit\Bin\MicrosoftDeploymentToolkit.psd1"

################################################################################################
# ALTER TABLE TO DOWNLOAD AND IMPORT DRIVERS

# Insert product code and device model into the table below
# For further information please check out the readme file

$ModelsTable_Lenovo = @(
	@{ ProdCode = '20Y7'; Model = 'Thinkpad E14 Gen 3' }
	@{ ProdCode = '21EB'; Model = 'ThinkPad E14 Gen 4' }
	@{ ProdCode = '20J5'; Model = 'ThinkPad L470' }
	@{ ProdCode = '20J9'; Model = 'ThinkPad L570 Type 20J8 20J9' }
)

################################################################################################



#---------------------------------------------------------[Imports]--------------------------------------------------------

# Imports
Import-Module $MDTModule

# Import auxiliariy functions
Import-Module "M:\Imaging_Buildshare\Scripts\_CUSTOM\bin\WriteLog.psm1"
Import-Module "M:\Imaging_Buildshare\Scripts\_CUSTOM\bin\Get-FolderSize.psm1"

#---------------------------------------------------------[Skript]--------------------------------------------------------

# Write-LogHeader
Write-Output "Starting Script: $scriptName"
Write-Log INFO "---------------------------------------------------------------"
Write-Log INFO "Starting Script: $scriptName"

# Download and parse Lenovo model catalog
try {
	[xml]$Lenovo_Catalog = (New-Object System.Net.WebClient).DownloadString($Lenovo_CatalogURL)

}
catch {
	Write-Output "ERROR: Unable to download model list from $Lenovo_CatalogURL - Exiting"
	Write-Log ERROR "ERROR: Unable to download model list from $Lenovo_CatalogURL - Exiting"
	Pause
	EXIT 1
}


# Check deploymentshare
if (!(Get-PSDrive -LiteralName PSDeploymentshare -ErrorAction 'silentlycontinue')) {
	New-PSDrive -Name "PSDeploymentShare" -PSProvider MDTProvider -Root $deploymentshare > $null
	Write-Host Adding MDT Deploymentshare

	Write-Log INFO "Adding $deploymentshare as a PSdrive"
}
else {
	Remove-PSDrive PSDeploymentshare
	Write-Host removing MDT Deploymentshare
	New-PSDrive -Name "PSDeploymentShare" -PSProvider MDTProvider -Root $deploymentshare

	Write-Host Re-adding MDT Deploymentshare
	Write-Log INFO "Adding $deploymentshare as a PSdrive" -LogFile $
}


# Check for driver packages
foreach ($Model_Lenovo in $ModelsTable_Lenovo) {
	Write-Output "Checking Model $($Model_Lenovo.Model) with Product Code $($Model_Lenovo.ProdCode) for Driver Pack updates"
	Write-Log INFO "Checking Model $($Model_Lenovo.Model) with Product Code $($Model_Lenovo.ProdCode) for Driver Pack updates"

	# Check if driver pack exists for configured OS version
	$TMP_Model = ($Lenovo_Catalog.ModelList.Model | where { $_.Types.Type -eq $Model_Lenovo.ProdCode })

	# Extract and filter content from object
	$TMP_ModelName = $TMP_Model.Name
	$TMP_DriverPackURI = ($TMP_Model.SCCM | where { $_.os -eq $Lenovo_OS -and $_.version -eq $Lenovo_OSVER }).'#text'

	# Dynamic pathing
	$DownloadDriverPackExtractFullPath = "$($ExtractedDir)\$TMP_ModelName"
	$MDTTargetFolder = "PSDeploymentShare:\Out-of-Box Drivers\$Lenovo_OS\Lenovo\$TMP_ModelName"

	$TMP_DriverPackName = "DriverPack_" + $Lenovo_OS + "_" + $Lenovo_OSVER + "_" + $Model_Lenovo.ProdCode + ".exe"
	$TMP_DriverInstaller = "$DownloadDriverPackExtractFullPath\$TMP_DriverPackName"

	# Check if driver package is already present
	if (Test-Path $MDTTargetFolder) {
		Write-Log INFO "Driverpack already exists for $TMP_ModelName"
		Write-Output "Driverpack for $TMP_ModelName is already up to date"
		Continue
	}

	# Create directory and download driver package
	Write-Log INFO "Creating driver directory and download driver package"
	if (!(Test-Path $DownloadDriverPackExtractFullPath)) { New-Item $DownloadDriverPackExtractFullPath -ItemType Directory -Force > $null }

	Write-Log INFO "Trying to download driver package from $TMP_DriverPackURI"
	try {
		(New-Object System.Net.WebClient).DownloadFile($TMP_DriverPackURI , $TMP_DriverInstaller)
	}
 catch {
		Write-Output "ERROR: Unable to download driver pack from $TMP_DriverPackURI - Exiting"
		Write-Log ERROR "Unable to download driver pack from $TMP_DriverPackURI - Exiting"
		Pause
		CONTINUE
	}

	# Extract driver files
	Write-Output "Extracting driver pack $TMP_DriverInstaller to $DownloadDriverPackExtractFullPath"
	Write-Log INFO "Extracting driver pack $TMP_DriverInstaller to $DownloadDriverPackExtractFullPath"
	try {
		Start-Process -FilePath $TMP_DriverInstaller -Wait -WorkingDirectory $DownloadDriverPackExtractFullPath -ArgumentList "/verysilent /suppressmsgboxes /SP- /DIR=`"$DownloadDriverPackExtractFullPath`""
	}
 catch {
		Write-Output "ERROR: Unable to extract driver pack $TMP_DriverInstaller - Exiting"
		Write-Log ERROR "Unable to extract driver pack $TMP_DriverInstaller - Exiting"
		Pause
		CONTINUE
	}

	# Import drivers into MDT
	Write-Log INFO "Creating MDT target folder $MDTTargetFolder for import"
	Write-Output "Creating MDT target folder $MDTTargetFolder for import"
	if (!(Test-Path $MDTTargetFolder)) { New-Item $MDTTargetFolder -ItemType Directory -Force > $null }

	Write-Output "Importing driver package into MDT - $MDTTargetFolder"
	Write-Log INFO "Importing driver package into MDT $MDTTargetFolder"

	try {
		Import-MDTDriver -Path "$MDTTargetFolder" -SourcePath "$DownloadDriverPackExtractFullPath"
	}
 catch {
		Write-Output "ERROR: Unable to import drivers into MDT - Exiting"
		Write-Log ERROR "Unable to import drivers into MDT - Exiting"
		Pause
		CONTINUE
	}

	# Optional - Cleanup of extracted files to save space
	# ....
}

# Remove PSDrive (MDT share) and exit script
if (Get-PSDrive -LiteralName PSDeploymentshare -ErrorAction 'silentlycontinue') { Remove-PSDrive -Name "PSDeploymentShare" }

Write-Output "Finished Script: $scriptName"
Write-Log INFO "Finished Script: $scriptName"

Pause
