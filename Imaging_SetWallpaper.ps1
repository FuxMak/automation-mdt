#############################################################################################################
#  Script		    :		MDT Imaging - SetWallpaper
#  Author		    :		Marco Fuchs (https://github.com/FuxMak)
#  Description  	:		Changes wallpaper and lockscreen
#							Usable during MDT deployment and as a regular script
#############################################################################################################
#  Development/Release Notes:
#  - Initial draft, changes all default Windows 10/11 Wallpapers to the selected one
#  - Added functions for getting permissions to certain folders (requirement since Win10 21H2)
#  - Added routine to remove cached lockscreen images
#############################################################################################################

# -------------------------------------------------------------------------------------------------------------
# -------------------------------------------- Parameters -----------------------------------------------------

# --- Wallpaper / Lockscreen ---

$CustomWallpaper = "$PSScriptRoot\Wallpaper\Desktop_Standard_1920x1080.jpg" #Also used for LockScreen
$DefaultWallpaper = "C:\Windows\Web\Wallpaper\Windows\img0.jpg"

$LockscreenDir = "C:\Windows\Web\Screen"
$WallpaperDir = "C:\Windows\Web\4K\Wallpaper\Windows"

# Lockscreen cache directory
$SystemDataDir = "C:\ProgramData\Microsoft\Windows\SystemData"


# -------------------------------------------------------------------------------------------------------------
# -------------------------------------------- Functions ------------------------------------------------------

function Set-FolderPermission {
    param (
        [Parameter(Mandatory = $true)]
        [string] $FolderPath,

        [Parameter(Mandatory = $false)]
        [string] $UserName = 'Administrator'
    )

    try {
        # Get the user
        $UserAccount = New-Object System.Security.Principal.NTAccount($UserName)

        # Get the current ACL of the folder
        $Acl = Get-Acl -Path $FolderPath

        # Set the user as the owner
        $Acl.SetOwner($UserAccount)

        # Create a new access rule
        $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($UserName, 'FullControl', 'ContainerInherit,ObjectInherit', 'None', 'Allow')

        # Add the access rule to the ACL
        $Acl.AddAccessRule($AccessRule)

        # Apply the new ACL to the folder
        Set-Acl -Path $FolderPath -AclObject $Acl

        Write-Output "Ownership changed and full control granted to $UserName for $FolderPath"
    }
    catch {
        Write-Error "Failed to set permissions: $_"
    }
}

function Set-FilePermission {
    param (
        [Parameter(Mandatory = $true)]
        [string] $FilePath,

        [Parameter(Mandatory = $false)]
        [string] $UserName = 'Administrator'
    )

    try {
        # Get the user
        $UserAccount = New-Object System.Security.Principal.NTAccount($UserName)

        # Get the current ACL of the file
        $Acl = Get-Acl -Path $FilePath

        # Set the user as the owner
        $Acl.SetOwner($UserAccount)

        # Create a new access rule
        $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($UserName, 'FullControl', 'Allow')

        # Add the access rule to the ACL
        $Acl.AddAccessRule($AccessRule)

        # Apply the new ACL to the file
        Set-Acl -Path $FilePath -AclObject $Acl

        Write-Output "Ownership changed and full control granted to $UserName for $FilePath"
    }
    catch {
        Write-Error "Failed to set permissions: $_"
    }
}


# -------------------------------------------------------------------------------------------------------------
# -------------------------------------------- Script ---------------------------------------------------------

# Replace default Wallpaper and Lockscreens
Set-FilePermission -FilePath $DefaultWallpaper
Copy-Item "$CustomWallpaper" -Destination "$DefaultWallpaper"

# --- Replace default Lockscreens ---
$Lockscreens = Get-ChildItem $LockscreenDir
ForEach ($Lockscreen in $Lockscreens) {

    # Get file name and copy items
    $FilePath = $Lockscreen.FullName

    Set-FilePermission -FilePath $FilePath

    Write-Host "Copying $CustomWallpaper to $FilePath"
    Copy-Item $CustomWallpaper -Destination $FilePath -Force
}


# --- Replace 4K Wallpapers ---
$Wallpapers = Get-ChildItem $WallpaperDir
ForEach ($Wallpaper in $Wallpapers) {

    # Get file name and copy items
    $FileName = $Wallpaper.Name
    $FilePath = $Wallpaper.FullName

    Set-FilePermission -FilePath $FilePath

    Write-Host "Copying $FileName to $FilePath"
    Copy-Item "$PSScriptRoot\Wallpaper\$FileName" -Destination $FilePath -Force
}

#Remove cached wallpapers
if (Test-Path -Path $ENV:USERPROFILE\AppData\Roaming\Microsoft\Windows\Themes\TranscodedWallpaper) {
    Remove-Item $ENV:USERPROFILE\AppData\Roaming\Microsoft\Windows\Themes\TranscodedWallpaper
}

if (Test-Path -Path $ENV:USERPROFILE\AppData\Roaming\Microsoft\Windows\Themes\CachedFiles) {
    Remove-Item $ENV:USERPROFILE\AppData\Roaming\Microsoft\Windows\Themes\CachedFiles\*.*
}

if (Test-Path -Path "$SystemDataDir") {
    Set-FolderPermission -FolderPath "$SystemDataDir"
    Set-FolderPermission -FolderPath "$SystemDataDir\S-1-5-18"
    Set-FolderPermission -FolderPath "$SystemDataDir\S-1-5-18\ReadOnly"
    Set-FolderPermission -FolderPath "$SystemDataDir\S-1-5-18\ReadOnly\Lockscreen_Z"

    # Loop through cached files
    $Lockscreens_Chached = Get-ChildItem "$SystemDataDir\S-1-5-18\ReadOnly\Lockscreen_Z"
    ForEach ($Lockscreen in $Lockscreens_Chached) {

        Set-FilePermission -FilePath $Lockscreen.Fullname

        Write-Host "Removing cached wallpaper $Lockscreen"

        try {
            Remove-Item $Lockscreen.Fullname
        }
        catch {
            Write-Error "Failed to remove file: $_"
        }
    }
}

# Restart Explorer
Stop-Process -Name "Explorer"

EXIT $Exitcode
