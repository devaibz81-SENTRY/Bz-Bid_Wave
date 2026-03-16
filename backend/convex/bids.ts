import { mutation, query } from "./_generated/server";
import { v } from "convex/values";

// Get bids for a listing
export const getByListing = query({
  args: { listingId: v.id("listings") },
  handler: async (ctx, args) => {
    return await ctx.db.query("bids")
      .withIndex("by_listing", (q) => q.eq("listingId", args.listingId))
      .order("desc")
      .collect();
  },
});

// Get user's bids
export const getByBidder = query({
  args: { bidderId: v.id("users") },
  handler: async (ctx, args) => {
    const allBids = await ctx.db.query("bids").collect();
    return allBids.filter(b => b.bidderId === args.bidderId);
  },
});

export const place = mutation({
  args: {
    listingId: v.id("listings"),
    bidderId: v.id("users"),
    amount: v.number(),
  },
  handler: async (ctx, args) => {
    const listing = await ctx.db.get(args.listingId);
    
    if (!listing) {
      throw new Error("Listing not found");
    }

    if (listing.status !== "active") {
      throw new Error("This auction has already ended");
    }

    if (Date.now() > listing.endTime) {
      // Auto-close if time expired but status was still active
      await ctx.db.patch(args.listingId, { status: "completed" });
      throw new Error("This auction has ended");
    }

    if (args.amount <= listing.currentBid) {
      throw new Error(`Bid must be higher than the current bid of ${listing.currentBid}`);
    }

    // Record the bid
    await ctx.db.insert("bids", {
      listingId: args.listingId,
      bidderId: args.bidderId,
      amount: args.amount,
      timestamp: Date.now(),
    });

    // Update the listing's current bid
    await ctx.db.patch(args.listingId, {
      currentBid: args.amount,
    });

    return { success: true, newBid: args.amount };
  },
});
