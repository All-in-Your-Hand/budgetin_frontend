#!/bin/bash

# Build script for Flutter web with environment variables
# This script can be used for local development, staging, and production builds

# Default values
ENVIRONMENT=${ENVIRONMENT:-"development"}
BACKEND_URL=${BACKEND_URL:-"http://localhost:8080"}

# Check if we're in a Vercel environment
if [ -n "$VERCEL" ]; then
    echo "Detected Vercel environment"
    ENVIRONMENT="production"
    # Vercel environment variables will be available
    # BACKEND_URL should be set in Vercel dashboard
fi

echo "Building Flutter web app..."
echo "Environment: $ENVIRONMENT"
echo "Backend URL: $BACKEND_URL"

# Build the Flutter web app with environment variables
flutter build web \
    --release \
    --dart-define=ENVIRONMENT=$ENVIRONMENT \
    --dart-define=BACKEND_URL=$BACKEND_URL

echo "Build completed successfully!" 