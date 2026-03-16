# BZ BidWave - Flutter Build & Deploy

## Building Flutter Web

Run on your local machine:

```bash
cd flutter_app
flutter build web --release
```

This generates static files in `flutter_app/build/web/`

## Deploying to Vercel

### Option 1: Automatic (Recommended)
1. Push code to GitHub
2. Import project in Vercel
3. Add build command: `cd flutter_app && flutter build web --release`
4. Output directory: `flutter_app/build/web`
5. Deploy!

### Option 2: Manual
1. Build: `flutter build web --release`
2. The output is in `flutter_app/build/web/`
3. Vercel automatically serves this folder

## Current Project Structure

```
Bidding App/
├── flutter_app/          # Flutter app (mobile + web)
│   ├── lib/main.dart    # Main app code
│   └── build/web/       # Web output (after building)
├── web_portal/          # Static HTML (landing pages)
├── backend/             # Convex backend
└── vercel.json          # Vercel config
```

## Features
- Dark theme with gold accent
- Bottom navigation (Home, Activity, Add, Chat, Profile)
- Convex backend integration
- Same UI for app and web
