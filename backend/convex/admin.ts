import { v } from "convex/values";
import { mutation, query } from "./_generated/server";

// Report a user/listing
export const report = mutation({
  args: {
    sellerId: v.id("users"),
    listingId: v.optional(v.id("listings")),
    reason: v.string(),
    description: v.string(),
  },
  handler: async (ctx, args) => {
    const identity = await ctx.auth.getUserIdentity();
    if (!identity) return;

    const reporter = await ctx.db.query("users").withIndex("by_clerk_id", q => q.eq("clerkId", identity.subject)).unique();
    if (!reporter) return;

    await ctx.db.insert("reports", {
      reporterId: reporter._id,
      sellerId: args.sellerId,
      listingId: args.listingId,
      reason: args.reason,
      description: args.description,
      status: "pending",
      timestamp: Date.now(),
    });
  },
});

// Admin Login Simulation (Placeholder for real auth)
export const adminLogin = mutation({
  args: { password: v.string() },
  handler: async (ctx, args) => {
    // In a real app, this should be a hashed comparison or use Clerk roles
    // For this prototype, we're using the user-requested "strong password"
    const ADMIN_PW = "BZ_BidWave_2024_Admin_Secure_X9!"; 
    if (args.password === ADMIN_PW) {
      return { success: true, token: "admin-session-placeholder" };
    }
    return { success: false };
  },
});

// List all reports for admin
export const listPendingReports = query({
  args: {},
  handler: async (ctx) => {
    return await ctx.db
      .query("reports")
      .withIndex("by_status", (q) => q.eq("status", "pending"))
      .order("desc")
      .collect();
  },
});

export const createSeedUser = mutation({
    args: {
        name: v.string(),
        email: v.string(),
        clerkId: v.string(),
    },
    handler: async (ctx, args) => {
        const existing = await ctx.db.query("users").withIndex("by_clerk_id", q => q.eq("clerkId", args.clerkId)).unique();
        if (existing) return existing._id;
        return await ctx.db.insert("users", args);
    }
});
