if exist %~dp0qt-everywhere-src-5.15.13\configure.bat goto done

REM Downloading Qt 5.15.13 source code...
curl -LsSO --output-dir %~dp0 https://download.qt.io/archive/qt/5.15/5.15.13/single/qt-everywhere-opensource-src-5.15.13.zip
"C:\Program Files\7-Zip\7z.exe" x -aoa -o%~dp0 %~dp0qt-everywhere-opensource-src-5.15.13.zip
move %~dp0qt-everywhere-src-5.15.13 %~dp0src

REM Downloading Qt 5.15.13 security patches...
curl -LsSO --output-dir %~dp0src\qtsvg\ https://download.qt.io/archive/qt/5.15/CVE-2023-32573-qtsvg-5.15.diff
curl -LsSO --output-dir %~dp0src\qtbase\ https://download.qt.io/archive/qt/5.15/CVE-2023-32762-qtbase-5.15.diff
curl -LsSO --output-dir %~dp0src\qtbase\ https://download.qt.io/archive/qt/5.15/CVE-2023-32763-qtbase-5.15.diff
curl -LsSO --output-dir %~dp0src\qtbase\ https://download.qt.io/archive/qt/5.15/CVE-2023-33285-qtbase-5.15.diff
curl -LsSO --output-dir %~dp0src\qtbase\ https://download.qt.io/archive/qt/5.15/CVE-2023-34410-qtbase-5.15.diff
curl -LsSO --output-dir %~dp0src\qtbase\ https://download.qt.io/archive/qt/5.15/CVE-2023-37369-qtbase-5.15.diff
curl -LsSO --output-dir %~dp0src\qtbase\ https://download.qt.io/archive/qt/5.15/CVE-2023-38197-qtbase-5.15.diff
curl -LsSO --output-dir %~dp0src\qtbase\ https://download.qt.io/archive/qt/5.15/CVE-2023-43114-5.15.patch
curl -LsSO --output-dir %~dp0src\qtbase\ https://download.qt.io/archive/qt/5.15/0001-CVE-2023-51714-qtbase-5.15.diff
curl -LsSO --output-dir %~dp0src\qtbase\ https://download.qt.io/archive/qt/5.15/0002-CVE-2023-51714-qtbase-5.15.diff
curl -LsSO --output-dir %~dp0src\qtbase\ https://download.qt.io/archive/qt/5.15/CVE-2024-25580-qtbase-5.15.diff

REM Install GNU Patch tool (from Chocolatey)...
choco install patch -y

REM Patch Qt sources...
pushd %~dp0src\qtbase\
patch -p1 -i CVE-2023-32762-qtbase-5.15.diff
patch -p1 -i CVE-2023-32763-qtbase-5.15.diff
patch -p1 -i CVE-2023-33285-qtbase-5.15.diff
patch -p1 -i CVE-2023-34410-qtbase-5.15.diff
patch -p1 -i CVE-2023-37369-qtbase-5.15.diff
patch -p1 -i CVE-2023-38197-qtbase-5.15.diff
patch -p1 -i CVE-2023-43114-5.15.patch
patch -p1 -i 0001-CVE-2023-51714-qtbase-5.15.diff
patch -p1 -i 0002-CVE-2023-51714-qtbase-5.15.diff
patch -p1 -i CVE-2024-25580-qtbase-5.15.diff
popd
pushd %~dp0src\qtsvg\
patch -p1 -i CVE-2023-32573-qtsvg-5.15.diff
popd

if %1 == repack_sources (
    REM Pack patched Qt sources...
    mkdir %~dp0src_archive && "C:\Program Files\7-Zip\7z.exe" a -t7z -mx=9 -mfb=273 -ms -md=31 -myx=9 -mtm=- -mmt -mmtf -md=1536m -mmf=bt3 -mmc=10000 -mpb=0 -mlc=0 %~dp0src_archive\qt-everywhere-opensource-src-5.15.13-patched.7z %~dp0src
)

:done

REM dir %~dp0
REM dir %~dp0src\