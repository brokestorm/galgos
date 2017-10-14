love.exe Source
xcopy %APPDATA%\LOVE\HD_Generator /s /y
cd /d c:
cd %APPDATA%\LOVE\HD_Generator\HardData
del %APPDATA%\LOVE\HD_Generator\HardData /s /q
Rd %APPDATA%\LOVE\HD_Generator\HardData /s /q
