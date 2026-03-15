/* Dashboard Logic v3 — Added Social Features (Favorites, Share, Comments) */

document.addEventListener('DOMContentLoaded', () => {
    // State
    let currentFilter = 'all';
    let currentCategory = 'all';
    let currentDistrict = 'all';
    let isBigScreen = false;
    let favorites = new Set();

    // UI Elements
    const grid = document.getElementById('dash-grid');
    const chartContainer = document.getElementById('bid-chart');
    const chatToggle = document.getElementById('chat-toggle');
    const chatPanel = document.getElementById('chat-panel');
    const chatClose = document.getElementById('chat-close');
    const chatInput = document.getElementById('chat-input');
    const chatSend = document.getElementById('chat-send');
    const chatMessages = document.getElementById('chat-messages');
    const createModal = document.getElementById('create-modal');
    const createForm = document.getElementById('create-listing-form');
    const openCreateBtn = document.getElementById('open-create-modal');

    // Mock Data
    const mockListings = [
        { id: '1', title: 'Luxury Timepiece Collection', bid: 4350, category: 'luxury', hot: true, time: 720, img: '⌚', location: 'Belize', comments: 3 },
        { id: '2', title: 'Signed Fender Stratocaster', bid: 1750, category: 'art', hot: true, time: 1800, img: '🎸', location: 'Cayo', comments: 12 },
        { id: '3', title: 'Belizean Art Print 2024', bid: 680, category: 'art', hot: false, time: 3600, img: '🖼️', location: 'Stann Creek', comments: 1 },
        { id: '4', title: 'Vintage Leica M3', bid: 920, category: 'tech', hot: false, time: 120, img: '📷', location: 'Orange Walk', comments: 5 },
        { id: '5', title: 'Toyota Hilux 2022', bid: 21500, category: 'vehicles', hot: true, time: 540, img: '🛻', location: 'Belmopan', comments: 42 },
        { id: '6', title: 'Free Desktop Monitor', bid: 0, category: 'free', hot: false, time: 900, img: '🖥️', location: 'Corozal', comments: 8 },
        { id: '7', title: 'BZ National Flag (Large)', bid: 0, category: 'free', hot: false, time: 1500, img: '🇧🇿', location: 'Toledo', comments: 2 },
        { id: '8', title: 'iPhone 15 Pro Max', bid: 1200, category: 'tech', hot: true, time: 300, img: '📱', location: 'Belize', comments: 15 }
    ];

    // Initialize Grid
    function renderGrid() {
        if (!grid) return;
        grid.innerHTML = '';
        
        let filtered = mockListings;
        if (currentCategory === 'fav') {
            filtered = filtered.filter(l => favorites.has(l.id));
        } else if (currentCategory !== 'all') {
            filtered = filtered.filter(l => l.category === currentCategory);
        }

        if (currentDistrict !== 'all') {
            filtered = filtered.filter(l => l.location === currentDistrict);
        }

        if (currentFilter === 'hot') {
            filtered = filtered.filter(l => l.hot);
        } else if (currentFilter === 'ending') {
            filtered = filtered.sort((a, b) => a.time - b.time);
        }

        if (filtered.length === 0) {
            grid.innerHTML = '<div class="col-span-full py-20 text-center opacity-50">No auctions found matching filters.</div>';
            return;
        }

        filtered.forEach(item => {
            const isFav = favorites.has(item.id);
            const card = document.createElement('article');
            card.className = 'dash-card';
            
            const imgHtml = item.imgUrl 
                ? `<img src="${item.imgUrl}" class="dash-card-actual-img" alt="${item.title}">`
                : item.img;

            card.innerHTML = `
                <div class="dash-card-img" style="background: linear-gradient(135deg, var(--bg-card), var(--bg-2))">
                    ${imgHtml}
                    <div class="card-actions-overlay">
                        <button class="action-btn fav-btn ${isFav ? 'active' : ''}" onclick="event.stopPropagation(); toggleFav('${item.id}')" aria-label="Favorite">
                            ${isFav ? '❤️' : '🤍'}
                        </button>
                        <button class="action-btn share-btn" onclick="event.stopPropagation(); shareLink('${item.id}', '${item.title}')" aria-label="Share">
                            🔗
                        </button>
                        <button class="action-btn report-btn" onclick="event.stopPropagation(); reportListing('${item.id}')" aria-label="Report" title="Report to Admin">
                            🚩
                        </button>
                    </div>
                    ${item.hot ? '<span class="badge badge-hot" style="position:absolute; top:12px; right:12px;">🔥 HOT</span>' : ''}
                    ${item.bid === 0 ? '<span class="badge" style="position:absolute; top:12px; left:12px; background:var(--bz-blue); color:#fff; font-weight:700; border:1px solid rgba(255,255,255,0.2);">🇧🇿 FREE</span>' : ''}
                </div>
                <div class="dash-card-body">
                    <div class="flex justify-between items-start mb-2">
                        <h3 class="dash-card-title">${item.title}</h3>
                        <span style="font-size:10px; color:var(--text-dim);">🇧🇿 ${item.location}</span>
                    </div>
                    <div class="dash-card-row">
                        <div>
                            <div style="font-size:10px; color:var(--text-dim); text-transform:uppercase;">${item.bid === 0 ? 'Giveaway' : 'Current Bid'}</div>
                            <div class="dash-bid-box">
                                <span class="dash-bid" style="${item.bid === 0 ? 'color: var(--success);' : ''}">${item.bid === 0 ? 'FREE' : formatCurrency(item.bid)}</span>
                            </div>
                        </div>
                        <div class="text-right">
                             <div class="countdown" style="font-size:12px; color: ${item.time < 300 ? 'var(--bz-red)' : ''}">${formatTimeRemaining(item.time)}</div>
                             <div style="font-size:10px; color:var(--text-dim); margin-top:4px;">💬 ${item.comments} comments</div>
                        </div>
                    </div>
                </div>
            `;
            grid.appendChild(card);
            
            // Apply auto-shrink post-render
            const bidEl = card.querySelector('.dash-bid');
            if (bidEl) autoShrinkText(bidEl);
        });
    }

    // Social Actions
    window.toggleFav = (id) => {
        if (favorites.has(id)) favorites.delete(id);
        else favorites.add(id);
        renderGrid();
        showToast(favorites.has(id) ? 'Added to favorites 🇧🇿' : 'Removed from favorites');
    };

    window.shareLink = async (id, title) => {
        const shareData = {
            title: `BZ BidWave: ${title}`,
            text: `Check out this auction on Belize's first bidding platform!`,
            url: window.location.origin + '/listing/' + id
        };
        try {
            if (navigator.share) {
                await navigator.share(shareData);
            } else {
                await navigator.clipboard.writeText(shareData.url);
                showToast('Link copied to clipboard! 🔗');
            }
        } catch (err) {
            console.error(err);
        }
    };

    window.reportListing = (id) => {
        // In a real app, this would open a modal with reasons
        showToast('Listing reported to Admin. Thank you for keeping BZ safe! 🚩', 'danger');
    };

    // Helper: format 720 to 12:00
    function formatTimeRemaining(seconds) {
        const m = Math.floor(seconds / 60);
        const s = seconds % 60;
        return `${m}:${s < 10 ? '0' : ''}${s}`;
    }

    // Filter Logic
    window.filterSort = (type) => {
        currentFilter = type;
        document.querySelectorAll('.btn-ghost').forEach(b => b.classList.remove('active'));
        document.getElementById(`f-${type}`).classList.add('active');
        renderGrid();
    };

    window.filterCat = (cat) => {
        currentCategory = cat;
        document.querySelectorAll('.cat-pill').forEach(b => b.classList.remove('active'));
        document.getElementById(`c-${cat}`).classList.add('active');
        renderGrid();
    };

    window.filterDistrict = (dist) => {
        currentDistrict = dist;
        document.querySelectorAll('.dist-pill').forEach(b => b.classList.remove('active'));
        document.getElementById(`d-${dist}`).classList.add('active');
        renderGrid();
    };

    // Chat Logic
    if (chatToggle) {
        chatToggle.onclick = () => {
            chatPanel.classList.toggle('active');
            chatToggle.style.display = chatPanel.classList.contains('active') ? 'none' : 'flex';
        };
    }
    if (chatClose) {
        chatClose.onclick = () => {
            chatPanel.classList.remove('active');
            chatToggle.style.display = 'flex';
        };
    }

    function addMessage(sender, content, isMine = false) {
        const msg = document.createElement('div');
        msg.className = `chat-msg ${isMine ? 'mine' : ''}`;
        msg.innerHTML = `
            <span class="msg-sender">${sender}</span>
            <p class="msg-content">${content}</p>
        `;
        chatMessages.appendChild(msg);
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }

    if (chatSend) {
        chatSend.onclick = () => {
            const val = chatInput.value.trim();
            if (val) {
                addMessage('Me', val, true);
                chatInput.value = '';
                
                const replies = [
                    "Just placed a bid on that Hilux! Hope I win 🇧🇿",
                    "Anyone knows if the Luxury Timepiece has papers?",
                    "That guitar is sweet! I'm watching it.",
                    "Is the free monitor still available? I'm in Cayo.",
                    "Corozal meetup possible if I win?",
                    "Prices are going up fast today! ⚡",
                    "Belize District bidders are aggressive lol",
                    "I really need that tech bundle.",
                    "Anyone outbidding me on the flag? 🇧🇿",
                    "Auction room is fire right now! 🔥"
                ];
                setTimeout(() => {
                    const usernames = ['BigBidder_BZ', 'Cayo_Queen', 'Corozal_King', 'Belizean_Pro', 'IslandVibes_21', 'MarketMaster'];
                    const randomName = usernames[Math.floor(Math.random()*usernames.length)];
                    addMessage(randomName, replies[Math.floor(Math.random()*replies.length)]);
                    
                    const randomListing = mockListings[Math.floor(Math.random()*mockListings.length)];
                    if (randomListing.bid > 0) {
                        randomListing.bid += Math.floor(Math.random() * 50 + 10);
                        renderGrid();
                    }
                }, 1500);
            }
        };
        chatInput.onkeypress = (e) => { if(e.key === 'Enter') chatSend.click(); };
    }

    // Chart Logic
    function initChart() {
        if (!chartContainer) return;
        chartContainer.innerHTML = '';
        const barCount = 12;
        for (let i = 0; i < barCount; i++) {
            const bar = document.createElement('div');
            bar.className = 'bid-bar';
            bar.style.height = (20 + Math.random() * 80) + '%';
            chartContainer.appendChild(bar);
        }
    }

    function updateChart() {
        if (!chartContainer) return;
        const bars = chartContainer.querySelectorAll('.bid-bar');
        for (let i = 0; i < bars.length - 1; i++) {
            bars[i].style.height = bars[i+1].style.height;
        }
        const newBar = bars[bars.length - 1];
        newBar.className = 'bid-bar new-bar';
        newBar.style.height = (40 + Math.random() * 60) + '%';
        setTimeout(() => newBar.className = 'bid-bar', 600);
    }

    // Screen Mode
    window.toggleScreenMode = () => {
        isBigScreen = !isBigScreen;
        document.body.classList.toggle('bigscreen');
        const btn = document.getElementById('screen-btn');
        btn.textContent = isBigScreen ? '✕ Exit Screen' : '⛶ Big Screen';
        btn.setAttribute('aria-pressed', isBigScreen);
    };

    // Intervals for simulation
    setInterval(() => {
        const fbid = document.getElementById('f-bid');
        if (fbid) {
            let val = parseInt(fbid.textContent.replace(/[$,]/g, ''));
            val += Math.floor(Math.random() * 100 + 50);
            fbid.textContent = formatCurrency(val);
            autoShrinkText(fbid);
            updateChart();
            if(document.getElementById('ts-topbid')) {
                const tsTop = document.getElementById('ts-topbid');
                tsTop.textContent = formatCurrency(val);
                autoShrinkText(tsTop);
            }
        }
        
        mockListings.forEach(l => { if(l.time > 0) l.time--; });
        renderGrid();
    }, 1000);

    // Modal Helpers
    window.toggleCreateModal = () => {
        if (!createModal) return;
        createModal.style.display = createModal.style.display === 'none' ? 'flex' : 'none';
    };

    if (openCreateBtn) {
        openCreateBtn.onclick = toggleCreateModal;
    }

    if (createForm) {
        createForm.onsubmit = async (e) => {
            e.preventDefault();
            const btn = createForm.querySelector('button[type="submit"]');
            
            const title = document.getElementById('l-title').value;
            const cat = document.getElementById('l-category').value;
            const price = parseFloat(document.getElementById('l-price').value);
            const imageFile = document.getElementById('l-image').files[0];

            // 1. MB Handling & Validation
            if (imageFile && imageFile.size > 5 * 1024 * 1024) {
                showToast('Image too large! Please keep it under 5MB 🇧🇿', 'danger');
                return;
            }

            btn.disabled = true;
            btn.textContent = 'Optimizing Image... ⚡';

            let imgUrl = null;

            // 2. Client-side Compression to WebP
            if (imageFile) {
                try {
                    imgUrl = await compressImage(imageFile);
                } catch (err) {
                    console.error("Compression failed:", err);
                    imgUrl = URL.createObjectURL(imageFile); // Fallback to raw
                }
            }

            const newListing = {
                id: 'new_' + Date.now(),
                title: title,
                bid: price,
                category: cat,
                hot: false,
                time: 3600,
                img: '📦',
                imgUrl: imgUrl,
                location: 'Belize City',
                comments: 0
            };

            mockListings.unshift(newListing);
            renderGrid();
            toggleCreateModal();
            createForm.reset();
            btn.disabled = false;
            btn.textContent = 'Post Listing';
            showToast('Item listed successfully! 🇧🇿⚡');
        };
    }

    // Image Compression Helper
    async function compressImage(file) {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.readAsDataURL(file);
            reader.onload = (event) => {
                const img = new Image();
                img.src = event.target.result;
                img.onload = () => {
                    const canvas = document.createElement('canvas');
                    const ctx = canvas.getContext('2d');
                    
                    // Max dimensions 1200px
                    let width = img.width;
                    let height = img.height;
                    const max = 1200;
                    if (width > height && width > max) {
                        height *= max / width;
                        width = max;
                    } else if (height > max) {
                        width *= max / height;
                        height = max;
                    }
                    
                    canvas.width = width;
                    canvas.height = height;
                    ctx.drawImage(img, 0, 0, width, height);
                    
                    // Export to WebP with 0.8 quality
                    const dataUrl = canvas.toDataURL('image/webp', 0.8);
                    resolve(dataUrl);
                };
                img.onerror = reject;
            };
            reader.onerror = reject;
        });
    }

    // Close modal on outside click
    window.onclick = (event) => {
        if (event.target == createModal) toggleCreateModal();
    };

    // Initial Runs
    renderGrid();
    initChart();
});
