# -------------------------------------------------------------------------------------------------------------
# -------------------------------------------- Windows Apps ---------------------------------------------------


Function Set-FilePermissions {
    param (
     [parameter(Mandatory=$true)]
     [ValidateNotNullOrEmpty()]$File,
     [parameter(Mandatory=$true)]
     [ValidateNotNullOrEmpty()]$GroupSID,
     [parameter(Mandatory=$true)]
     [ValidateNotNullOrEmpty()]$Control,
     [parameter(Mandatory=$true)]
     [ValidateNotNullOrEmpty()]$Access
    )
  
    $ACL = Get-ACL "$File"
	$UserGroup = Get-LocalGroup -SID $GroupSID
    $Permission = New-Object system.security.accesscontrol.filesystemaccessrule("$UserGroup","$Control","$Access")
    $Acl.SetAccessRule($Permission)
    Set-Acl -Path "$File" -AclObject $ACL
}
  
Function Set-FileOwnership {
    param (
     [parameter(Mandatory=$true)]
     [ValidateNotNullOrEmpty()]$File,
     [parameter(Mandatory=$true)]
     [ValidateNotNullOrEmpty()]$GroupSID
    )
  
    $ACL = Get-ACL "$File"
	$UserGroup = Get-LocalGroup -SID $GroupSID
    $Group = New-Object System.Security.Principal.NTAccount("$UserGroup")
    $ACL.SetOwner($Group)
    Set-Acl -Path "$File" -AclObject $ACL
  
}

# Removable packages
Write-Output "Uninstalling default apps"
$apps = @(
    # Default Windows 10 apps
    "Microsoft.3DBuilder"
    "Microsoft.Advertising.Xaml"
    "Microsoft.Appconnector"
    "Microsoft.BingFinance"
    "Microsoft.BingNews"
    "Microsoft.BingSports"
    "Microsoft.BingTranslator"
    "Microsoft.BingWeather"
    "Microsoft.FreshPaint"
    "Microsoft.GamingServices"
    "Microsoft.Microsoft3DViewer"
    "Microsoft.WindowsFeedbackHub"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.MixedReality.Portal"
    "Microsoft.MicrosoftPowerBIForWindows"
    "Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.MicrosoftStickyNotes"
    "Microsoft.MinecraftUWP"
    "Microsoft.NetworkSpeedTest"
    "Microsoft.Office.OneNote"
	"Microsoft.549981C3F5F10" #Cortana
    "Microsoft.People"
    "Microsoft.Print3D"
    "Microsoft.SkypeApp"
    "Microsoft.Wallet"
    "Microsoft.Windows.Photos" # Enable if needed
    "Microsoft.WindowsCalculator"
	"Microsoft.WindowsAlarms"
    #"Microsoft.WindowsCamera"
    "Microsoft.windowscommunicationsapps"
    "Microsoft.WindowsMaps"
    "Microsoft.WindowsPhone"
    "Microsoft.WindowsSoundRecorder"
    "Microsoft.WindowsStore"   # can't be re-installed
    "Microsoft.Xbox.TCUI"
    "Microsoft.XboxApp"
    "Microsoft.XboxGameOverlay"
    "Microsoft.XboxGamingOverlay"
    "Microsoft.XboxSpeechToTextOverlay"
    "Microsoft.YourPhone"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"
    "Microsoft.Windows.CloudExperienceHost"
    "Microsoft.Windows.ContentDeliveryManager"
    "Microsoft.Windows.PeopleExperienceHost"
    "Microsoft.XboxGameCallableUI"

    # Threshold 2 apps
    "Microsoft.CommsPhone"
    "Microsoft.ConnectivityStore"
    "Microsoft.GetHelp"
    "Microsoft.Getstarted"
    "Microsoft.Messaging"
    "Microsoft.Office.Sway"
    "Microsoft.OneConnect"
    "Microsoft.WindowsFeedbackHub"

    # Creators Update apps
    "Microsoft.Microsoft3DViewer"
    "Microsoft.MSPaint"

    #Redstone apps
    "Microsoft.BingFoodAndDrink"
    "Microsoft.BingHealthAndFitness"
    "Microsoft.BingTravel"
    "Microsoft.WindowsReadingList"

    # Redstone 5 apps
    "Microsoft.MixedReality.Portal"
    "Microsoft.ScreenSketch"
    "Microsoft.XboxGamingOverlay"
    "Microsoft.YourPhone"
	
	# Sun Valley
	"MicrosoftCorporationII.QuickAssist"
    "Microsoft.PowerAutomateDesktop"
    "Microsoft.SecHealthUI"
    "Microsoft.Todos"
    "MicrosoftTeams"
    "Clipchamp.Clipchamp"

    # non-Microsoft
    "2FE3CB00.PicsArt-PhotoStudio"
    "46928bounde.EclipseManager"
    "4DF9E0F8.Netflix"
    "613EBCEA.PolarrPhotoEditorAcademicEdition"
    "6Wunderkinder.Wunderlist"
    "7EE7776C.LinkedInforWindows"
    "89006A2E.AutodeskSketchBook"
    "9E2F88E3.Twitter"
    "A278AB0D.DisneyMagicKingdoms"
    "A278AB0D.MarchofEmpires"
    "ActiproSoftwareLLC.562882FEEB491"
    "CAF9E577.Plex"  
    "ClearChannelRadioDigital.iHeartRadio"
    "D52A8D61.FarmVille2CountryEscape"
    "D5EA27B7.Duolingo-LearnLanguagesforFree"
    "DB6EA5DB.CyberLinkMediaSuiteEssentials"
    "DolbyLaboratories.DolbyAccess"
    "DolbyLaboratories.DolbyAccess"
    "Drawboard.DrawboardPDF"
    "Facebook.Facebook"
    "Fitbit.FitbitCoach"
    "Flipboard.Flipboard"
    "GAMELOFTSA.Asphalt8Airborne"
    "KeeperSecurityInc.Keeper"
    "NORDCURRENT.COOKINGFEVER"
    "PandoraMediaInc.29680B314EFC2"
    "Playtika.CaesarsSlotsFreeCasino"
    "ShazamEntertainmentLtd.Shazam"
    "SlingTVLLC.SlingTV"
    "SpotifyAB.SpotifyMusic"
    "TheNewYorkTimes.NYTCrossword"
    "ThumbmunkeysLtd.PhototasticCollage"
    "TuneIn.TuneInRadio"
    "WinZipComputing.WinZipUniversal"
    "XINGAG.XING"
    "flaregamesGmbH.RoyalRevolt2"
    "king.com.*"
    "king.com.BubbleWitch3Saga"
    "king.com.CandyCrushSaga"
    "king.com.CandyCrushSodaSaga"
	
	# apps which cannot be removed using Remove-AppxPackage
    #"Microsoft.BioEnrollment"
    #"Microsoft.MicrosoftEdge"
    #"Microsoft.Windows.Cortana"
    #"Microsoft.WindowsFeedback"
    #"Microsoft.XboxGameCallableUI"
    #"Microsoft.XboxIdentityProvider"
    #"Windows.ContactSupport"
)


# Remove Apps from List
for ($i=0; $i -lt $apps.length; $i++){
	$tmpStatus = $apps[$i]
	
	$tmpPercent = (($i*100)/$apps.length)

	# Write Progress Bar to MDT (or Powershell if run standalone)
	Write-Progress -activity "Removing Windows Bloatware" -status "Removing $tmpStatus" -percentComplete $tmpPercent
	
	# Remove App Packages from Image
	Get-AppXProvisionedPackage -Online | Where-Object DisplayName -EQ $apps[$i] | Remove-AppxProvisionedPackage -Online
}

# -------------------------------------------------------------------------------------------------------------
# -------------------------------------------- OneDrive -------------------------------------------------------

# Uninstall / Remove OneDrive

if (Test-Path -Path C:\Windows\SysWOW64\OneDriveSetup.exe) {

	# 1. Uninstall
	Start-Process C:\Windows\SysWOW64\OneDriveSetup.exe /uninstall -Wait
	
	#2. Rename file to prevent AutoRun
	Set-FileOwnership -File C:\Windows\SysWOW64\OneDriveSetup.exe -GroupSID "S-1-5-32-544"
	Set-FilePermissions -File C:\Windows\SysWOW64\OneDriveSetup.exe -GroupSID "S-1-5-32-544" -Control FullControl -Access Allow
	Rename-Item C:\Windows\SysWOW64\OneDriveSetup.exe C:\Windows\SysWOW64\OneDriveSetup.exe.old

	# 3. Remove Link from StartMenu
	if (Test-Path -Path "C:\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\onedrive.lnk") {
		Remove-Item -Path "C:\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\onedrive.lnk" -Force
	}
}


# -------------------------------------------------------------------------------------------------------------
# -------------------------------------------- Microsoft Edge -------------------------------------------------