if %1 == x64 (
    set build_arch=x64
    set "PATH=%~dp0src\qtbase\bin;%~dp0src\gnuwin32\bin;%~dp0jom;%PATH%"
    call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars64.bat"
    pushd %~dp0src\
    call configure.bat -release -opensource -confirm-license -prefix %~dp0bin\5.15.13\msvc2019_64 -platform win32-msvc -nomake tests -nomake examples -skip qtdoc -skip qtwebengine
    jom
    if %ERRORLEVEL% == 0 jom install
    if %ERRORLEVEL% == 0 mkdir archive && "C:\Program Files\7-Zip\7z.exe" a -t7z -mx=9 -mfb=273 -ms -md=31 -myx=9 -mtm=- -mmt -mmtf -md=1536m -mmf=bt3 -mmc=10000 -mpb=0 -mlc=0 archive\qt-everywhere-5.15.13-Windows_10-MSVC2019-x86_64.7z bin\5.15.13
)

if %1 == Win32 (
    set build_arch=x86
    set "PATH=%~dp0src\qtbase\bin;%~dp0src\gnuwin32\bin;%~dp0jom;%PATH%"
    call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvarsamd64_x86.bat"
    pushd %~dp0src\
    call configure.bat -release -opensource -confirm-license -prefix %~dp0bin\5.15.13\msvc2019 -platform win32-msvc -nomake tests -nomake examples -skip qtdoc -skip qtwebengine
    jom
    if %ERRORLEVEL% == 0 jom install
    if %ERRORLEVEL% == 0 mkdir archive && "C:\Program Files\7-Zip\7z.exe" a -t7z -mx=9 -mfb=273 -ms -md=31 -myx=9 -mtm=- -mmt -mmtf -md=1536m -mmf=bt3 -mmc=10000 -mpb=0 -mlc=0 archive\qt-everywhere-5.15.13-Windows_10-MSVC2019-x86.7z bin\5.15.13
)