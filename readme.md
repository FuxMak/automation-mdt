# Automation - MDT / Windows Deployment

Welcome to the `automation-mdt` repository. This repository is dedicated to the development and sharing of scripts and registry key collections related to the deployment of the Windows client OS.

These scripts will not only cleaned up the OS and make it look more aestheticly pleasing, but it also improves the security and privacy (while not limiting the user in any meaningful way)

## Imaging_SetWallPaper.ps1

In order to overwrite every necessary item, the default wallpaper needs to be available in a lot of resolutions. This is actually not really required because Windows does scale the image up or down in relation to your screen resolution. If you don't have version of your wallpaper with each of the required resolutions, create copies of the initial image using the following code in the root directory

```powershell
    $background_default = "Desktop_Standard_1920x1080.jpg"

    $backgrounds = @("img0_1024x768.jpg", "img0_1200x1920.jpg", "img0_1366x768.jpg", "img0_1600x2560.jpg", "img0_1920x1200.jpg", "img0_2160x3840.jpg", "img0_2560x1600.jpg", "img0_3840x2160.jpg", "img0_768x1024.jpg", "img0_768x1366.jpg")

    foreach ($background in $backgrounds) {Copy-Item ".\Wallpaper\$background_default" ".\Wallpaper\$background"}

```

## MDT*Import_Drivers*[Vendor].ps1

### Introduction

The custom import drivers script features an automated solution for downloading (or creating) driver packages directly from the official vendor repositories.
These will be extracted and imported into the MDT Deployment Share without any disturbing bloatware.

### Workflow

1. The script works using a powershell table/array with the product codes, names and models used by the different vendors for identification.
2. It checks if a driver bundle is available for the model specified in the table. If not, a new package with the required drivers is being created.
3. These are extracted and imported into MDT only using the .inf files (removes Bloatware).
4. The predefined task sequence uses the defined folder structure in the script to pick only the required drivers during the imaging.

#### Example: Hewlett-Packard -> HP PROBOOK 650 G4

1. Get the clients **PRODUCT ID** using powershell "Get-WmiObject Win32_BaseBoard | Select Product"
2. Get the clients **MODEL** using powershell "Get-WmiObject Win32_Computersystem"

3. Alter the variable in the script: -> Insert a new line with PRODUCT ID **8416** and MODEL **HP PROBOOK 650 G4**

```powershell
$HPModelsTable = @(
    @{ ProdCode = '8846'; Model = 'HP ELITEBOOK 850 G8' }
    @{ ProdCode = '8416'; Model = 'HP PROBOOK 650 G4' }
)
```

#### Example: Lenovo -> Thinkpad E14 Gen 3

1. Get the clients **PRODUCT ID** (first 4 letters only) using powershell "Get-WmiObject Win32_BaseBoard | Select Product"
2. Double-check the **MODEL** using the catalog from Lenovo directly "https://download.lenovo.com/cdrt/td/catalogv2.xml"
3. Alter the variable in the script: -> Insert a new line with PRODUCT ID **20Y7** and MODEL **Thinkpad E14 Gen 3**

```powershell
$ModelsTable_Lenovo = @(
    @{ ProdCode = '20Y7'; Model = 'Thinkpad E14 Gen 3' }
    @{ ProdCode = '21EB'; Model = 'ThinkPad E14 Gen 4' }
)
```

#### Example: Dell -> Precision 7560

1. Get the clients **PRODUCT ID** using powershell "Get-WmiObject Win32_ComputerSystem | Select-Object -ExpandProperty SystemSKUNumber"
2. Get the clients **MODEL** using powershell "Get-WmiObject Win32_Computersystem"

3. Alter the variable in the script: -> Insert a new line with PRODUCT ID **0A69** and MODEL **Precision 7560**

```powershell
$HPModelsTable = @(
    @{ ProdCode = '0A69'; Model = 'Precision 7560' }
)
```
