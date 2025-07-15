#!/bin/bash

# Build script for Flutter web with backend URL
# This script can be used for local development and production builds

# Default backend URL for development
BACKEND_URL=${BACKEND_URL:-"http://localhost:8080"}

echo "Building Flutter web app..."
echo "Backend URL: $BACKEND_URL"

# Build the Flutter web app with backend URL
flutter build web \
    --release \
    --dart-define=BACKEND_URL=$BACKEND_URL

echo "Build completed successfully!" 