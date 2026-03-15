# BZ BidWave - User Guide

## Overview
BZ BidWave is Belize's first open online marketplace for bidding/auctions. This guide covers the core user flows for the MVP.

## Getting Started

### 1. Accessing the Platform
- **Web Portal**: Visit the hosted website (URL to be provided after deployment)
- **Mobile App**: Download the Android APK from the GitHub releases page

### 2. User Onboarding
1. Click "Get Started" on the homepage
2. Enter your display name (e.g., BZ_Bidder_01)
3. Select your primary role:
   - **Bidder**: Looking to buy items
   - **Seller**: Looking to sell items
4. Select interest categories (Luxury, Vehicles, Real Estate, etc.)
5. Complete setup to access your dashboard

### 3. Core Features

#### Browsing Auctions
- View featured auctions on the homepage
- Browse by category in the marketplace section
- Filter by Belize districts (Belize, Cayo, Stann Creek, etc.)
- See real-time bid updates

#### Placing Bids
1. Navigate to an auction listing
2. View current bid and time remaining
3. Click "Place Bid Now" or "View Auction →"
4. Enter your bid amount (must be higher than current bid)
5. Confirm your bid

#### Creating Listings (Coming Soon)
1. Click "+ List Item" in the dashboard
2. Fill in item details:
   - Title and description
   - Category selection
   - Starting price
   - Upload up to 3 photos (compressed for web)
3. Set auction duration
4. Publish your listing

#### Account Management
- View your active bids and won items
- Access messaging/chat with other users
- Manage favorites/watchlist
- Update profile information

### 4. Technical Notes

#### Authentication
- Uses Clerk for secure authentication
- Username and 4-digit PIN system
- PIN can be changed after first login

#### Data & Storage
- Backend: Convex (real-time database)
- Photo hosting: Vercel (optimized/web compressed)
- Limit: 3 photos per active listing
- Analytics: Bid data stored for backend analytics

#### Offline Support
- Basic caching for improved performance
- Syncs when connection is restored

## Troubleshooting

### Common Issues
1. **404 Errors on Web**: Ensure you're using the correct URL paths
2. **App Installation**: Enable "Install from Unknown Sources" in Android Settings
3. **Connection Issues**: Check your internet connection and try refreshing
4. **Bid Not Updating**: Pull down to refresh or wait for real-time update

### Support
For issues not covered here, please check the GitHub repository issues section or contact support through the platform.

## Version Information
- **Current Version**: 1.0.0
- **Build Date**: March 2026
- **Platform**: Android APK + Web Portal
- **Backend**: Convex
- **Auth**: Clerk