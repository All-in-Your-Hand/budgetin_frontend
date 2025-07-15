# Environment Variables Setup

This document explains how to set up environment variables for the BudgetIn frontend application.

## Overview

The application uses environment variables to configure the backend URL for different deployment environments (development, staging, production). This keeps sensitive information like backend URLs out of the source code.

## Environment Variables

### Required Variables

- `BACKEND_URL`: The URL of your backend API
- `ENVIRONMENT`: The deployment environment (`development`, `staging`, or `production`)

## Setting Up Environment Variables in Vercel

### Method 1: Vercel Dashboard (Recommended)

1. Go to your Vercel dashboard
2. Select your BudgetIn frontend project
3. Go to **Settings** → **Environment Variables**
4. Add the following environment variables:

   **Variable Name:** `BACKEND_URL`
   **Value:**
   **Environment:** Production, Preview, Development

   **Variable Name:** `ENVIRONMENT`
   **Value:** `production`
   **Environment:** Production, Preview, Development

5. Click **Save**
6. Redeploy your application

### Method 2: Vercel CLI

1. Install Vercel CLI if you haven't already:

   ```bash
   npm i -g vercel
   ```

2. Add environment variables:

   ```bash
   vercel env add BACKEND_URL
   vercel env add ENVIRONMENT
   ```

3. Follow the prompts to set the values

### Method 3: Using vercel.json (Alternative)

You can also set environment variables directly in the `vercel.json` file, but this is less secure as the values will be visible in your repository:

```json
{
  "env": {
    "BACKEND_URL": "https://budgetin-backend.onrender.com",
    "ENVIRONMENT": "production"
  }
}
```

## Local Development

For local development, you can set environment variables in several ways:

### Method 1: Environment Variables

**Windows:**

```cmd
set BACKEND_URL=http://localhost:8080
set ENVIRONMENT=development
flutter run -d web-server
```

**macOS/Linux:**

```bash
export BACKEND_URL=http://localhost:8080
export ENVIRONMENT=development
flutter run -d web-server
```

### Method 2: Using Build Scripts

Use the provided build scripts:

**Windows:**

```cmd
scripts\build.bat
```

**macOS/Linux:**

```bash
chmod +x scripts/build.sh
./scripts/build.sh
```

### Method 3: Direct Flutter Command

```bash
flutter run -d web-server --dart-define=ENVIRONMENT=development --dart-define=BACKEND_URL=http://localhost:8080
```

## Environment Configuration

The application automatically detects the environment and uses appropriate URLs:

- **Development**: Uses `http://localhost:8080` for web and `http://10.0.2.2:8080` for Android
- **Production**: Uses the `BACKEND_URL` environment variable
- **Staging**: Uses the `BACKEND_URL` environment variable

## Security Best Practices

1. **Never commit sensitive URLs to version control**
2. **Use Vercel's environment variables for production**
3. **Rotate backend URLs regularly if needed**
4. **Use HTTPS for production environments**
5. **Limit environment variable access to necessary team members**

## Troubleshooting

### Environment Variables Not Working

1. Check that the environment variables are set correctly in Vercel
2. Verify the variable names match exactly (case-sensitive)
3. Redeploy the application after setting environment variables
4. Check the browser console for any configuration errors

### Build Failures

1. Ensure Flutter is properly installed and configured
2. Check that all dependencies are installed (`flutter pub get`)
3. Verify the build command in `vercel.json` is correct
4. Check Vercel build logs for specific error messages

### Backend Connection Issues

1. Verify the backend URL is correct and accessible
2. Check CORS settings on your backend
3. Ensure the backend is running and healthy
4. Test the backend URL directly in a browser or API client

## Support

If you encounter issues with environment variable setup, please:

1. Check the Vercel documentation: https://vercel.com/docs/concepts/projects/environment-variables
2. Review the application logs in Vercel dashboard
3. Test with a simple environment variable first
4. Contact the development team for assistance
