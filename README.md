# ⚡ BidWave — Setup Guide

## Project Structure

```
Bidding App/
├── backend/                    # Convex backend
│   ├── convex/
│   │   ├── schema.ts           # Database schema
│   │   ├── listings.ts         # Listing queries & mutations
│   │   └── bids.ts             # Bid mutation
│   ├── package.json
│   └── tsconfig.json
│
├── web_portal/                 # Vanilla HTML/CSS/JS website
│   ├── index.html              # Landing page
│   ├── onboarding.html         # Sign up / Sign in
│   ├── dashboard.html          # Big Screening dashboard
│   ├── download.html           # Android APK download page
│   ├── styles.css              # Shared design system
│   ├── utils.js                # Shared JS utilities
│   └── vercel.json             # Vercel deployment config
│
├── flutter_app/                # Flutter Android app (add yours here)
│
└── .github/workflows/
    └── build_android.yml       # Android APK build + GitHub Release
```

---

## 1. Convex Backend Setup

```bash
cd backend
npm install
npx convex dev   # Will prompt you to log in and link your project
```

After linking, grab your **Convex URL** from the dashboard — you'll need it for the Flutter app.

---

## 2. Web Portal Setup

### Locally
Just open any `.html` file in your browser — no build step needed.

### Deploy to Vercel
1. Push the `web_portal/` folder to GitHub.
2. Go to [vercel.com](https://vercel.com) → New Project → Import that repo.
3. Set **Root Directory** to `web_portal`.
4. Deploy! Vercel auto-detects the static site.

### Connect to your GitHub repo (for download links)
Open `web_portal/download.js` and update:
```js
const REPO_OWNER = 'YOUR_USERNAME';   // ← your GitHub username
const REPO_NAME  = 'YOUR_REPO';       // ← your repo name
```

---

## 3. Flutter App (Android)

1. Place your Flutter project inside `flutter_app/`.
2. Ensure `flutter_app/pubspec.yaml` has a `version:` field (e.g. `version: 1.0.0+1`).
3. The GitHub Actions workflow will automatically pick it up.

---

## 4. GitHub Actions — Auto-Build APK

The workflow at `.github/workflows/build_android.yml` will:
- ✅ Trigger on every push to `main`
- ✅ Build the Flutter release APK
- ✅ Create a GitHub Release and attach the APK
- ✅ The download page will automatically detect the latest release via the GitHub API

**No extra secrets needed** — it uses the built-in `GITHUB_TOKEN`.

---

## 5. Auth Setup

The portal currently uses a lightweight local flow. To connect **Clerk**:
1. Create a project at [clerk.com](https://clerk.com)
2. Replace the form submit handlers in `onboarding.js` with `Clerk.signUp()` / `Clerk.signIn()`
3. Add the Clerk JS snippet to `onboarding.html`

---

## Pages at a Glance

| Page | URL | Description |
|------|-----|-------------|
| Landing | `/` | Hero, live listings preview, features |
| Onboarding | `/onboarding` | 3-step sign up flow |
| Dashboard | `/dashboard` | Big Screening live auction board |
| Download | `/download` | Android APK download + install guide |
