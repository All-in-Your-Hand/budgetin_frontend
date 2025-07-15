@echo off
REM Build script for Flutter web with environment variables (Windows)
REM This script can be used for local development, staging, and production builds

REM Default values
if "%ENVIRONMENT%"=="" set ENVIRONMENT=development
if "%BACKEND_URL%"=="" set BACKEND_URL=http://localhost:8080

REM Check if we're in a Vercel environment
if defined VERCEL (
    echo Detected Vercel environment
    set ENVIRONMENT=production
    REM Vercel environment variables will be available
    REM BACKEND_URL should be set in Vercel dashboard
)

echo Building Flutter web app...
echo Environment: %ENVIRONMENT%
echo Backend URL: %BACKEND_URL%

REM Build the Flutter web app with environment variables
flutter build web --release --dart-define=ENVIRONMENT=%ENVIRONMENT% --dart-define=BACKEND_URL=%BACKEND_URL%

echo Build completed successfully! 