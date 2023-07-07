REM ############################################################################################################
REM Script		    :		MDT Imaging - AdjustDefaultUserProfile
REM Author		    :		Marco Fuchs (https://github.com/FuxMak)
REM Description  	:		Deploys a collection of Windows 10 registry keys to the HKCU hive of the default user:
REM 						- Clean up start menu items
REM							- Clean up taskbar
REM							- Privacy and notification settings
REM							- Set default theme: dark mode, company color scheme (dark teal)
REM 
REM ############################################################################################################
REM Development/Release Notes:
REM  - Continous development due to new OS releases and compliance requirements
REM ############################################################################################################


REM Load default registry hive - C:\Users\Default\NTUSER.DAT
reg load HKLM\DEFAULT c:\users\default\ntuser.dat


REM -------------------------------------------------------------------------------------------------------------
REM -------------------------------------------- Customization --------------------------------------------------

REM Adjust color scheme
ECHO "Adjusting color scheme..."

REG ADD "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Themes" /v "ThemeChangesDesktopIcons" /d 0 /t REG_DWORD /f
REG ADD "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Themes" /v "ThemeChangesMousePointers" /d 0 /t REG_DWORD /f
REG ADD "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Themes" /v "WallpaperSetFromTheme" /d 0 /t REG_DWORD /f
REG ADD "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Themes" /v "ColorSetFromTheme" /d 1 /t REG_DWORD /f

REG ADD "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /d 0 /t REG_DWORD /f
REG ADD "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "ColorPrevalence" /d 0 /t REG_DWORD /f
REG ADD "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /d 0 /t REG_DWORD /f
REG ADD "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" /d 0 /t REG_DWORD /f

REG ADD "HKLM\DEFAULT\Software\Microsoft\Windows\DWM" /v "AccentColor" /d 4287070979 /t REG_DWORD /f
REG ADD "HKLM\DEFAULT\Software\Microsoft\Windows\DWM" /v "AlwaysHibernateThumbnails" /d 0 /t REG_DWORD /f
REG ADD "HKLM\DEFAULT\Software\Microsoft\Windows\DWM" /v "ColorizationAfterglow" /d 3288564615 /t REG_DWORD /f
REG ADD "HKLM\DEFAULT\Software\Microsoft\Windows\DWM" /v "ColorizationAfterglowBalance" /d a /t REG_DWORD /f
REG ADD "HKLM\DEFAULT\Software\Microsoft\Windows\DWM" /v "ColorizationBlurBalance" /d 1 /t REG_DWORD /f
REG ADD "HKLM\DEFAULT\Software\Microsoft\Windows\DWM" /v "ColorizationColor" /d 3288564615 /t REG_DWORD /f
REG ADD "HKLM\DEFAULT\Software\Microsoft\Windows\DWM" /v "ColorizationColorBalance" /d 59 /t REG_DWORD /f
REG ADD "HKLM\DEFAULT\Software\Microsoft\Windows\DWM" /v "ColorizationGlassAttribute" /d 1 /t REG_DWORD /f
REG ADD "HKLM\DEFAULT\Software\Microsoft\Windows\DWM" /v "ColorPrevalence" /d 0 /t REG_DWORD /f
REG ADD "HKLM\DEFAULT\Software\Microsoft\Windows\DWM" /v "Composition" /d 1 /t REG_DWORD /f
REG ADD "HKLM\DEFAULT\Software\Microsoft\Windows\DWM" /v "EnableAeroPeek" /d 1 /t REG_DWORD /f
REG ADD "HKLM\DEFAULT\Software\Microsoft\Windows\DWM" /v "EnableWindowColorization" /d 0 /t REG_DWORD /f


REG ADD "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v "AccentColorMenu" /d 4287070979 /t REG_DWORD /f
REG ADD "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v "AccentPalette" /d b3f4f50080d6d90037a9ad00038387000056590000393b0000262600ef695000 /t REG_BINARY /f

REM Adjust colors for CMD
reg add "HKLM\DEFAULT\Software\Microsoft\Command Processor" /v "DefaultColor" /t REG_DWORD /d "02" /f


REM -------------------------------------------------------------------------------------------------------------
REM -------------------------------------------- UI SETTINGS ----------------------------------------------------

REM Enable Darkmode
ECHO "Enabling Darkmode..."
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" /t REG_DWORD /d 0 /f


REM Turn of Tablet Mode
ECHO "Disabling Tablet Mode..."
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" /v "ConvertibleSlateModePromptPreference" /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon" /v "MinimizedStateTabletModeOff" /t REG_DWORD /d 0 /f


REM Disable Transparency
ECHO "Disabling UI transparency..."
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 0 /f

REM ------ Start Menu ------


REM Remove Recent items in start menu
ECHO "Disabling Recent items in start menu.."
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsMenu" /t REG_DWORD /d 1 /f


REM Disable most used apps from appearing in the start menu
ECHO "Disabling most used apps (start menu)..."
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_TrackProgs /t REG_DWORD /d 0 /f

REM Allow user to shut down the PC
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoClose /t REG_DWORD /d 0 /f


REM ------ Desktop Icons / Buttons ------

REM Disable Action Center
ECHO "Disabling Action Center..."
reg add "HKLM\DEFAULT\Software\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d 1 /f
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d 0 /f


REM Disable Sticky keys prompt
ECHO "Disabling Sticky keys prompt..."
reg add "HKLM\DEFAULT\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_SZ /d "506" /f


REM Hide Search button / box
ECHO "Disable search bar..."
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d 0 /f


REM Hide Task View button
ECHO "Hiding Task View button..."
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /d 0 /f


REM Add dropshadow on desktop shortcuts for more clarity on bright backgrounds
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewShadow" /t REG_DWORD /d 1 /f

REM Hide Ink Workspace button
ECHO "Hiding Windows Ink Workspace button..."
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\PenWorkspace" /v "PenWorkspaceButtonDesiredVisibility" /t REG_DWORD /d 0 /f


REM Hide tray icons as needed
reg delete "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" /f


REM Hide Bluetooth Tray icon
ECHO "Hiding Bluetooth Tray icon..."
reg add "HKLM\DEFAULT\Control Panel\Bluetooth" /v "Notification Area Icon" /t REG_DWORD /d 0 /f


REM Hide People\Feeds button from Taskbar
ECHO "Disabling People\Feeds button from Taskbar..."
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" /v PeopleBand /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" /v "IsFeedsAvailable" /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" /v "ShellFeedsTaskbarViewmode" /t REG_DWORD /d 2 /f

REM Hide MeetNow button from Taskbar
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d 1 /f


REM Hide Cortana Button on Taskbar
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCortanaButton" /t REG_DWORD /d 0 /f

REM -------------------------------------------------------------------------------------------------------------
REM -------------------------------------------- EXPLORER SETTINGS -----------------------------------------------

REM Remove "Quick Access"
Write-Host "Removing Quick Access from Explorer..."
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "HubMode" /t REG_DWORD /d 1 /f


REM Change default Explorer view to "Computer"
ECHO "Changing default Explorer view to Computer..."
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d 1 /f


REM Changing default Ribbon view to Extended
ECHO "Changing default Ribbon view to Extended ..."
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ExplorerRibbonStartsMinimized" /t REG_DWORD /d "4" /f
reg add "HKLM\DEFAULT\Software\Policies\Microsoft\Windows\Explorer" /v "ExplorerRibbonStartsMinimized" /t REG_DWORD /d "4" /f


REM Show file extensions
ECHO "Showing known file extensions..."
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 0 /f


REM Show hidden files
ECHO "Showing hidden files..."
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 1 /f


REM Disable Autorun for all drives
ECHO "Disabling Autorun for all drives..."
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveTypeAutoRun" /t REG_DWORD /d 255 /f

ECHO "Disabling Autoplay..."
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /v "DisableAutoplay" /t REG_DWORD /d 1 /f


REM -------------------------------------------------------------------------------------------------------------
REM -------------------------------------------- NOTIFICATION SETTINGS ------------------------------------------

REM Disable Notifications
ECHO "Disable Notifications..."
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "Enabled" /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance" /v "Enabled" /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.BackgroundAccess" /v "Enabled" /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.BdeUnlock" /v "Enabled" /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.Suggested" /v "Enabled" /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.AutoPlay" /v "Enabled" /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.System.Continuum" /v "Enabled" /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Microsoft.SkyDrive.Desktop" /v "Enabled" /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\microsoft.windowscommunicationsapps_8wekyb3d8bbwe!microsoft.windowslive.calendar" /v "Enabled" /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel" /v "Enabled" /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Microsoft.Windows.Cortana_cw5n1h2txyewy!CortanaUI" /v "Enabled" /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Microsoft.MicrosoftEdge_8wekyb3d8bbwe!MicrosoftEdge" /v "Enabled" /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Microsoft.BingNews_8wekyb3d8bbwe!AppexNews" /v "Enabled" /t REG_DWORD /d 0 /f

REM (Notifications - Windows Welcome Experience)
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d 0 /f

REM (Notifications - Suggest ways I can finish setting up my device)
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d 0 /f

REM (Notifications - Get tips, tricks, and suggestions)
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d 0 /f


REM -------------------------------------------------------------------------------------------------------------
REM -------------------------------------------- PRIVACY SETTINGS -----------------------------------------------

REM Privacy Settings (Control Panel)

REM Suspected to interfere with MediaFoundation drivers
REM reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone" /v "Value" /t REG_SZ /d "Deny" /f

ECHO "Adjusting Privacy Settings (Control Panel)..."
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Search" /v "BackgroundAppGlobalToggle" /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /t REG_SZ /d "Deny" /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" /v "Value" /t REG_SZ /d "Deny" /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\activity" /v "Value" /t REG_SZ /d "Deny" /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" /v "Value" /t REG_SZ /d "Deny" /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" /v "Value" /t REG_SZ /d "Deny" /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" /v "Value" /t REG_SZ /d "Deny" /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" /v "Value" /t REG_SZ /d "Deny" /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" /v "Value" /t REG_SZ /d "Deny" /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" /v "Value" /t REG_SZ /d "Deny" /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" /v "Value" /t REG_SZ /d "Deny" /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" /v "Value" /t REG_SZ /d "Deny" /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" /v "Value" /t REG_SZ /d "Deny" /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" /v "Value" /t REG_SZ /d "Deny" /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" /v "Value" /t REG_SZ /d "Deny" /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" /v "Value" /t REG_SZ /d "Deny" /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" /v "Value" /t REG_SZ /d "Deny" /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" /v "Value" /t REG_SZ /d "Deny" /f

REM Settings - Privacy - General - Let Websites provide locally relevant content
reg add "HKLM\DEFAULT\Control Panel\International\User Profile" /v HttpAcceptLanguageOptOut /t REG_DWORD /d 1 /f


REM Settings - Privacy - General - Show me suggested content in the settings app
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338393Enabled /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-353694Enabled /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-353696Enabled /t REG_DWORD /d 0 /f

REM Additional ContentDeliveryManager settings to prevent bloat Apps from being installed automatically
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "ContentDeliveryAllowed" /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "FeatureManagementEnabled" /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "OemPreInstalledAppsEnabled" /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEnabled" /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEverEnabled" /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-314559Enabled" /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338387Enabled" /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338388Enabled" /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContentEnabled" /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d 0 /f


REM Settings - Privacy - Inking and Typing - Getting to know you
reg add "HKLM\DEFAULT\Software\Microsoft\InputPersonalization" /v RestrictImplicitInkCollection /t REG_DWORD /d 1 /f
reg add "HKLM\DEFAULT\Software\Microsoft\InputPersonalization" /v RestrictImplicitTextCollection /t REG_DWORD /d 1 /f
reg add "HKLM\DEFAULT\Software\Microsoft\InputPersonalization\TrainedDataStore" /v HarvestContacts /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\Software\Microsoft\Personalization\Settings" /v AcceptedPrivacyPolicy /t REG_DWORD /d 0 /f


REM Settings - Privacy - BackgroundApps
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\Search" /v BackgroundAppGlobalToggle /t REG_DWORD /d 0 /f


REM Settings - WindowsUpdate - DeliveryOptimization
reg add "HKEY_USERS\S-1-5-20\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings" /v DownloadMode /t REG_DWORD /d 0 /f


REM Settings - Search Disable Cloud based search
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /v IsMSACloudSearchEnabled /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /v IsAADCloudSearchEnabled /t REG_DWORD /d 0 /f


REM Settings - Gaming - Disable Game DVR
ECHO "Disabling Game DVR..."
reg add "HKLM\DEFAULT\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f

REM Settings - Gaming - Disable Game Mode
reg add "HKLM\DEFAULT\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 0 /f
reg add "HKLM\DEFAULT\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 0 /f


REM Remove Advertising ID
ECHO "Disabling Advertising ID..."
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f


REM Disable Delivery optimization
ECHO "Disabling Delivery optimization..."
reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v SystemSettingsDownloadMode /t REG_DWORD /d 3 /f


REM Disable Feedback
ECHO "Disabling Feedback..."
reg add "HKLM\DEFAULT\Software\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d 0 /f

 
REM Hide Edge button in IE
reg add "HKLM\DEFAULT\SOFTWARE\Microsoft\Internet Explorer\Main" /v "HideNewEdgeButton" /t REG_DWORD /d 1 /f
 
 
REM Remove OneDrive Setup from the RUN key
reg delete "HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup" /f


REM Enable Baretail in default app associations
reg add "HKCR\Applications\baretail.exe\shell\open\command" /d "\"D:\_TOOLS\BareTail\baretail.exe\" \"%1\"" /f

reg unload HKLM\DEFAULT


EXIT 0