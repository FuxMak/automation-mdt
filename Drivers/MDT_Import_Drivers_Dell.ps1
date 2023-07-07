#Requires -RunAsAdministrator

#############################################################################################################
#  Script		    :		MDT Driver Import (Dell)
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
$scriptName = "MDT_Import_Drivers_Dell"

$Dell_OS = "Win11"
$Dell_OSVER = "22H2"
$Dell_OSCODE = "Windows11"

# Driver specific
$ExtractedDir = "M:\_Source\Drivers\$Dell_OS\Dell"
$ExtractedDir

$Dell_CatalogURL = "http://downloads.dell.com/catalog/DriverPackCatalog.cab"
$Dell_Catalog_src = "$ExtractedDir\DriverPackCatalog.cab"
$Dell_Catalog_dest = "$ExtractedDir\DriverPackCatalog.xml"

# MDT / WDS
$deploymentshare = "M:\Imaging_Buildshare"
$MDTModule = "D:\THIRDPARTY\Microsoft\Microsoft Deployment Toolkit\Bin\MicrosoftDeploymentToolkit.psd1"

################################################################################################
# ALTER TABLE TO DOWNLOAD AND IMPORT DRIVERS

# Insert product code and device model into the table below
# For further information please check out the readme file

$ModelsTable_Dell = @(
	@{ ProdCode = '0AC5'; Model = 'OptiPlex 3000' }
)

################################################################################################

#---------------------------------------------------------[Imports]--------------------------------------------------------

# Imports MDT modules
Import-Module $MDTModule -ErrorAction Stop

# Import auxiliariy functions
Import-Module "M:\Imaging_Buildshare\Scripts\_CUSTOM\bin\WriteLog.psm1"
Import-Module "M:\Imaging_Buildshare\Scripts\_CUSTOM\bin\Get-FolderSize.psm1"

#---------------------------------------------------------[Skript]--------------------------------------------------------

# Write-LogHeader
Write-Output "Starting Script: $scriptName"
Write-Log INFO "---------------------------------------------------------------"
Write-Log INFO "Starting Script: $scriptName"


# Prerequisites - Deploy

# Download and parse Dell model catalog
try {
	$Dell_Catalog = (New-Object System.Net.WebClient).DownloadFile($Dell_CatalogURL, $Dell_Catalog_src)
	EXPAND $Dell_Catalog_src $Dell_Catalog_dest

}
catch {
	Write-Output "ERROR: Unable to download model list from $Dell_CatalogURL - Exiting"
	Write-Log ERROR "ERROR: Unable to download model list from $Dell_CatalogURL - Exiting"
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

# Extract info from XML file
[xml]$Dell_Catalog_XML = Get-Content $Dell_Catalog_dest -ErrorAction Stop



# Check for driver packages
foreach ($Model_Dell in $ModelsTable_Dell) {
	Write-Output "Checking Model $($Model_Dell.Model) with Product Code $($Model_Dell.ProdCode) for Driver Pack updates"
	Write-Log INFO "Checking Model $($Model_Dell.Model) with Product Code $($Model_Dell.ProdCode) for Driver Pack updates"

	# Check if driver pack exists for configured OS version
	$TMP_Model = $Dell_Catalog_XML.DriverPackManifest.DriverPackage | where { ($_.SupportedSystems.Brand.Model.SystemID -eq $Model_Dell.ProdCode) -and ($_.SupportedOperatingSystems.OperatingSystem.osCode -eq $Dell_OSCODE) }

	# Extract and filter content from object
	$TMP_DriverPackURI = "http://" + $Dell_Catalog_XML.DriverPackManifest.baseLocation + "/" + $TMP_Model.Path

	# Dynamic pathing
	$DownloadDriverPackExtractFullPath = "$($ExtractedDir)\$($Model_Dell.Model)"
	$MDTTargetFolder = "PSDeploymentShare:\Out-of-Box Drivers\$Dell_OS\Dell Inc.\$($Model_Dell.Model)"

	$TMP_DriverPackName = "DriverPack_" + $Dell_OS + "_" + $Model_Dell.ProdCode + ".exe"
	$TMP_DriverInstaller = "$DownloadDriverPackExtractFullPath\$TMP_DriverPackName"

	# Check if driver package is already present
	if (Test-Path $MDTTargetFolder) {
		Write-Log INFO "Driverpack already exists for $($Model_Dell.Model)"
		Write-Output "Driverpack for $($Model_Dell.Model) is already up to date"
		Continue
	}

	# Create directory and download driver package
	Write-Log INFO "Creating driver directory and download driver package"
	if (!(Test-Path $DownloadDriverPackExtractFullPath)) { New-Item $DownloadDriverPackExtractFullPath -ItemType Directory -Force > $null }

	Write-Log INFO "Trying to download driver package from $TMP_DriverPackURI"
	try {
		(New-Object System.Net.WebClient).DownloadFile($TMP_DriverPackURI, $TMP_DriverInstaller)
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
		Start-Process -FilePath "$TMP_DriverInstaller" -Wait -WorkingDirectory "$DownloadDriverPackExtractFullPath" -ArgumentList "/s /e=`"$DownloadDriverPackExtractFullPath`" /l=`"Extract.log`""
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
