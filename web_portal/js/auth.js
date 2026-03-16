// BidWave Auth Utilities
// Handles session management, auth checks, and navigation updates

const SESSION_KEY = 'bz_session';
const USER_KEY = 'bz_user';
const LISTINGS_KEY = 'bz_listings';

// Get current session
function getSession() {
  const session = localStorage.getItem(SESSION_KEY);
  return session ? JSON.parse(session) : null;
}

// Get stored user data (includes displayName, pin, createdAt)
function getUser() {
  const user = localStorage.getItem(USER_KEY);
  return user ? JSON.parse(user) : null;
}

// Check if user is logged in
function isLoggedIn() {
  const session = getSession();
  return session && session.loggedIn === true;
}

// Require authentication - redirects to login if not logged in
function requireAuth() {
  if (!isLoggedIn()) {
    window.location.href = '/login.html';
    return false;
  }
  return true;
}

// Logout - clears session and redirects to home
function logout() {
  localStorage.removeItem(SESSION_KEY);
  window.location.href = '/';
}

// Update navigation based on login state
function updateNav(userAvatar = null) {
  const session = getSession();
  const isAuth = isLoggedIn();
  
  // Find nav container if it exists
  const nav = document.querySelector('nav');
  if (!nav) return;
  
  // Check if we have a user avatar element
  const avatarEl = document.querySelector('.user-avatar');
  if (avatarEl) {
    if (isAuth) {
      const user = getUser();
      avatarEl.textContent = user?.displayName?.slice(0, 2).toUpperCase() || 'U';
      avatarEl.title = user?.displayName || 'User';
    } else {
      avatarEl.textContent = 'BZ';
      avatarEl.title = 'Guest';
    }
  }
  
  // Find auth links container
  const authContainer = nav.querySelector('.auth-links');
  if (authContainer) {
    if (isAuth) {
      const user = getUser();
      authContainer.innerHTML = `
        <a href="/dashboard-v2.html" class="text-sm font-medium text-slate-400 hover:text-white transition-colors">Dashboard</a>
        <a href="/news.html" class="text-sm font-medium text-slate-400 hover:text-white transition-colors">News</a>
        <a href="/chat.html" class="text-sm font-medium text-slate-400 hover:text-white transition-colors">Chat</a>
        <a href="/profile.html" class="text-sm font-medium text-slate-400 hover:text-white transition-colors">Profile</a>
        <button onclick="logout()" class="text-sm font-medium text-red-400 hover:text-red-300 transition-colors">Logout</button>
      `;
    } else {
      authContainer.innerHTML = `
        <a href="/login.html" class="text-sm font-medium text-white hover:text-yellow-400">Log In</a>
        <a href="/onboarding.html" class="btn-gold">Get Started</a>
      `;
    }
  }
  
  // Update logo link to go to dashboard if logged in
  const logoLink = nav.querySelector('a[href="/"]');
  if (logoLink && isAuth) {
    logoLink.href = '/dashboard-v2.html';
  }
}

// Get all listings
function getListings() {
  const listings = localStorage.getItem(LISTINGS_KEY);
  return listings ? JSON.parse(listings) : [];
}

// Add a new listing
function addListing(item) {
  const listings = getListings();
  const newItem = {
    id: Date.now().toString(),
    ...item,
    createdAt: Date.now(),
    bids: 0,
    currentBid: parseFloat(item.startingPrice) || 0,
    status: 'active'
  };
  listings.unshift(newItem);
  localStorage.setItem(LISTINGS_KEY, JSON.stringify(listings));
  return newItem;
}

// Initialize - run on page load
document.addEventListener('DOMContentLoaded', function() {
  updateNav();
});
