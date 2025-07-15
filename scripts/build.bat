@echo off
REM Build script for Flutter web with backend URL (Windows)
REM This script can be used for local development and production builds

REM Default backend URL for development
if "%BACKEND_URL%"=="" set BACKEND_URL=http://localhost:8080

echo Building Flutter web app...
echo Backend URL: %BACKEND_URL%

REM Build the Flutter web app with backend URL
flutter build web --release --dart-define=BACKEND_URL=%BACKEND_URL%

echo Build completed successfully! 