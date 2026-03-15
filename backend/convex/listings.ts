import { mutation, query } from "./_generated/server";
import { v } from "convex/values";

// List all active auctions, optionally filtered by category
export const listActive = query({
  args: { category: v.optional(v.string()) },
  handler: async (ctx, args) => {
    let q = ctx.db.query("listings")
      .withIndex("by_status", (q) => q.eq("status", "active"));

    if (args.category && args.category !== "all") {
      q = q.filter((q) => q.eq(q.field("category"), args.category));
    }

    return await q.order("desc").collect();
  },
});

// Get a single listing by ID with its bid history
export const get = query({
  args: { id: v.id("listings") },
  handler: async (ctx, args) => {
    const listing = await ctx.db.get(args.id);
    if (!listing) return null;

    const bids = await ctx.db
      .query("bids")
      .withIndex("by_listing", (q) => q.eq("listingId", args.id))
      .order("desc")
      .collect();

    return { ...listing, bids };
  },
});

// Generate a secure upload URL for photos
export const generateUploadUrl = mutation(async (ctx) => {
  return await ctx.storage.generateUploadUrl();
});

// Create a new listing
export const create = mutation({
  args: {
    title: v.string(),
    description: v.string(),
    startingPrice: v.number(),
    durationMinutes: v.number(),
    sellerId: v.id("users"),
    category: v.string(), // "luxury", "tech", "free", etc.
    imageStorageId: v.optional(v.string()),
  },
  handler: async (ctx, args) => {
    const endTime = Date.now() + args.durationMinutes * 60 * 1000;
    
    return await ctx.db.insert("listings", {
      title: args.title,
      description: args.description,
      startingPrice: args.startingPrice,
      currentBid: args.startingPrice,
      endTime,
      sellerId: args.sellerId,
      category: args.category,
      status: "active",
      imageStorageId: args.imageStorageId,
    });
  },
});
