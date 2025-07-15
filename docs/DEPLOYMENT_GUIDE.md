# Deployment Guide - Environment Variables Setup

## Summary

Your Flutter frontend has been updated to use environment variables for the backend URL. This keeps your backend URL secure and allows for different configurations across environments.

## What Was Changed

1. **Created Environment Configuration System** (`lib/src/core/config/environment_config.dart`)

   - Handles environment variables for different deployment environments
   - Automatically detects development vs production environments
   - Provides secure access to backend URLs

2. **Updated Network Constants** (`lib/src/core/utils/constant/network_constants.dart`)

   - Now uses environment configuration instead of hardcoded URLs
   - All endpoints now dynamically use the configured backend URL

3. **Added Vercel Configuration** (`vercel.json`)

   - Configured for Flutter web builds
   - Uses environment variables during build process

4. **Created Build Scripts** (`scripts/build.sh` and `scripts/build.bat`)
   - Handles different environments
   - Can be used for local development and CI/CD

## Next Steps for Vercel Deployment

### 1. Set Environment Variables in Vercel Dashboard

1. Go to your Vercel dashboard
2. Select your BudgetIn frontend project
3. Navigate to **Settings** → **Environment Variables**
4. Add these variables:

   **Variable Name:** `BACKEND_URL`
   **Value:**
   **Environment:** Production, Preview, Development

   **Variable Name:** `ENVIRONMENT`
   **Value:** `production`
   **Environment:** Production, Preview, Development

5. Click **Save**

### 2. Redeploy Your Application

After setting the environment variables, redeploy your application in Vercel. The build process will now use the environment variables to configure the backend URL.

### 3. Verify Deployment

1. Check that your application loads correctly
2. Test authentication (login/register) to ensure it connects to your live backend
3. Verify that transactions and accounts work properly

## Local Development

For local development, you can:

### Option 1: Use Environment Variables

```bash
# Windows
set BACKEND_URL=http://localhost:8080
set ENVIRONMENT=development
flutter run -d web-server

# macOS/Linux
export BACKEND_URL=http://localhost:8080
export ENVIRONMENT=development
flutter run -d web-server
```

### Option 2: Use Build Scripts

```bash
# Windows
scripts\build.bat

# macOS/Linux
chmod +x scripts/build.sh
./scripts/build.sh
```

### Option 3: Direct Flutter Command

```bash
flutter run -d web-server --dart-define=ENVIRONMENT=development --dart-define=BACKEND_URL=http://localhost:8080
```

## Security Benefits

- ✅ Backend URL is no longer hardcoded in source code
- ✅ Environment variables are encrypted in Vercel
- ✅ Different environments can use different backend URLs
- ✅ Easy to update backend URL without code changes

## Troubleshooting

### If Environment Variables Don't Work

1. **Check Vercel Dashboard**: Ensure variables are set correctly
2. **Redeploy**: Environment variables require a redeploy to take effect
3. **Check Build Logs**: Look for any build errors in Vercel
4. **Verify Variable Names**: They must match exactly (case-sensitive)

### If Backend Connection Fails

1. **Test Backend URL**: Try accessing directly
2. **Check CORS**: Ensure your backend allows requests from your Vercel domain
3. **Verify Backend Health**: Make sure your Render backend is running

### If Build Fails

1. **Check Flutter Version**: Ensure you're using a compatible Flutter version
2. **Dependencies**: Run `flutter pub get` locally to check for issues
3. **Build Command**: Verify the build command in `vercel.json`

## Environment Configuration Details

The application now supports three environments:

- **Development**: Uses localhost for web, 10.0.2.2 for Android
- **Staging**: Uses environment variable BACKEND_URL
- **Production**: Uses environment variable BACKEND_URL

The environment is automatically detected based on the `ENVIRONMENT` variable, with a default of "development" for local builds.

## Support

If you encounter any issues:

1. Check the detailed documentation in `docs/ENVIRONMENT_SETUP.md`
2. Review Vercel's environment variables documentation
3. Test with a simple environment variable first
4. Check the application logs in Vercel dashboard
