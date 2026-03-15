import { v } from "convex/values";
import { mutation, query } from "./_generated/server";

// 1. Get or Create a Room (Public Auction Rooms)
export const getOrCreateRoom = mutation({
  args: {
    listingId: v.optional(v.id("listings")),
  },
  handler: async (ctx, args) => {
    // Look for an existing room
    const existing = await ctx.db
      .query("conversations")
      .filter((q) => q.eq(q.field("type"), "room"))
      .collect();

    const match = existing.find(c => c.listingId === args.listingId);
    if (match) return match._id;

    // Create a new room if none exists
    return await ctx.db.insert("conversations", {
      type: "room",
      participantIds: [], // Public room
      listingId: args.listingId,
      lastMessageAt: Date.now(),
    });
  },
});

// 2. Start a Peer Conversation
export const startPeerChat = mutation({
  args: {
    otherUserId: v.id("users"),
    currentUserId: v.id("users"),
  },
  handler: async (ctx, args) => {
    const participants = [args.currentUserId, args.otherUserId].sort();
    
    // Check if it already exists
    const existing = await ctx.db
      .query("conversations")
      .withIndex("by_participant", (q) => q.eq("participantIds", participants))
      .filter(q => q.eq(q.field("type"), "peer"))
      .first();

    if (existing) return existing._id;

    return await ctx.db.insert("conversations", {
      type: "peer",
      participantIds: participants,
      lastMessageAt: Date.now(),
    });
  },
});

// 3. Send Message
export const sendMessage = mutation({
  args: {
    conversationId: v.id("conversations"),
    content: v.string(),
    senderId: v.id("users"),
  },
  handler: async (ctx, args) => {
    const messageId = await ctx.db.insert("messages", {
      conversationId: args.conversationId,
      senderId: args.senderId,
      content: args.content,
      timestamp: Date.now(),
    });

    await ctx.db.patch(args.conversationId, {
      lastMessageAt: Date.now(),
    });

    return messageId;
  },
});

// 4. List Messages for a Conversation
export const listMessages = query({
  args: {
    conversationId: v.id("conversations"),
  },
  handler: async (ctx, args) => {
    const messages = await ctx.db
      .query("messages")
      .withIndex("by_conversation", (q) => q.eq("conversationId", args.conversationId))
      .order("desc")
      .take(50);
      
    // Fetch sender info 
    const enriched = await Promise.all(messages.map(async (msg) => {
        const sender = await ctx.db.get(msg.senderId);
        return {
            ...msg,
            senderName: sender ? sender.name : "Unknown User",
            isGuest: sender ? false : true
        };
    }));
    
    return enriched.reverse();
  },
});

// 5. List Conversations for a User
export const listConversations = query({
  args: {
    userId: v.id("users"),
  },
  handler: async (ctx, args) => {
    const peerGroups = await ctx.db
       .query("conversations")
       .filter(q => q.neq(q.field("type"), "room"))
       .collect();
       
    // Filter locally to ones including the user
    // Convex doesn't natively index checking for array inclusion efficiently in basic plans without custom index setup
    return peerGroups
      .filter(c => c.participantIds.includes(args.userId))
      .sort((a, b) => b.lastMessageAt - a.lastMessageAt);
  },
});

// 6. Ephemeral Purge (Used by Cron)
export const purgeOldMessages = mutation({
  args: {},
  handler: async (ctx) => {
    // 24 Hours Ephemeral rolling log
    const twentyFourHoursAgo = Date.now() - 24 * 60 * 60 * 1000;
    
    const oldMessages = await ctx.db
      .query("messages")
      .withIndex("by_timestamp", (q) => q.lt("timestamp", twentyFourHoursAgo))
      .collect();
      
    let deletedCount = 0;
    for (const msg of oldMessages) {
      await ctx.db.delete(msg._id);
      deletedCount++;
    }
    
    return deletedCount;
  },
});
