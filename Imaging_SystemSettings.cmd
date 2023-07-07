REM ############################################################################################################
REM Script		    :		MDT Imaging - AdjustSystemSettings
REM Author		    :		Marco Fuchs (https://github.com/FuxMak)
REM Description  	:		Deploys a collection of Windows 11 registry keys to the HKLM:
REM 						- Clean up start menu items
REM 						- Clean up explorer
REM							- Clean up taskbar
REM							- Privacy and notification settings
REM 
REM ############################################################################################################
REM Development/Release Notes:
REM  - Continous development due to new OS releases and compliance requirements
REM ############################################################################################################

@ECHO OFF

REM -------------------------------------------------------------------------------------------------------------
REM -------------------------------------------- UI SETTINGS ----------------------------------------------------

REM Disable First logon Animation
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableFirstLogonAnimation" /t REG_DWORD /d 0 /f

REM Enable Dark Mode
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d 0 /f


REM ------ Start Menu ------

REM Cleanup Start menu list (Only Explorer, Settings)
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_TrackProgs /t REG_DWORD /d 0 /f

reg add "HKLM\Software\Microsoft\PolicyManager\current\device\Start" /v "AllowPinnedFolderDocuments" /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\Start" /v "AllowPinnedFolderDocuments_ProviderSet" /t REG_DWORD /d 1 /f

reg add "HKLM\Software\Microsoft\PolicyManager\current\device\Start" /v "AllowPinnedFolderDownloads" /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\Start" /v "AllowPinnedFolderDownloads_ProviderSet" /t REG_DWORD /d 1 /f

reg add "HKLM\Software\Microsoft\PolicyManager\current\device\Start" /v "AllowPinnedFolderFileExplorer" /t REG_DWORD /d 1 /f
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\Start" /v "AllowPinnedFolderFileExplorer_ProviderSet" /t REG_DWORD /d 1 /f

reg add "HKLM\Software\Microsoft\PolicyManager\current\device\Start" /v "AllowPinnedFolderPersonalFolder" /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\Start" /v "AllowPinnedFolderPersonalFolder_ProviderSet" /t REG_DWORD /d 1 /f

reg add "HKLM\Software\Microsoft\PolicyManager\current\device\Start" /v "AllowPinnedFolderPictures" /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\Start" /v "AllowPinnedFolderPictures_ProviderSet" /t REG_DWORD /d 1 /f

reg add "HKLM\Software\Microsoft\PolicyManager\current\device\Start" /v "AllowPinnedFolderSettings" /t REG_DWORD /d 1 /f
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\Start" /v "AllowPinnedFolderSettings_ProviderSet" /t REG_DWORD /d 1 /f

reg add "HKLM\Software\Microsoft\PolicyManager\current\device\Start" /v "AllowPinnedFolderNetwork" /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\Start" /v "AllowPinnedFolderNetwork_ProviderSet" /t REG_DWORD /d 1 /f


REM Hide recently added Apps in start menu
reg add "HKLM\Software\Policies\Microsoft\Windows\Explorer" /v "HideRecentlyAddedApps" /t REG_DWORD /d 1 /f


REM Remove "PC Health Check" from installing
reg add "HKLM\SOFTWARE\Microsoft\PCHC" /v "PreviousUninstall" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\PCHealthCheck" /v "installed" /t REG_DWORD /d 1 /f



REM ------ Desktop Icons / Buttons ------

REM Disable Action Center
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\ImmersiveShell" /v "UseActionCenterExperience" /t REG_DWORD /d 0 /f

REM Disable Edge Shortcuts on Desktop (not working with Chromium)
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "DisableEdgeDesktopShortcutCreation" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\SOFTWARE\Policies\Microsoft\EdgeUpdate" /v "CreateDesktopShortcutDefault" /t REG_DWORD /d "0" /f

REM Disable Network popup
reg add HKLM\System\CurrentControlSet\Control\Network\NewNetworkWindowOff /f

REM Taskbar - Disable MeetNow Button
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d 1 /f

REM Taskbar - Disable News Feed
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v "EnableFeeds" /t REG_DWORD /d 0 /f


REM ------ Windows Explorer ------

REM Remove Music icon from computer namespace
ECHO "Removing Music icon from computer namespace..."
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" /f
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" /f

REM Remove Videos icon from computer namespace
ECHO "Removing Videos icon from computer namespace..."
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" /f
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" /f

REM Remove Pictures icon from computer namespace
ECHO "Removing Pictures icon from computer namespace..."
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" /f
reg delete "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" /f

REM Remove 3D Objects icon from computer namespace
ECHO "Removing 3D Objects icon from computer namespace..."
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f


REM ------ Logon Screen ------

REM Remove FastUser Switching
ECHO "Hide FastUser Switching..."
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "HideFastUserSwitching" /t REG_DWORD /d 1 /f

REM Add Power Button to Lockscreen
ECHO Add Power Button to Lockscreen
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "shutdownwithoutlogon" /t REG_DWORD /d 1 /f



REM -------------------------------------------------------------------------------------------------------------
REM ----------------------------------------- SECURITY SETTINGS -------------------------------------------------

REM ------ System Settings ------

REM Remove Settings Banner

reg add "HKLM\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\4\4095660171" /V EnabledState /T REG_DWORD /F /D 1
reg add "HKLM\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\4\4095660171" /V EnabledStateOptions /T REG_DWORD /F /D 1

reg add "HKLM\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\4\2674077835" /V EnabledState /T REG_DWORD /F /D 1
reg add "HKLM\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\4\2674077835" /V EnabledStateOptions /T REG_DWORD /F /D 1

REM Settings - Apps - Maps
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Maps" /v "AutoDownloadAndUpdateMapData" /t REG_DWORD /d 0 /f

REM Settings - Apps - Autostart - WinDefender Security Icon
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Systray" /v "HideSystray" /t REG_DWORD /d 1 /f

REM Settings - Privacy - Activity History - Store my activity history on this device
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d 0 /f

REM WindowsSecurity - Notifications - Disable all notifications
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\UX Configuration" /v "Notification_Suppress" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" /v "DisableNotifications" /t REG_DWORD /d 1 /f


REM ------ Windows Update ------

REM Disable Windows AutoUpdate
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "AutoDownload" /t REG_DWORD /d 2 /f
reg add "HKLM\Software\Microsoft\WindowsUpdate\AU" /v "NoAutoUpdate " /t REG_DWORD /d 1 /f
reg add "HKLM\Software\Microsoft\WindowsUpdate\UX\Settings" /v "UxOption" /t REG_DWORD /d 1 /f


REM - OPTIONAL -
REM Disable Windows Update completely
ECHO "Stopping and disabling Windows Update..."
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v "DODownloadMode" /t REG_DWORD /d 1 /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d "1" /f

sc config "wuauserv" start= disabled
sc stop "wuauserv"

sc config "BITS" start= disabled
sc stop "BITS"


REM ------ Telemtry / Diagnostics ------

REM Disable Telemetry (System wide)
ECHO "Disabling Telemetry..."
reg add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f


REM Stop and disable Diagnostics Tracking Service
ECHO "Stopping and disabling Diagnostics Tracking Service..."
sc config "DiagTrack" start= disabled
sc stop "DiagTrack"


REM Disable Cloud Content \ Microsoft Consumer Experience
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 1 /f


REM Disable Microsoft Edge Auto updates
sc config "edgeupdate" start=disabled
sc config "edgeupdatem" start=disabled
sc config "MicrosoftEdgeElevationService" start=disabled


REM Disable "Apps run in background"
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy " /v "LetAppsRunInBackground" /t REG_DWORD /d 2 /f


REM Disable Wi-Fi Sense
ECHO "Disabling Wi-Fi Sense..."
reg add "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" /v "Value" /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" /v "Value" /t REG_DWORD /d 0 /f


REM Disable SmartScreen Filter
ECHO "Disabling SmartScreen Filter..."
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\WindowsBackup" /v "DisableMonitoring" /t REG_DWORD /d 1 /f


REM Disable Windows Defender
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f


REM ------ System Administration ------

REM Disable LUA
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d 0 /f

REM Lower UAC level
ECHO "Lowering UAC level..."
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "PromptOnSecureDesktop" /t REG_DWORD /d 0 /f

REM Disable Firewall
ECHO "Disabling Firewall..."
Powershell Set-NetFirewallProfile -Profile * -Enabled False
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" /v "EnableFirewall" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\StandardProfile" /v "EnableFirewall" /t REG_DWORD /d 0 /f


REM Disable IPv6
ECHO "Disabling IPv6..."
reg add "HKLM\SYSTEM\CurrentControlSet\services\TCPIP6\Parameters" /v "DisabledComponents" /t REG_DWORD /d "4294967295" /f

REM Disable Windows Defender
ECHO "Disabling Windows Defender..."
reg add "HKLM\Software\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f

REM Disable Remote Assistance
ECHO "Disabling Remote Assistance..."
reg add "HKLM\System\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /t REG_DWORD /d 0 /f

REM Enable Remote Desktop with Network Level Authentication
ECHO "Enabling Remote Desktop..."
reg add "HKLM\System\CurrentControlSet\Control\Terminal Server" /v "fDenyTSConnections" /t REG_DWORD /d 0 /f

REM Enable Remote Desktop w/o Network Level Authentication
REM ECHO "Enabling Remote Desktop w/o Network Level Authentication..."
REM reg add "HKLM\System\CurrentControlSet\Control\Terminal Server" /v "fDenyTSConnections" /t REG_DWORD /d 0 /f
REM reg add "HKLM\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v "UserAuthentication" /t REG_DWORD /d 0 /f


REM -------------------------------------------------------------------------------------------------------------
REM ----------------------------------------- CUSTOM / MB-Specific ----------------------------------------------

REM Specify which Accounts should be hidden on Login screen
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v "Ansible" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v "MBUpdate" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v "MBBackup" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v "MBMonitoring" /t REG_DWORD /d 0 /f