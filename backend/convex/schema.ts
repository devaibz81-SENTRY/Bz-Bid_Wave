import { defineSchema, defineTable } from "convex/server";
import { v } from "convex/values";

export default defineSchema({
  users: defineTable({
    name: v.string(),
    email: v.string(),
    passwordHash: v.optional(v.string()), // For simple auth
    clerkId: v.optional(v.string()), // Optional: still supports Clerk migration
    photoUrl: v.optional(v.string()),
  }).index("by_clerk_id", ["clerkId"]).index("by_email", ["email"]),

  listings: defineTable({
    title: v.string(),
    description: v.string(),
    startingPrice: v.number(),
    currentBid: v.number(),
    endTime: v.number(), // Unix timestamp
    sellerId: v.id("users"),
    category: v.string(), // e.g., "luxury", "tech", "free"
    location: v.string(), // Belize, Cayo, etc.
    status: v.union(v.literal("active"), v.literal("completed")),
    imageStorageId: v.optional(v.string()), // For photo hosting
  }).index("by_status", ["status"]).index("by_category", ["category"]).index("by_location", ["location"]),

  bids: defineTable({
    listingId: v.id("listings"),
    bidderId: v.id("users"),
    amount: v.number(),
    timestamp: v.number(),
  }).index("by_listing", ["listingId"]),

  conversations: defineTable({
    type: v.union(v.literal("peer"), v.literal("group"), v.literal("room")),
    participantIds: v.array(v.id("users")), // For peer/group. Room might be empty/all.
    listingId: v.optional(v.id("listings")), // For auction rooms
    lastMessageAt: v.number(),
  }).index("by_participant", ["participantIds"]),

  messages: defineTable({
    senderId: v.id("users"),
    conversationId: v.id("conversations"),
    content: v.string(),
    timestamp: v.number(),
    // Ephemeral DB: messages older than X days will be purged via cron job
    // No permanent storage of logs, used primarily for immediate peer/group interaction
  }).index("by_conversation", ["conversationId"]).index("by_timestamp", ["timestamp"]),

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
