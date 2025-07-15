# Alternative Vercel Setup (Without vercel.json)

If you're experiencing deployment issues with the `vercel.json` file, you can configure Vercel entirely through the dashboard without any configuration file.

## Option 1: Remove vercel.json and Use Dashboard Configuration

### Step 1: Delete vercel.json

```bash
rm vercel.json
```

### Step 2: Configure Build Settings in Vercel Dashboard

1. Go to your Vercel project dashboard
2. Navigate to **Settings** → **General**
3. Scroll down to **Build & Development Settings**
4. Configure the following:

   **Framework Preset:** Other
   **Build Command:** `flutter build web --release --dart-define=ENVIRONMENT=${ENVIRONMENT:-production} --dart-define=BACKEND_URL=${BACKEND_URL}`
   **Output Directory:** `build/web`
   **Install Command:** `flutter pub get`

5. Click **Save**

### Step 3: Set Environment Variables

1. Go to **Settings** → **Environment Variables**
2. Add the following variables:

   **Variable Name:** `BACKEND_URL`
   **Value:**
   **Environment:** Production, Preview, Development

   **Variable Name:** `ENVIRONMENT`
   **Value:** `production`
   **Environment:** Production, Preview, Development

3. Click **Save**

### Step 4: Redeploy

After configuring everything in the dashboard, redeploy your application.

## Option 2: Use a Simple vercel.json (Current Approach)

If you prefer to keep the `vercel.json` file, the current minimal version should work:

```json
{
  "buildCommand": "flutter build web --release --dart-define=ENVIRONMENT=${ENVIRONMENT:-production} --dart-define=BACKEND_URL=${BACKEND_URL}",
  "outputDirectory": "build/web"
}
```

## Troubleshooting Deployment Issues

### If Build Command Fails

1. **Check Flutter Version**: Ensure Vercel supports your Flutter version
2. **Test Locally**: Run the build command locally to ensure it works:
   ```bash
   flutter build web --release --dart-define=ENVIRONMENT=production --dart-define=BACKEND_URL=
   ```

### If Environment Variables Don't Work

1. **Verify Variable Names**: They must be exactly `BACKEND_URL` and `ENVIRONMENT`
2. **Check Environment Scope**: Make sure variables are set for all environments (Production, Preview, Development)
3. **Redeploy**: Environment variables require a redeploy to take effect

### Alternative Build Command

If the current build command doesn't work, try this simpler version:

```bash
flutter build web --release
```

Then set the environment variables in your Flutter code to use default values when not provided:

```dart
static const String _backendUrl = String.fromEnvironment(
  'BACKEND_URL',
  defaultValue: ,
);
```

## Recommended Approach

For the most reliable deployment:

1. **Use Option 1** (Dashboard configuration without vercel.json)
2. **Set environment variables in the dashboard**
3. **Use the simple build command**: `flutter build web --release --dart-define=ENVIRONMENT=${ENVIRONMENT:-production} --dart-define=BACKEND_URL=${BACKEND_URL}`

This approach gives you the most control and is less likely to cause deployment issues.
