import { v } from "convex/values";
import { mutation, query } from "./_generated/server";

// Send a message to the marketplace chat
export const send = mutation({
  args: {
    content: v.string(),
    listingId: v.optional(v.id("listings")),
  },
  handler: async (ctx, args) => {
    const identity = await ctx.auth.getUserIdentity();
    if (!identity) {
        // For development/mocking purposes, we'll use a placeholder if not signed in
        // Real production apps should require identity
    }
    
    const senderId = identity?.tokenIdentifier ?? "guest-user";
    
    await ctx.db.insert("messages", {
      senderId: senderId,
      content: args.content,
      listingId: args.listingId,
      timestamp: Date.now(),
    });
  },
});

// List latest messages (last 50)
export const list = query({
  args: {
    listingId: v.optional(v.id("listings")),
  },
  handler: async (ctx, args) => {
    let q = ctx.db.query("messages");
    
    if (args.listingId) {
      q = q.filter(q => q.eq(q.field("listingId"), args.listingId));
    }
    
    return await q
      .order("desc")
      .take(50);
  },
});
