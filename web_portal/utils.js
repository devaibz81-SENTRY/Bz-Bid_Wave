// utils.js — Shared helpers

// Format currency
function formatCurrency(amount) {
  return new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD', maximumFractionDigits: 0 }).format(amount);
}

// Countdown timer
function startCountdown(el, secondsRemaining) {
  function render(total) {
    if (total <= 0) {
      el.innerHTML = `<span style="color:var(--danger);font-size:13px;font-weight:600;">ENDED</span>`;
      return;
    }
    const h = Math.floor(total / 3600);
    const m = Math.floor((total % 3600) / 60);
    const s = total % 60;
    el.innerHTML = `
      ${h > 0 ? `<div class="countdown-unit"><span class="countdown-value">${String(h).padStart(2,'0')}</span><span class="countdown-label">HRS</span></div>` : ''}
      <div class="countdown-unit"><span class="countdown-value">${String(m).padStart(2,'0')}</span><span class="countdown-label">MIN</span></div>
      <div class="countdown-unit"><span class="countdown-value">${String(s).padStart(2,'0')}</span><span class="countdown-label">SEC</span></div>
    `;
  }

  let remaining = secondsRemaining;
  render(remaining);
  const interval = setInterval(() => {
    remaining--;
    render(remaining);
    if (remaining <= 0) clearInterval(interval);
  }, 1000);
}

// Animate number counting up
function animateCount(el, target, prefix = '', suffix = '') {
  const start = 0;
  const duration = 1200;
  const startTime = performance.now();

  function step(now) {
    const elapsed = now - startTime;
    const progress = Math.min(elapsed / duration, 1);
    const ease = 1 - Math.pow(1 - progress, 3);
    const value = Math.floor(start + (target - start) * ease);
    el.textContent = prefix + value.toLocaleString() + suffix;
    if (progress < 1) requestAnimationFrame(step);
  }
  requestAnimationFrame(step);
}

// Show toast notification
function showToast(msg, type = 'success') {
  const toast = document.createElement('div');
  toast.textContent = msg;
  toast.style.cssText = `
    position: fixed; bottom: 24px; right: 24px; z-index: 9999;
    padding: 14px 22px;
    background: ${type === 'success' ? 'rgba(16,185,129,0.15)' : 'rgba(239,68,68,0.15)'};
    color: ${type === 'success' ? '#10b981' : '#ef4444'};
    border: 1px solid ${type === 'success' ? 'rgba(16,185,129,0.4)' : 'rgba(239,68,68,0.4)'};
    border-radius: 12px;
    font-family: 'Inter', sans-serif; font-size: 14px; font-weight: 500;
    backdrop-filter: blur(20px);
    animation: slideUp 0.3s ease forwards;
    pointer-events: none;
  `;
  document.body.appendChild(toast);
  setTimeout(() => {
    toast.style.animation = 'fadeOut 0.3s ease forwards';
    setTimeout(() => toast.remove(), 300);
  }, 3000);
}

// Add slide-up keyframe dynamically
const styleTag = document.createElement('style');
styleTag.textContent = `
  @keyframes slideUp { from { opacity:0; transform: translateY(16px); } to { opacity:1; transform:translateY(0); } }
  @keyframes fadeOut { from { opacity:1; } to { opacity:0; } }
`;
document.head.appendChild(styleTag);
