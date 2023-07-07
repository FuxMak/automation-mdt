#Requires -RunAsAdministrator
#Requires -Modules HP.Softpaq

#############################################################################################################
#  Script		    :		MDT Driver Import (HPE)
#  Author		    :		Marco Fuchs (https://github.com/FuxMak)
#  Description  	:		Automation of MDT driver download and import for HPE professional notebooks and desktops
#  Credits			:		Johan Arwidmark (@jarwidmark), Gary Blok’s (@gwblok), Ryan Ephgrave (@ephingposh), Valentin Popescu (@txvalp)
#############################################################################################################
#  Development/Release Notes:
#  - First draft
#############################################################################################################


#---------------------------------------------------------[Variables]--------------------------------------------------------

# HPE Client MGMT / Image Assistant
$scriptName = "MDT_Import_Drivers_HPE"


# MDT / WDS
$deploymentshare = "M:\Imaging_Buildshare"
$MDTModule = "D:\THIRDPARTY\Microsoft\Microsoft Deployment Toolkit\Bin\MicrosoftDeploymentToolkit.psd1"

# Driver specific
$HPE_OS = "Win10"
$HPE_OSVER = "22H2"

$ExtractedDir = "M:\_Source\Drivers\$HPE_OS\HP"

#Reset Vars
$DriverPack = ""
$Model = ""

################################################################################################
# ALTER TABLE TO DOWNLOAD AND IMPORT DRIVERS

# Insert product code and device model into the table below
# For further information please check out the readme file

$HPModelsTable = @(
	#@{ ProdCode = '897C'; Model = 'HP EliteBook 650 15.6 inch G9 Notebook PC' }
	#@{ ProdCode = '871C'; Model = 'HP ProOne 600 G6 22 All-in-One PC' }
	#@{ ProdCode = '871C'; Model = 'HP ProOne 600 G6 AiO' }
	#@{ ProdCode = '871C'; Model = 'HP ProOne 440 G6 24 All-in-One PC' }
	#@{ ProdCode = '8A77'; Model = 'HP ProBook 450 G8 Notebook PC' }
	#@{ ProdCode = '85F3'; Model = 'HP 250 G8 Notebook PC' }
	#@{ ProdCode = '8AA1'; Model = 'HP ProBook 450 15.6 inch G9 Notebook PC' }
	#@{ ProdCode = '8978'; Model = 'HP ProBook 450 15.6 inch G9 Notebook PC' }
	#@{ ProdCode = '8882'; Model = 'HP ProDesk 405 G8 Desktop Mini PC' }
	#@{ ProdCode = '82AA'; Model = 'HP ProBook 650 G3' }
	#@{ ProdCode = '87ED'; Model = 'HP ProBook 650 G8 Notebook PC' }
)

################################################################################################


#---------------------------------------------------------[Imports]--------------------------------------------------------

# Imports
Import-Module $MDTModule

# Import auxiliariy functions
Import-Module "M:\Imaging_Buildshare\Scripts\_CUSTOM\bin\CMTraceLog.psm1"
Import-Module "M:\Imaging_Buildshare\Scripts\_CUSTOM\bin\WriteLog.psm1"
Import-Module "M:\Imaging_Buildshare\Scripts\_CUSTOM\bin\Get-FolderSize.psm1"

#---------------------------------------------------------[Skript]--------------------------------------------------------

Write-Output "Starting Script: $scriptName"

# Write-LogHeader
Write-Log INFO "Starting Script: $scriptName"


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
	Write-Log INFO "Adding $deploymentshare as a PSdrive"
}

# Check driver package
foreach ($HPModel in $HPModelsTable) {
	#CMTraceLog -Message "Checking Model $($HPModel.Model) Product Code $($HPModel.ProdCode) for Driver Pack Updates" -Type 1 -LogFile $log_file
	Write-Output "Checking Model $($HPModel.Model) Product Code $($HPModel.ProdCode) for Driver Pack Updates"
	Write-Log INFO "Checking Model $($HPModel.Model) Product Code $($HPModel.ProdCode) for Driver Pack Updates"

	# Dynamic pathing
	#$DownloadDriverPackRootArchiveFullPath = "$($DownloadDir)\$($HPModel.Model)"
	$DownloadDriverPackExtractFullPath = "$($ExtractedDir)\$($HPModel.Model)"
	#$MDTTargetFolder = "PSDeploymentShare:\Out-of-Box Drivers\$HPE_OS\HP\$($HPModel.Model)"
	$MDTTargetFolder = "PSDeploymentShare:\Out-of-Box Drivers\$HPE_OS\HP\$($HPModel.Model)"


	# $TempDir = "W:\Drivers\_Source\_Temp\$($HPModel.Model)"

	# Get driver pack with HPE script
	try {
		$SoftPaq = Get-SoftpaqList -platform $HPModel.ProdCode -os $HPE_OS -osver $HPE_OSVER
	}
 catch {
		Write-Output "ERROR: Unable to find drivers for Model $($HPModel.Model) and Product Code $($HPModel.ProdCode) online"
		Write-Log ERROR "Unable to find drivers for Model $($HPModel.Model) and Product Code $($HPModel.ProdCode) online"
		Continue
	}

	$DriverPack = $SoftPaq | Where-Object { $_.category -eq 'Manageability - Driver Pack' }
	$DriverPack = $DriverPack | Where-Object { $_.Name -notmatch "Windows PE" }
	$DriverPack = $DriverPack | Where-Object { $_.Name -notmatch "WinPE" }


	# (Re-)Create required directories
	# Remove old directories
	#if (Test-Path $DownloadDriverPackRootArchiveFullPath) { Remove-Item -Path $DownloadDriverPackRootArchiveFullPath -Recurse -Force -ErrorAction SilentlyContinue }
	if (Test-Path $DownloadDriverPackExtractFullPath) { Remove-Item -Path $DownloadDriverPackExtractFullPath -Recurse -Force -ErrorAction SilentlyContinue }
	#if (Test-Path $TempDir) { Remove-Item -Path $TempDir -Recurse -Force -ErrorAction SilentlyContinue }

	# Recreate directory structure
	#New-Item $DownloadDriverPackRootArchiveFullPath -ItemType Directory -Force  > $null
	New-Item $DownloadDriverPackExtractFullPath -ItemType Directory -Force > $null
	#New-Item $TempDir -ItemType Directory -Force  > $null

	if ($DriverPack) {
		if (Test-Path $MDTTargetFolder) {
			Write-Log INFO "Driver version $($driverpack.Version) already exists for $($HPModel.Model)"
			#CMTraceLog -Message "$($driverpack.Version) already exists for $($HPModel.Model)" -Type 1 -LogFile $log_file

			Write-Output "Driverpack for $($HPModel.Model) is already up to date"
			Continue
		}
		else {

			Write-Log INFO "Found $DriverPack for $($HPModel.Model) Product Code $($HPModel.ProdCode)"
			#CMTraceLog -Message "Found $DriverPack for $($HPModel.Model) Product Code $($HPModel.ProdCode)" -Type 1 -LogFile $log_file

			# Dynamic pathing
			#$SaveAs = "$($DownloadDriverPackRootArchiveFullPath)\$($DriverPack.id).exe"

			# Download driver package
			Write-Output "Downloading and extracting driverpack for $($HPModel.Model)...this might take a while..."
			Write-Log INFO "Downloading and extracting driverpack for $($HPModel.Model)...this might take a while..."

			#Get-Softpaq -number $DriverPack.id -saveAs $SaveAs -overwrite yes -KeepInvalidSigned
			Get-Softpaq -number $DriverPack.id -Extract -DestinationPath "$DownloadDriverPackExtractFullPath" -overwrite yes -KeepInvalidSigned
			Export-Clixml -InputObject $DriverPack -Path "$($DownloadDriverPackExtractFullPath)\DriverPackInfo.XML"


			Write-Output "Successfully extracted driver package $($DriverPack.id) for $($HPModel.Model)..."
			Write-Log INFO "Successfully extracted driver package $($DriverPack.id) for $($HPModel.Model)..."

			Remove-Item -Path "$($DriverPack.id).exe" -Force

			Write-Output "Removing source file $($SP.id).exe..."
			Write-Log INFO "Removing source file $($SP.id).exe..."

			# Extract driver package
			#Write-Log INFO "Extracting drivers into $TempDir"
			#Start-Process $SaveAs -ArgumentList "-s -e -f `"$TempDir`"" -Wait 2>> $log_file
			#Copy-Item "$($TempDir)\*" -Destination $DownloadDriverPackExtractFullPath -Force -Recurse 2>> $log_file


			# Remove old driver paths in $deploymentshare
			#Write-Output "Removing out of date Drivers and creating new folder $MDTTargetFolder"
			#Write-Log INFO "Removing out of date Drivers and creating new folder $MDTTargetFolder"

			#CMTraceLog -Message "Removing out of date Drivers and creating new folder $MDTTargetFolder" -Type 1 -LogFile $log_file
			#if (Test-Path $TempDir) { Remove-Item -Path $TempDir -Recurse -Force -ErrorAction SilentlyContinue }

		}
	}
 else {

		if (Test-Path $MDTTargetFolder) {
			Write-Log INFO "Driverpack already exists for $($HPModel.Model)"
			Write-Output "Driverpack for $($HPModel.Model) is already up to date"
			Continue
		}
		else {

			#CMTraceLog -Message "No Driver Pack Available for $($HPModel.Model) Product Code $($HPModel.ProdCode) $($HPE_OS) $($HPE_OSVER) from HPE" -Type 3 -LogFile $log_file
			Write-Output "No Driver Pack Available for $($HPModel.Model) Product Code $($HPModel.ProdCode) $($HPE_OS) $($HPE_OSVER) from HPE"
			Write-Log INFO "No Driver Pack Available for $($HPModel.Model) Product Code $($HPModel.ProdCode) $($HPE_OS) $($HPE_OSVER) from HPE"

			# Create own driver pack using HP Client Management Script Utilities

			$SoftPaqs = Get-SoftpaqList -Platform $HPModel.ProdCode -os $HPE_OS -OsVer $HPE_OSVER -Category Driver  | Where-Object { $_.Name -notmatch "HP" } | Where-Object { $_.Name -notmatch "Dock" }
			#CMTraceLog -Message "Downloading driver packages for $($HPModel.Model)...this might take a while" -Type 1 -LogFile $log_file
			Write-Output "Downloading and extracting driver packages for $($HPModel.Model)...this might take a while"
			Write-Log INFO "Downloading and extracting driver packages for $($HPModel.Model)...this might take a while"

			foreach ($SP in $SoftPaqs) {
				$SaveAs = "$($DownloadDriverPackExtractFullPath)\$($SP.id)"

				# Download individual softpack
				#CMTraceLog -Message "Downloading driver $($SP.id).exe for $($HPModel.Model)..." -Type 1 -LogFile $log_file
				#Get-Softpaq -number $SP.id -saveAs $SaveAs -overwrite yes -KeepInvalidSigned 2>> $log_file

				Write-Output "Downloading driver $($SP.id) for $($HPModel.Model)..."
				Write-Log INFO "Downloading driver $($SP.id) for $($HPModel.Model)..."

				Get-Softpaq -number $SP.id -Extract -DestinationPath "$SaveAs" -overwrite yes -KeepInvalidSigned 2>> $log_file
				Export-Clixml -InputObject $SP -Path "$($DownloadDriverPackExtractFullPath)\$($SP.id)\DriverInfo.XML"


				Write-Output "Successfully extracted driver package $($SP.id) for $($HPModel.Model)..."
				Write-Log INFO "Successfully extracted driver package $($SP.id) for $($HPModel.Model)..."

				Remove-Item -Path "$($SP.id).exe" -Force

				Write-Output "Removing source file $($SP.id).exe..."
				Write-Log INFO "Removing source file $($SP.id).exe..."

				# Extract the driver pack and gather info file
				#Write-Output "Extracting driver $($SP.id).exe to $TempDir\$($SP.id)"
				#CMTraceLog -Message "Extracting driver $($SP.id).exe to $TempDir\$($SP.id)" -Type 1 -LogFile $log_file
				#Write-Log INFO "Extracting driver $($SP.id).exe to $TempDir\$($SP.id)"
				#Start-Process $SaveAs -ArgumentList "-s -e -f `"$TempDir\$($SP.id)`"" -Wait 2>> $log_file
				#Copy-Item "$($TempDir)\$($SP.id)" -Destination $DownloadDriverPackExtractFullPath\$($SP.id) -Force -Recurse
				#Export-Clixml -InputObject $SP -Path "$($DownloadDriverPackExtractFullPath)\$($SP.id)\DriverInfo.XML"
			}
		}
	}

	# Import updated drivers into deployment share
	if (!(Test-Path $MDTTargetFolder)) { New-Item $MDTTargetFolder -ItemType Directory -Force > $null }
	#CMTraceLog -Message "Importing driver package into MDT $MDTTargetFolder" -Type 1 -LogFile $log_file
	Write-Output "Importing driver package into MDT $MDTTargetFolder"

	Write-Log INFO "Importing driver package into MDT $MDTTargetFolder"
	Import-MDTDriver -Path "$MDTTargetFolder" -SourcePath "$DownloadDriverPackExtractFullPath"

	# Remove all unneccessary directories to save space
	#Write-Output "Deleting $TempDir and $DownloadDriverPackExtractFullPath"
	#CMTraceLog -Message "Deleting $TempDir and $DownloadDriverPackExtractFullPath" -Type 1 -LogFile $log_file
	#Write-Log INFO "Deleting $TempDir and $DownloadDriverPackExtractFullPath"

	#if (Test-Path $TempDir) { Remove-Item -Path $TempDir -Recurse -Force -ErrorAction SilentlyContinue }
	#if (Test-Path $DownloadDriverPackRootArchiveFullPath) { Remove-Item -Path $DownloadDriverPackRootArchiveFullPath -Recurse -Force -ErrorAction SilentlyContinue }
	# if (Test-Path $DownloadDriverPackExtractFullPath) { Remove-Item -Path $DownloadDriverPackExtractFullPath -Recurse -Force -ErrorAction SilentlyContinue }

}

#remove psdrive and exit script
if (Get-PSDrive -LiteralName PSDeploymentshare -ErrorAction 'silentlycontinue') { Remove-PSDrive -Name "PSDeploymentShare" }

#CMTraceLog -Message "Finished Script: $scriptName" -Type 1 -LogFile $log_file
Write-Log INFO "Finished Script: $scriptName"

Write-Output "Finished Script: $scriptName"

Pause