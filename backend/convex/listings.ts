import { mutation, query } from "./_generated/server";
import { v } from "convex/values";

// List all active auctions, optionally filtered by category and location
export const listActive = query({
  args: { 
    category: v.optional(v.string()),
    location: v.optional(v.string())
  },
  handler: async (ctx, args) => {
    let q = ctx.db.query("listings")
      .withIndex("by_status", (q) => q.eq("status", "active"));

    if (args.category && args.category !== "all") {
      q = q.filter((q) => q.eq(q.field("category"), args.category));
    }

    if (args.location && args.location !== "all") {
      q = q.filter((q) => q.eq(q.field("location"), args.location));
    }

    return await q.order("desc").collect();
  },
});

// ... existing get and generateUploadUrl ...

// Create a new listing
export const create = mutation({
  args: {
    title: v.string(),
    description: v.string(),
    startingPrice: v.number(),
    durationMinutes: v.number(),
    sellerId: v.id("users"),
    category: v.string(), // "luxury", "tech", "free", etc.
    location: v.string(), // "Belize", "Cayo", etc.
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
      location: args.location,
      status: "active",
      imageStorageId: args.imageStorageId,
    });
  },
});
