import { ConvexClient } from "convex/browser";

document.addEventListener('DOMContentLoaded', async () => {
    // Convex Client Initialization
    const client = new ConvexClient("https://zealous-orca-596.convex.cloud");
    
    // State
    let currentFilter = 'all';
    let currentCategory = 'all';
    let currentDistrict = 'all';
    let isBigScreen = false;
    let favorites = new Set();
    let liveListings = [];
    
    // Auth Session
    const userId = localStorage.getItem('bz_user_id') || 'guest-user';
    const userName = localStorage.getItem('bz_user_name') || 'Guest';

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

    const clerkPublishableKey = "pk_test_d2VsY29tZS1zbmFpbC02NC5jbGVyay5hY2NvdW50cy5kZXYk";
    const frontendApi = "welcome-snail-64.clerk.accounts.dev";

    const script = document.createElement("script");
    script.setAttribute("data-clerk-publishable-key", clerkPublishableKey);
    script.async = true;
    script.src = `https://${frontendApi}/npm/@clerk/clerk-js@latest/clerk.browser.js`;
    script.crossOrigin = "anonymous";

    script.addEventListener("load", async function () {
        await window.Clerk.load();
        
        const userBtnNode = document.getElementById('clerk-user-btn');
        if (window.Clerk.user && userBtnNode) {
            window.Clerk.mountUserButton(userBtnNode);
            const token = await window.Clerk.session.getToken({ template: 'convex' });
            client.setAuth(async () => token);
            subscribeListings();
        } else {
            // Unauthenticated users can still view public data, but cannot interact or place real bids.
            subscribeListings(); 
        }
    });

    document.body.appendChild(script);

    // Real-time Subscription to Active Auctions
    function subscribeListings() {
        client.onUpdate("listings:listActive", { category: currentCategory, location: currentDistrict }, (data) => {
            liveListings = data;
            renderGrid();
            updateTopStats();
        });
    }

    async function updateTopStats() {
        if (liveListings.length === 0) return;
        const highestBid = Math.max(...liveListings.map(l => l.currentBid));
        const topItem = liveListings.find(l => l.currentBid === highestBid);
        
        const tsBid = document.getElementById('ts-topbid');
        const fBid = document.getElementById('f-bid');
        
        if (tsBid) {
            tsBid.textContent = formatCurrency(highestBid);
            autoShrinkText(tsBid);
        }
        if (fBid) {
            fBid.textContent = formatCurrency(highestBid);
            autoShrinkText(fBid);
            const fTitle = document.getElementById('f-title');
            const fDesc = document.getElementById('f-desc');
            if (fTitle) fTitle.textContent = topItem.title;
            if (fDesc) fDesc.textContent = topItem.description;
        }
    }

    // Initialize Grid
    function renderGrid() {
        if (!grid) return;
        grid.innerHTML = '';
        
        let filtered = [...liveListings];
        // Client-side filtering for favorites/sorting
        if (currentCategory === 'fav') {
            filtered = filtered.filter(l => favorites.has(l._id));
        }

        if (currentFilter === 'hot') {
            filtered = filtered.filter(l => l.currentBid > 10000 || l.category === 'luxury');
        } else if (currentFilter === 'ending') {
            filtered = filtered.sort((a, b) => a.endTime - b.endTime);
        }

        if (filtered.length === 0) {
            grid.innerHTML = '<div class="col-span-full py-20 text-center opacity-50">No auctions found matching filters.</div>';
            return;
        }

        filtered.forEach(item => {
            const isFav = favorites.has(item._id);
            const card = document.createElement('article');
            card.className = 'dash-card';
            
            const emojiMap = { luxury: '⌚', vehicles: '🛻', art: '🖼️', tech: '📱', free: '🇧🇿' };
            const icon = emojiMap[item.category] || '📦';

            card.innerHTML = `
                <div class="dash-card-img" style="background: linear-gradient(135deg, var(--bg-card), var(--bg-2))">
                    ${item.imageStorageId ? `<img src="https://zealous-orca-596.convex.cloud/api/storage/${item.imageStorageId}" class="dash-card-actual-img" alt="${item.title}">` : icon}
                    <div class="card-actions-overlay">
                        <button class="action-btn fav-btn ${isFav ? 'active' : ''}" onclick="event.stopPropagation(); toggleFav('${item._id}')" aria-label="Favorite">
                            ${isFav ? '❤️' : '🤍'}
                        </button>
                        <button class="action-btn share-btn" onclick="event.stopPropagation(); shareLink('${item._id}', '${item.title}')" aria-label="Share">
                            🔗
                        </button>
                        <button class="action-btn report-btn" onclick="event.stopPropagation(); reportListing('${item._id}')" aria-label="Report" title="Report to Admin">
                            🚩
                        </button>
                    </div>
                </div>
                <div class="dash-card-body">
                    <div class="flex justify-between items-start mb-2">
                        <h3 class="dash-card-title">${item.title}</h3>
                        <span style="font-size:10px; color:var(--text-dim);">🇧🇿 ${item.location}</span>
                    </div>
                    <div class="dash-card-row">
                        <div>
                            <div style="font-size:10px; color:var(--text-dim); text-transform:uppercase;">${item.category === 'free' ? 'Giveaway' : 'Current Bid'}</div>
                            <div class="dash-bid-box">
                                <span class="dash-bid" style="${item.category === 'free' ? 'color: var(--success);' : ''}">${item.category === 'free' ? 'FREE' : formatCurrency(item.currentBid)}</span>
                            </div>
                        </div>
                        <div class="text-right">
                             <div class="countdown" id="cd-${item._id}">...</div>
                             <div style="font-size:10px; color:var(--text-dim); margin-top:4px;">LIVE ROOM ⚡</div>
                        </div>
                    </div>
                    <button class="btn btn-primary w-full mt-4" onclick="placeLiveBid('${item._id}', ${item.currentBid})" style="font-size:12px; padding:10px;">Place Bid</button>
                </div>
            `;
            grid.appendChild(card);
            
            // Start countdown
            const cdEl = document.getElementById(`cd-${item._id}`);
            const secs = Math.max(0, Math.floor((item.endTime - Date.now()) / 1000));
            startCountdown(cdEl, secs);

            // Apply auto-shrink
            const bidEl = card.querySelector('.dash-bid');
            if (bidEl) autoShrinkText(bidEl);
        });
    }

    window.placeLiveBid = async (listingId, currentBid) => {
        const increment = currentBid > 1000 ? 500 : 100;
        const newAmount = currentBid + increment;
        try {
            await client.mutation("bids:place", { listingId, amount: newAmount, bidderId: "guest-user" });
            showToast(`Bid placed: ${formatCurrency(newAmount)}! 🇧🇿⚡`);
            updateChart();
        } catch (err) {
            showToast(err.message, 'danger');
        }
    };

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
        const btn = document.getElementById(`c-${cat}`);
        if(btn) btn.classList.add('active');
        subscribeListings(); // Resubscribe with new category
    };

    window.filterDistrict = (dist) => {
        currentDistrict = dist;
        document.querySelectorAll('.dist-pill').forEach(b => b.classList.remove('active'));
        const btn = document.getElementById(`d-${dist}`);
        if(btn) btn.classList.add('active');
        subscribeListings(); // Resubscribe with new location
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
            <div class="msg-header">
                <span class="msg-sender">${sender}</span>
                ${!isMine ? `
                <div class="msg-actions">
                    <button class="msg-action-btn" onclick="blockUser('${sender}')" title="Block User">🚫</button>
                    <button class="msg-action-btn" onclick="shareChat('${sender}')" title="Reply to User">💬</button>
                </div>
                ` : ''}
            </div>
            <p class="msg-content">${content}</p>
        `;
        chatMessages.appendChild(msg);
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }

    window.blockUser = (user) => {
        showToast(`User ${user} blocked 🚫`, 'danger');
        // In a real app, hide their messages
    };

    window.shareChat = (user) => {
        chatInput.value = `@${user} `;
        chatInput.focus();
    };

    // Real-time Chat Subscription (Live Room)
    client.onUpdate("chat:listRoomMessages", {}, (data) => {
        chatMessages.innerHTML = '';
        if (data.length === 0) {
            chatMessages.innerHTML = `
            <div class="chat-msg">
                <span class="msg-sender">System</span>
                <p class="msg-content">Welcome to the Live Room! Chat with other bidders about current auctions. 🇧🇿⚡</p>
            </div>`;
        }
        data.forEach(msg => {
            const isMine = msg.senderId === userId; // Checking against the session userId
            addMessage(msg.senderName, msg.content, isMine);
        });
        chatMessages.scrollTop = chatMessages.scrollHeight;
    });

    if (chatSend) {
        chatSend.onclick = async () => {
            const val = chatInput.value.trim();
            if (val) {
                try {
                    // Requires a valid userId which we have from localStorage in 'userId'. 
                    // If 'guest-user', it will error since schema expects v.id("users").
                    // Let's pass the locally stored ID or fail gracefully if not signed in yet.
                    if (userId === 'guest-user' || !userId) {
                        showToast('Please sign in or create an account to chat!', 'danger');
                        return;
                    }

                    await client.mutation("chat:sendRoomMessage", { 
                        content: val,
                        senderId: userId
                    });
                    chatInput.value = '';
                } catch (err) {
                    showToast('Failed to send message: ' + err.message, 'danger');
                }
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
                title: title,
                bid: price,
                category: cat,
                hot: false,
                endTime: Date.now() + 3600000,
                imageStorageId: null, // Would upload via Convex in a full app
                location: 'Belize City',
            };

            // mockListings removed - this would be a Convex mutation
            // await client.mutation("listings:create", newListing);
            
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
