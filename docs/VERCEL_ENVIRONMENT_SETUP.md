# Vercel Environment Setup

This document explains how to set up environment variables in Vercel for the BudgetIn frontend application.

## Environment Variables

The application only requires one environment variable:

### BACKEND_URL

- **Description**: The URL of your backend API server
- **Example**: `https://your-backend-api.vercel.app` or `https://api.yourdomain.com`
- **Required**: Yes (for production)

## Setting up in Vercel Dashboard

1. Go to your Vercel project dashboard
2. Navigate to **Settings** → **Environment Variables**
3. Add a new environment variable:
   - **Name**: `BACKEND_URL`
   - **Value**: Your backend API URL
   - **Environment**: Production (and Preview if needed)
4. Save the environment variable

## Build Process

The build process automatically uses the `BACKEND_URL` environment variable:

- **Development**: Defaults to `http://localhost:8080`
- **Production**: Uses the `BACKEND_URL` environment variable from Vercel

## Verification

After deployment, you can verify the environment variable is working by:

1. Opening the deployed application
2. Opening browser developer tools
3. Checking the network requests to ensure they're going to the correct backend URL

## Troubleshooting

If the application is still using localhost in production:

1. Verify the environment variable is set correctly in Vercel
2. Check that the variable name is exactly `BACKEND_URL` (case-sensitive)
3. Redeploy the application after setting the environment variable
4. Clear browser cache and reload the page
