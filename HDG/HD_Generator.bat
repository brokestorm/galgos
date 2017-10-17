love.exe Source

echo %APPDATA%
xcopy "%APPDATA%\LOVE\HD_Generator" /s /y

cd /d c:

cd "%APPDATA%\LOVE\HD_Generator"
del "%APPDATA%\LOVE\HD_Generator\HardData" /s /q

Rd "%APPDATA%\LOVE\HD_Generator\HardData" /s /q
