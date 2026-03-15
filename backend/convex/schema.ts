import { defineSchema, defineTable } from "convex/server";
import { v } from "convex/values";

export default defineSchema({
  users: defineTable({
    name: v.string(),
    email: v.string(),
    clerkId: v.string(), // Link to Clerk auth
    photoUrl: v.optional(v.string()),
  }).index("by_clerk_id", ["clerkId"]),

  listings: defineTable({
    title: v.string(),
    description: v.string(),
    startingPrice: v.number(),
    currentBid: v.number(),
    endTime: v.number(), // Unix timestamp
    sellerId: v.id("users"),
    category: v.string(), // e.g., "luxury", "tech", "free"
    status: v.union(v.literal("active"), v.literal("completed")),
    imageStorageId: v.optional(v.string()), // For photo hosting
  }).index("by_status", ["status"]).index("by_category", ["category"]),

  bids: defineTable({
    listingId: v.id("listings"),
    bidderId: v.id("users"),
    amount: v.number(),
    timestamp: v.number(),
  }).index("by_listing", ["listingId"]),

  messages: defineTable({
    senderId: v.id("users"),
    content: v.string(),
    listingId: v.optional(v.id("listings")), // Optional: for item-specific chat
    timestamp: v.number(),
  }).index("by_timestamp", ["timestamp"]),

  comments: defineTable({
    listingId: v.id("listings"),
    userId: v.id("users"),
    content: v.string(),
    timestamp: v.number(),
  }).index("by_listing", ["listingId"]),

  favorites: defineTable({
    userId: v.id("users"),
    listingId: v.id("listings"),
  }).index("by_user", ["userId"]),

  reports: defineTable({
    reporterId: v.id("users"),
    sellerId: v.id("users"),
    listingId: v.optional(v.id("listings")),
    reason: v.string(),
    description: v.string(),
    status: v.union(v.literal("pending"), v.literal("resolved")),
    timestamp: v.number(),
  }).index("by_status", ["status"]).index("by_seller", ["sellerId"]),
});
