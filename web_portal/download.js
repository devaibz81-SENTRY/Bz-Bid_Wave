// download.js — Fetch latest GitHub Release and update the download page

const REPO_OWNER = 'YOUR_USERNAME';
const REPO_NAME = 'YOUR_REPO';

async function fetchLatestRelease() {
  try {
    const res = await fetch(`https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/releases/latest`);
    if (!res.ok) throw new Error('No release found');
    const data = await res.json();

    // Update version label
    const versionEl = document.getElementById('apk-version');
    if (versionEl) versionEl.textContent = `Version ${data.tag_name}`;

    // Update release tag
    const rnTag = document.getElementById('rn-tag');
    if (rnTag) rnTag.textContent = data.tag_name;

    // Update date
    const date = new Date(data.published_at).toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' });
    const dlDate = document.getElementById('dl-date');
    if (dlDate) dlDate.textContent = `Released ${date}`;

    // Find APK asset
    const apkAsset = data.assets?.find(a => a.name.endsWith('.apk'));
    if (apkAsset) {
      const btn = document.getElementById('apk-btn') || document.getElementById('apk-link');
      if (btn) btn.href = apkAsset.browser_download_url;

      const sizeEl = document.getElementById('dl-size');
      if (sizeEl) {
        const mb = (apkAsset.size / 1024 / 1024).toFixed(1);
        sizeEl.textContent = `${mb} MB`;
      }

      // Update QR Code
      const qrEl = document.getElementById('qr-code');
      if (qrEl) {
        qrEl.src = `https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=${encodeURIComponent(apkAsset.browser_download_url)}`;
      }
    }

    // Update release notes from body
    if (data.body) {
      const lines = data.body
        .split('\n')
        .map(l => l.trim())
        .filter(l => l.startsWith('-') || l.startsWith('*'))
        .slice(0, 5)
        .map(l => l.replace(/^[-*]\s*/, ''));
      if (lines.length > 0) {
        const list = document.getElementById('rn-list');
        if (list) {
          list.innerHTML = lines.map(l => `<li>✦ ${l}</li>`).join('');
        }
      }
    }
  } catch {
    // GitHub API fails (no repo configured yet) — use defaults
    const versionEl = document.getElementById('apk-version');
    if (versionEl) versionEl.textContent = 'Connect your GitHub repo to see the latest version';
    const dlDate = document.getElementById('dl-date');
    if (dlDate) dlDate.textContent = 'Build via GitHub Actions';
  }
}

// Phone mockup bid animation
document.addEventListener('DOMContentLoaded', () => {
  fetchLatestRelease();

  const phoneBid = document.getElementById('phone-bid');
  let phoneBidVal = 4350;
  setInterval(() => {
    phoneBidVal += Math.floor(Math.random() * 100 + 30);
    if (phoneBid) {
      phoneBid.style.transform = 'scale(1.1)';
      phoneBid.style.color = '#10b981';
      phoneBid.textContent = formatCurrency(phoneBidVal);
      setTimeout(() => {
        phoneBid.style.transform = '';
        phoneBid.style.color = '#fbbf24';
        phoneBid.style.transition = 'all 0.3s ease';
      }, 500);
    }
  }, 5000);
});
