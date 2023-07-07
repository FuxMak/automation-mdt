REM ############################################################################################################
REM Script		    :		MDT Imaging - AdjustCurrentUserWin11
REM Author		    :		Marco Fuchs (https://github.com/FuxMak)
REM Description  	:		Deploys a collection of Windows 11 registry keys to the HKCU hive:
REM 						- Clean up start menu items
REM							- Clean up taskbar
REM							- Privacy and notification settings
REM							- Set default theme: dark mode, company color scheme (dark teal)
REM 
REM ############################################################################################################
REM Development/Release Notes:
REM  - Continous development due to new OS releases and compliance requirements
REM ############################################################################################################


REM APPLY SAME SETTINGS TO ADMINISTRATOR ACCOUNT

REM -------------------------------------------------------------------------------------------------------------
REM -------------------------------------------- Cleanup --------------------------------------------------

REM Remove OneDrive Setup from the RUN key
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup" /f

REM -------------------------------------------------------------------------------------------------------------
REM -------------------------------------------- Customization --------------------------------------------------

REM Adjust color scheme
ECHO "Adjusting color scheme..."

REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes" /v "ThemeChangesDesktopIcons" /d 0 /t REG_DWORD /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes" /v "ThemeChangesMousePointers" /d 0 /t REG_DWORD /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes" /v "WallpaperSetFromTheme" /d 0 /t REG_DWORD /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes" /v "ColorSetFromTheme" /d 1 /t REG_DWORD /f

REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "ColorPrevalence" /d 0 /t REG_DWORD /f

REG ADD "HKCU\Software\Microsoft\Windows\DWM" /v "AccentColor" /d 4287070979 /t REG_DWORD /f
REG ADD "HKCU\Software\Microsoft\Windows\DWM" /v "AlwaysHibernateThumbnails" /d 0 /t REG_DWORD /f
REG ADD "HKCU\Software\Microsoft\Windows\DWM" /v "ColorizationAfterglow" /d 3288564615 /t REG_DWORD /f
REG ADD "HKCU\Software\Microsoft\Windows\DWM" /v "ColorizationAfterglowBalance" /d a /t REG_DWORD /f
REG ADD "HKCU\Software\Microsoft\Windows\DWM" /v "ColorizationBlurBalance" /d 1 /t REG_DWORD /f
REG ADD "HKCU\Software\Microsoft\Windows\DWM" /v "ColorizationColor" /d 3288564615 /t REG_DWORD /f
REG ADD "HKCU\Software\Microsoft\Windows\DWM" /v "ColorizationColorBalance" /d 59 /t REG_DWORD /f
REG ADD "HKCU\Software\Microsoft\Windows\DWM" /v "ColorizationGlassAttribute" /d 1 /t REG_DWORD /f
REG ADD "HKCU\Software\Microsoft\Windows\DWM" /v "ColorPrevalence" /d 0 /t REG_DWORD /f
REG ADD "HKCU\Software\Microsoft\Windows\DWM" /v "Composition" /d 1 /t REG_DWORD /f
REG ADD "HKCU\Software\Microsoft\Windows\DWM" /v "EnableAeroPeek" /d 1 /t REG_DWORD /f
REG ADD "HKCU\Software\Microsoft\Windows\DWM" /v "EnableWindowColorization" /d 0 /t REG_DWORD /f


REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v "AccentColorMenu" /d 4287070979 /t REG_DWORD /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v "AccentPalette" /d b3f4f50080d6d90037a9ad00038387000056590000393b0000262600ef695000 /t REG_BINARY /f

REM Adjust colors for CMD
REM reg add "HKCU\Software\Microsoft\Command Processor" /v "DefaultColor" /t REG_DWORD /d "02" /f

taskkill /F /IM explorer.exe & start explorer


REM -------------------------------------------------------------------------------------------------------------
REM -------------------------------------------- UI SETTINGS ----------------------------------------------------

REM Enable Darkmode
ECHO "Enabling Darkmode..."
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" /t REG_DWORD /d 0 /f


REM Disable Transparency
ECHO "Disabling UI transparency..."
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 0 /f


REM ------ Start Menu ------


REM Remove Recent items in start menu
ECHO "Disabling Recent items in start menu.."
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsMenu" /t REG_DWORD /d 1 /f


REM Disable most used apps from appearing in the start menu
ECHO "Disabling most used apps (start menu)..."
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_TrackProgs /t REG_DWORD /d 0 /f


REM Disable recommended items in Win11
ECHO "Disabling recommended items in the start menu..."
reg add "HKLM\Software\Policies\Microsoft\Windows\Explorer" /v HideRecommendedSection /t REG_DWORD /d 1 /f



REM ------ Desktop Icons / Buttons ------

REM Hide tray icons as needed (NOT TESTED)
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "EnableAutoTray" /f


REM Hide Bluetooth Tray icon
REM ECHO "Hiding Bluetooth Tray icon..."
REM reg add "HKCU\Control Panel\Bluetooth" /v "Notification Area Icon" /t REG_DWORD /d 0 /f


REM -------------------------------------------------------------------------------------------------------------
REM -------------------------------------------- EXPLORER SETTINGS -----------------------------------------------

REM Change default Explorer view to "Computer"
ECHO "Changing default Explorer view to Computer..."
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d 1 /f

REM Remove "Quick Access"
ECHO "Removing Quick Access from Explorer..."
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "HubMode" /t REG_DWORD /d 1 /f

REM Show file extensions
ECHO "Showing known file extensions..."
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 0 /f


REM Show hidden files
ECHO "Showing hidden files..."
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 1 /f


REM Disable Autorun for all drives
ECHO "Disabling Autorun for all drives..."
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveTypeAutoRun" /t REG_DWORD /d 255 /f

ECHO "Disabling Autoplay..."
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /v "DisableAutoplay" /t REG_DWORD /d 1 /f


REM -------------------------------------------------------------------------------------------------------------
REM -------------------------------------------- Control - Notification Settings ------------------------------------------

REM Notifications
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d 0 /f


REM Offer suggestions on how I can set up my device
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d 0 /f

REM Get tips and suggestions when I use Windows
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d 0 /f


REM -------------------------------------------------------------------------------------------------------------
REM -------------------------------------------- Control - Gaming ------------------------------------------

REM Open Xbox Game Bar using this button on a controller
reg add "HKCU\Software\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t REG_DWORD /d 0 /f

REM Game Mode
reg add "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d 0 /f


REM -------------------------------------------------------------------------------------------------------------
REM -------------------------------------------- Control - Privacy & Security ------------------------------------------

REM General - Let apps show me personalised ads by using my advertising ID
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 0 /f

REM General - Show me suggested content in the Settings app
reg add "HKCU\Control Panel\International\User Profile" /v "HttpAcceptLanguageOptOut" /t REG_DWORD /d 1 /f

REM General - Show me suggested content in the Settings app
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353696Enabled" /t REG_DWORD /d 1 /f

REM General - Let Windows improve Start and search results by tracking app launches
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackProgs" /t REG_DWORD /d 0 /f

REM Inking & Typing - Personal inking and typing dictionary
reg add "HKCU\Software\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d 1 /f

REM Diagnostics & Feedback
reg add "HKCU\Software\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d 0 /f

REM Search permissions - Cloud content search
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsMSACloudSearchEnabled" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsAADCloudSearchEnabled" /t REG_DWORD /d 0 /f

REM Search permissions - History
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsDeviceSearchHistoryEnabled" /t REG_DWORD /d 0 /f


REM -------------------------------------------------------------------------------------------------------------
REM -------------------------------------------- Control - Personalization ------------------------------------------

REM Taskbar
REM Remove Taskview, Search, Widgets & Chat
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarDa" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarMn" /t REG_DWORD /d 0 /f

REM Taskbar - Taskbar alignment (left)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAl" /t REG_DWORD /d 0 /f


REM Lock screen - Get fun facts, tips and tricks on your lock screen
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338387Enabled" /t REG_DWORD /d 0 /f


REM Start - Show recently opened items in Start, Jump Lists and File Explorer
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t REG_DWORD /d 0 /f


REM -------------------------------------------------------------------------------------------------------------
REM -------------------------------------------- Start menu ------------------------------------------

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v "MakeAllAppsDefault" /t REG_DWORD /d 1 /f

EXIT 0

