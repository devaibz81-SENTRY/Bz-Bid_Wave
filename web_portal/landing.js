// landing.js — Landing page animations and live bid simulation

document.addEventListener('DOMContentLoaded', () => {
  // Start all countdown timers
  document.querySelectorAll('[data-end-offset]').forEach((card, idx) => {
    const cdEl = document.getElementById(`cd-${idx + 1}`);
    if (cdEl) startCountdown(cdEl, parseInt(card.dataset.endOffset));
  });

  // Simulate live bid updates
  const bids = [
    { el: document.getElementById('bid-1'), base: 4200, step: [50, 150] },
    { el: document.getElementById('bid-2'), base: 1750, step: [25, 100] },
    { el: document.getElementById('bid-3'), base: 680,  step: [10, 50]  },
  ];

  function randomBump(bid) {
    const bump = Math.floor(Math.random() * (bid.step[1] - bid.step[0]) + bid.step[0]);
    bid.base += bump;
    if (bid.el) {
      bid.el.style.transform = 'scale(1.15)';
      bid.el.style.color = '#10b981';
      bid.el.textContent = formatCurrency(bid.base);
      setTimeout(() => {
        bid.el.style.transform = 'scale(1)';
        bid.el.style.color = '';
        bid.el.style.transition = 'all 0.4s ease';
      }, 600);
    }
  }

  // Stagger live updates
  setInterval(() => randomBump(bids[Math.floor(Math.random() * bids.length)]), 4500);

  // Animate stat counters on load
  const statUsers = document.getElementById('stat-users');
  const statAuctions = document.getElementById('stat-auctions');
  if (statUsers) animateCount(statUsers, 2847);
  if (statAuctions) animateCount(statAuctions, 142);

  // Scroll reveal animation
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(e => {
      if (e.isIntersecting) {
        e.target.style.opacity = '1';
        e.target.style.transform = 'translateY(0)';
      }
    });
  }, { threshold: 0.1 });

  document.querySelectorAll('.card, .feature-card').forEach(el => {
    el.style.opacity = '0';
    el.style.transform = 'translateY(20px)';
    el.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
    observer.observe(el);
  });
});
