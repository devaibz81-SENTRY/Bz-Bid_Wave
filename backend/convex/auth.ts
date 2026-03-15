import { v } from "convex/values";
import { mutation, query } from "./_generated/server";

// Authenticate and store the user from Clerk
export const storeClerkUser = mutation({
  args: {
    name: v.string(),
    role: v.optional(v.string()),
    tags: v.optional(v.array(v.string())),
  },
  handler: async (ctx, args) => {
    const identity = await ctx.auth.getUserIdentity();
    if (!identity) {
      throw new Error("Called storeClerkUser without Clerk authentication present");
    }

    // Check if user already exists
    const existing = await ctx.db
      .query("users")
      .withIndex("by_clerk_id", (q) => q.eq("clerkId", identity.subject))
      .unique();

    if (existing) {
      // Update existing
      await ctx.db.patch(existing._id, {
        name: args.name,
        photoUrl: identity.pictureUrl,
      });
      return existing._id;
    }

    // Create new user
    return await ctx.db.insert("users", {
      name: args.name,
      email: identity.email ?? "",
      clerkId: identity.subject,
      photoUrl: identity.pictureUrl,
    });
  },
});

// Helper to get current session user data
export const getCurrentUser = query({
  args: {},
  handler: async (ctx) => {
    const identity = await ctx.auth.getUserIdentity();
    if (!identity) return null;
    return await ctx.db
      .query("users")
      .withIndex("by_clerk_id", (q) => q.eq("clerkId", identity.subject))
      .unique();
  },
});
