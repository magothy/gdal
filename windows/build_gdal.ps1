
$workDir = "$PSScriptRoot\workdir"

$projDir = "$workDir\proj-5.2.0"
$projZip = "https://github.com/OSGeo/PROJ/releases/download/5.2.0/proj-5.2.0.zip"

$gdalDir = "$workDir\gdal-2.4.4"
$gdalZip = "https://github.com/OSGeo/gdal/releases/download/v2.4.4/gdal244.zip"

$installDir = "$workDir\install"
$projInstallDir = "$installDir\proj"
$gdalInstallDir = "$installDir\gdal"

New-Item -ItemType Directory -Path "$workDir" -Force

Push-Location $workDir

if ( -not (Test-Path -Path $projDir -PathType Any)) {
    Invoke-WebRequest -Uri $projZip -OutFile proj.zip
    Expand-Archive -Path proj.zip -DestinationPath .
}

Push-Location $projDir
nmake /f makefile.vc INSTDIR="$projInstallDir" install-all
Pop-Location

if ( -not (Test-Path -Path $gdalDir -PathType Any)) {
    Invoke-WebRequest -Uri $gdalZip -OutFile gdal.zip
    Expand-Archive -Path gdal.zip -DestinationPath .
}

Push-Location $gdalDir
nmake /f makefile.vc `
    GDAL_HOME="$gdalInstallDir" `
    WIN64=1 `
    devinstall
Pop-Location

Pop-Location

Remove-Item "$PSScriptRoot\include" -Force -Recurse
Remove-Item "$PSScriptRoot\bin" -Force -Recurse
Remove-Item "$PSScriptRoot\lib" -Force -Recurse
Remove-Item "$PSScriptRoot\share" -Force -Recurse
New-Item -ItemType Directory -Path "$PSScriptRoot\bin" -Force
New-Item -ItemType Directory -Path "$PSScriptRoot\lib" -Force
Copy-Item -Recurse "$gdalInstallDir\include" "$PSScriptRoot\include"
Copy-Item -Recurse "$gdalInstallDir\lib\gdal_i.lib" "$PSScriptRoot\lib"
Copy-Item -Recurse "$gdalInstallDir\bin\gdal204.dll" "$PSScriptRoot\bin"
Copy-Item -Recurse "$projInstallDir\bin\proj.dll" "$PSScriptRoot\bin"
Copy-Item -Recurse "$gdalInstallDir\data" "$PSScriptRoot\share\gdal"
