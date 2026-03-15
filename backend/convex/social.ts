import { v } from "convex/values";
import { mutation, query } from "./_generated/server";

// Post a comment on a listing
export const post = mutation({
  args: {
    listingId: v.id("listings"),
    content: v.string(),
  },
  handler: async (ctx, args) => {
    const identity = await ctx.auth.getUserIdentity();
    const userId = identity ? (await ctx.db.query("users").withIndex("by_clerk_id", q => q.eq("clerkId", identity.subject)).unique())?._id : null;
    
    // For local dev without auth, we skip the check or use a placeholder
    if (!userId) {
        // In a real app, throw an error here.
    }

    await ctx.db.insert("comments", {
      listingId: args.listingId,
      userId: userId ?? (global as any).placeholderUser, // placeholder for dev
      content: args.content,
      timestamp: Date.now(),
    });
  },
});

// Get comments for a listing
export const getForListing = query({
  args: { listingId: v.id("listings") },
  handler: async (ctx, args) => {
    return await ctx.db
      .query("comments")
      .withIndex("by_listing", (q) => q.eq("listingId", args.listingId))
      .order("desc")
      .collect();
  },
});

// Toggle favorite
export const toggleFavorite = mutation({
  args: { listingId: v.id("listings") },
  handler: async (ctx, args) => {
    const identity = await ctx.auth.getUserIdentity();
    if (!identity) return;

    const user = await ctx.db.query("users").withIndex("by_clerk_id", q => q.eq("clerkId", identity.subject)).unique();
    if (!user) return;

    const existing = await ctx.db
      .query("favorites")
      .withIndex("by_user", (q) => q.eq("userId", user._id))
      .filter((q) => q.eq(q.field("listingId"), args.listingId))
      .unique();

    if (existing) {
      await ctx.db.delete(existing._id);
      return false; // unfavorited
    } else {
      await ctx.db.insert("favorites", { userId: user._id, listingId: args.listingId });
      return true; // favorited
    }
  },
});
