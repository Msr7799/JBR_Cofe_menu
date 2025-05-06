@echo off
echo ===================================================
echo    Flutter Project Clean and Rebuild
echo ===================================================
echo.

echo [1/5] Cleaning project (flutter clean)...
call flutter clean
echo.

echo [2/5] Deleting build folder...
rd /s /q build
echo.

echo [3/5] Deleting dart_tool folder...
rd /s /q .dart_tool
echo.

echo [4/5] Getting dependencies (flutter pub get)...
call flutter pub get
echo.

echo [5/5] Running application on Windows...
call flutter run -d windows
echo.

echo Process completed!
pause