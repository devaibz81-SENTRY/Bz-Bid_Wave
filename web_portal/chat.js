import { ConvexClient } from "convex/browser";

document.addEventListener('DOMContentLoaded', () => {
    const client = new ConvexClient("https://zealous-orca-596.convex.cloud");
    const userId = localStorage.getItem('bz_user_id') || 'guest-user';
    const userName = localStorage.getItem('bz_user_name') || 'Guest';

    const chatHistory = document.getElementById('chat-history');
    const chatInput = document.getElementById('chat-main-input');
    const sendBtn = document.getElementById('chat-send-btn');
    
    // Auto-scroll to bottom Function
    const scrollToBottom = () => {
        chatHistory.scrollTop = chatHistory.scrollHeight;
    };

    // Add a message to the UI
    function adduiMessage(senderName, content, timeText, isMine, isSystem = false) {
        const wrapper = document.createElement('div');
        
        if (isSystem) {
            wrapper.className = 'chat-system-msg';
            wrapper.innerHTML = `<i data-lucide="shield" style="width:14px; height:14px;"></i> ${content}`;
            chatHistory.appendChild(wrapper);
            lucide.createIcons({root: wrapper});
            return;
        }

        wrapper.className = `chat-bubble ${isMine ? 'mine' : ''}`;
        
        let avatarHtml = '';
        if (!isMine) {
            const initials = senderName.substring(0, 2).toUpperCase();
            // Use consistent colors for names (mock hash)
            const colors = ['var(--primary)', 'var(--accent)', 'var(--success)', 'var(--bz-red)', 'var(--bz-blue)'];
            const colorIndex = senderName.length % colors.length;
            avatarHtml = `<div class="chat-bubble-avatar" style="background:${colors[colorIndex]}">${initials}</div>`;
        }
        
        const tickHtml = isMine ? `<i data-lucide="check-check" style="width:12px; height:12px; display:inline-block; vertical-align:middle; color:var(--success);"></i>` : '';

        wrapper.innerHTML = `
            ${avatarHtml}
            <div class="chat-bubble-content">
                ${!isMine ? `<span class="chat-bubble-sender">${senderName}</span>` : ''}
                <p>${content}</p>
                <span class="chat-bubble-time">${timeText} ${tickHtml}</span>
            </div>
        `;

        chatHistory.appendChild(wrapper);
        lucide.createIcons({root: wrapper});
    }

    // Subscribe to Live Room
    client.onUpdate("chat:listRoomMessages", {}, (data) => {
        chatHistory.innerHTML = '';
        adduiMessage('System', 'End-to-end encrypted. Messages are kept for 24 hours.', '', false, true);
        
        if (data.length === 0) {
            adduiMessage('System', 'Welcome to the BZ BidWave General chat.', '', false, true);
        } else {
            data.forEach(msg => {
                const isMine = msg.senderId === userId;
                const d = new Date(msg.timestamp);
                const timeText = d.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
                adduiMessage(msg.senderName, msg.content, timeText, isMine);
            });
        }
        scrollToBottom();
    });

    // Send Message
    async function handleSend() {
        const val = chatInput.value.trim();
        if(!val) return;
        
        if (userId === 'guest-user' || !userId) {
            alert("Please sign in to send messages.");
            return;
        }

        chatInput.value = '';
        chatInput.focus();

        try {
            await client.mutation("chat:sendRoomMessage", { 
                content: val, 
                senderId: userId 
            });
        } catch(e) {
            alert("Delivery failed: " + e.message);
        }
    }

    if (sendBtn) {
        sendBtn.addEventListener('click', handleSend);
    }

    chatInput.addEventListener('keypress', (e) => {
        if(e.key === 'Enter') handleSend();
    });

});
