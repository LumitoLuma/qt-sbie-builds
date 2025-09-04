echo %*
set "qt_version=%2"
set "qt_source_url=https://download.qt.io/archive/qt/6.8/%qt_version%/single/qt-everywhere-src-%qt_version%.zip"
set "qt_patch_url=https://download.qt.io/archive/qt/6.8"
set "openssl_version=%3"
set "openssl_source_url=https://github.com/openssl/openssl/releases/download/openssl-%openssl_version%/openssl-%openssl_version%.tar.gz"
set "bDir=%~dp0"
set "bDir=%bDir:~0,-1%"
set "EOL=CRLF"
if "%EOL%" == "LF" (
    echo Patch file line endings will be converted to LF ^(Unix^) using Dos2Unix.
    set "EOLconverter=dos2unix"
) else (
    echo Patch file line endings will be converted to CRLF ^(Windows^) using Unix2Dos.
    set "EOLconverter=unix2dos"
)

if exist "%bDir%\qt-everywhere-src-%qt_version%\configure.bat" goto done

REM Downloading Qt 6 source code...
echo Downloading Qt %qt_version% source code...
curl -LsSO --output-dir "%bDir%" "%qt_source_url%"
"C:\Program Files\7-Zip\7z.exe" x -aoa -o"%bDir%" "%bDir%\qt-everywhere-src-%qt_version%.zip"
move "%bDir%\qt-everywhere-src-%qt_version%" "%bDir%\src"

REM Downloading Qt 6 patches for Win7
curl -LsSO --output-dir "%bDir%" "https://github.com/crystalidea/qt6windows7/archive/refs/tags/v6.8.3.zip"
"C:\Program Files\7-Zip\7z.exe" x -aoa -o"%bDir%" "%bDir%\v6.8.3.zip"
xcopy "%bDir%\qt6windows7-6.8.3\qtbase" "%bDir%\src\qtbase" /S /H /Q /Y /R /E

REM Downloading Qt 6 security patches...
echo Downloading Qt %qt_version% security patches...

if "%qt_version%" == "6.8.3" echo Qt version is %qt_version% & goto verMin3

:verMin3
curl -LsSO --output-dir "%bDir%\src\qtbase" "%qt_patch_url%/CVE-2025-3512-qtbase-6.8.diff"
curl -LsSO --output-dir "%bDir%\src\qtbase" "%qt_patch_url%/CVE-2025-4211-qtbase-6.8.diff"
curl -LsSO --output-dir "%bDir%\src\qtbase" "%qt_patch_url%/CVE-2025-5455-qtbase-6.8.patch"
curl -LsSO --output-dir "%bDir%\src\qtbase" "%qt_patch_url%/CVE-2025-5992-qtbase-6.8.patch"
curl -LsSO --output-dir "%bDir%\src\qtbase" "%qt_patch_url%/CVE-2025-6338-qtbase-6.8.patch"
curl -LsSO --output-dir "%bDir%\src\qtconnectivity" "%qt_patch_url%/CVE-2025-23050-qtconnectivity-6.8.diff"
curl -LsSO --output-dir "%bDir%\src\qtimageformats" "%qt_patch_url%/CVE-2025-5683-qtimageformats-6.8.patch"

REM Install GNU Patch tool (from Chocolatey)...
choco install patch -y

REM Install Dos2Unix / Unix2Dos - Text file format converters
choco install dos2unix -y

REM Patch Qt sources...

pushd "%bDir%\src\qtbase"
set qtbase_patches="CVE-2025-3512-qtbase-6.8.diff" "CVE-2025-4211-qtbase-6.8.diff" "CVE-2025-5455-qtbase-6.8.patch" "CVE-2025-5992-qtbase-6.8.patch" "CVE-2025-6338-qtbase-6.8.patch"
for %%i in (%qtbase_patches%) do (
    if exist "%%i" (
        echo Applying patch "%%i"
        %EOLconverter% --verbose "%%i"
        patch -p1 --verbose -u -i "%%i"
    ) else (
        echo File "%%i" does not exist. Skipping...
    )
)
popd

pushd "%bDir%\src\qtimageformats"
set qtimageformats_patches="CVE-2025-5683-qtimageformats-6.8.patch"
for %%i in (%qtimageformats_patches%) do (
    if exist "%%i" (
        echo Applying patch "%%i"
        %EOLconverter% --verbose "%%i"
        patch -p1 --verbose -u -i "%%i"
    ) else (
        echo File "%%i" does not exist. Skipping...
    )
)
popd

pushd "%bDir%\src\qtconnectivity"
set qtconnectivity_patches="CVE-2025-23050-qtconnectivity-6.8.diff"
for %%i in (%qtconnectivity_patches%) do (
    if exist "%%i" (
        echo Applying patch "%%i"
        %EOLconverter% --verbose "%%i"
        patch -p1 --verbose -u -i "%%i"
    ) else (
        echo File "%%i" does not exist. Skipping...
    )
)
popd

REM Download openssl sources...
curl -LsSO --output-dir "%bDir%" "%openssl_source_url%"
tar -xzf "openssl-%openssl_version%.tar.gz"
move "%bDir%\openssl-%openssl_version%" "%bDir%\src\openssl"

if "%1" == "repack" (
    REM Pack patched Qt sources...
    mkdir "%bDir%\src_archive" && tar -cf "src_archive/qt-everywhere-src-%qt_version%-patched-openssl.tar" "%bDir%\src"
)

:done

REM dir %bDir%
REM dir %bDir%\src
