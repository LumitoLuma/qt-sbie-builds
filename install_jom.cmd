@REM From https://github.com/sandboxie-plus/Sandboxie

if exist %~dp0jom\jom.exe goto done

curl -LsSO --output-dir %~dp0 https://download.qt.io/official_releases/jom/jom.zip
"C:\Program Files\7-Zip\7z.exe" x -aoa -o%~dp0jom %~dp0jom.zip

:done

REM dir %~dp0
REM dir %~dp0jom\