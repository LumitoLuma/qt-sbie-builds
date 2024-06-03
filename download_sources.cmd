echo %*
set "qt_version=%2"
set "qt_source_url=https://download.qt.io/archive/qt/5.15/%qt_version%/single/qt-everywhere-opensource-src-%qt_version%.zip"
set "qt_patch_url=https://download.qt.io/archive/qt/5.15"
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

REM Downloading Qt 5.15 source code...
echo Downloading Qt %qt_version% source code...
curl -LsSO --output-dir "%bDir%" "%qt_source_url%"
"C:\Program Files\7-Zip\7z.exe" x -aoa -o"%bDir%" "%bDir%\qt-everywhere-opensource-src-%qt_version%.zip"
move "%bDir%\qt-everywhere-src-%qt_version%" "%bDir%\src"

REM Downloading Qt 5.15 security patches...
echo Downloading Qt %qt_version% security patches...

if "%qt_version%" == "5.15.13" echo Qt version is %qt_version% & goto verMin13
if "%qt_version%" == "5.15.14" echo Qt version is %qt_version% & goto verMin14
if "%qt_version%" == "5.15.15" echo Qt version is %qt_version% & goto verMin15
if "%qt_version%" == "5.15.16" echo Qt version is %qt_version% & goto verMin16
if "%qt_version%" == "5.15.17" echo Qt version is %qt_version% & goto verMin17
if "%qt_version%" == "5.15.18" echo Qt version is %qt_version% & goto verMin18
if "%qt_version%" == "5.15.19" echo Qt version is %qt_version% & goto verMin19

:verMin13
curl -LsSO --output-dir "%bDir%\src\qtsvg" "%qt_patch_url%/CVE-2023-32573-qtsvg-5.15.diff"
curl -LsSO --output-dir "%bDir%\src\qtbase" "%qt_patch_url%/CVE-2023-32762-qtbase-5.15.diff"
curl -LsSO --output-dir "%bDir%\src\qtbase" "%qt_patch_url%/CVE-2023-33285-qtbase-5.15.diff"
:verMin14
curl -LsSO --output-dir "%bDir%\src\qtbase" "%qt_patch_url%/CVE-2023-32763-qtbase-5.15.diff"
curl -LsSO --output-dir "%bDir%\src\qtbase" "%qt_patch_url%/CVE-2023-34410-qtbase-5.15.diff"
curl -LsSO --output-dir "%bDir%\src\qtbase" "%qt_patch_url%/CVE-2023-37369-qtbase-5.15.diff"
curl -LsSO --output-dir "%bDir%\src\qtbase" "%qt_patch_url%/CVE-2023-38197-qtbase-5.15.diff"
:verMin15
curl -LsSO --output-dir "%bDir%\src\qtimageformats" "%qt_patch_url%/CVE-2023-4863-5.15.patch"
curl -LsSO --output-dir "%bDir%\src\qtbase" "%qt_patch_url%/CVE-2023-43114-5.15.patch"
:verMin16
curl -LsSO --output-dir "%bDir%\src\qtbase" "%qt_patch_url%/0001-CVE-2023-51714-qtbase-5.15.diff"
curl -LsSO --output-dir "%bDir%\src\qtbase" "%qt_patch_url%/0002-CVE-2023-51714-qtbase-5.15.diff"
curl -LsSO --output-dir "%bDir%\src\qtbase" "%qt_patch_url%/CVE-2024-25580-qtbase-5.15.diff"
curl -LsSO --output-dir "%bDir%\src\qtnetworkauth" "%qt_patch_url%/CVE-2024-36048-qtnetworkauth-5.15.diff"
:verMin17
:verMin18
:verMin19


REM Install GNU Patch tool (from Chocolatey)...
choco install patch -y

REM Install Dos2Unix / Unix2Dos - Text file format converters
choco install dos2unix -y

REM Patch Qt sources...
pushd "%bDir%\src\qtsvg"
set qtsvg_patches="CVE-2023-32573-qtsvg-5.15.diff"
for %%i in (%qtsvg_patches%) do (
    if exist "%%i" (
        echo Applying patch "%%i"
        %EOLconverter% --verbose "%%i"
        patch -p1 --verbose -u -i "%%i"
    ) else (
        echo File "%%i" does not exist. Skipping...
    )
)
popd

pushd "%bDir%\src\qtbase"
set qtbase_patches="CVE-2023-32762-qtbase-5.15.diff" "CVE-2023-33285-qtbase-5.15.diff" "CVE-2023-32763-qtbase-5.15.diff" "CVE-2023-34410-qtbase-5.15.diff" "CVE-2023-37369-qtbase-5.15.diff" "CVE-2023-38197-qtbase-5.15.diff" "CVE-2023-43114-5.15.patch" "0001-CVE-2023-51714-qtbase-5.15.diff" "0002-CVE-2023-51714-qtbase-5.15.diff" "CVE-2024-25580-qtbase-5.15.diff"
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
set qtimageformats_patches="CVE-2023-4863-5.15.patch"
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

pushd "%bDir%\src\qtnetworkauth"
set qtnetworkauth_patches="CVE-2024-36048-qtnetworkauth-5.15.diff"
for %%i in (%qtnetworkauth_patches%) do (
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
    mkdir "%bDir%\src_archive" && tar -cf "src_archive/qt-everywhere-opensource-src-%qt_version%-patched-openssl.tar" "%bDir%\src"
)

:done

REM dir %bDir%
REM dir %bDir%\src
