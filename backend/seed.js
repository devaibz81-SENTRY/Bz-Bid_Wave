import { ConvexHttpClient } from "convex/browser";
import { api } from "./convex/_generated/api.js";

const client = new ConvexHttpClient("https://zealous-orca-596.convex.cloud");

async function seed() {
    console.log("Seeding data...");
    
    // 1. Create a default user
    const userId = await client.mutation(api.admin.createSeedUser, {
        name: "Marketplace Admin",
        email: "admin@bidwave.bz",
        clerkId: "seed-admin"
    });
    
    const seedListings = [
        { title: '2024 Toyota Hilux GR-S', startingPrice: 45000, category: 'vehicles', location: 'Belize', durationMinutes: 1440, description: 'Brand new Hilux, full options. Located in Belize City.' },
        { title: 'Rolex Submariner Date', startingPrice: 12500, category: 'luxury', location: 'Cayo', durationMinutes: 2880, description: 'Mint condition, papers included. San Ignacio pickup.' },
        { title: 'Local Mahogany Dining Set', startingPrice: 1800, category: 'art', location: 'Orange Walk', durationMinutes: 1000, description: 'Handcrafted in OW. 8-seater.' },
        { title: 'iPhone 15 Pro Max 512GB', startingPrice: 1300, category: 'tech', location: 'Belmopan', durationMinutes: 500, description: 'Sealed box. BTL unlocked.' },
        { title: 'Belizean Flag Canvas Art', startingPrice: 0, category: 'free', location: 'Corozal', durationMinutes: 300, description: 'Beautiful large canvas. Giving away to a proud Belizean!' },
        { title: 'Offshore Fishing Boat', startingPrice: 35000, category: 'luxury', location: 'Stann Creek', durationMinutes: 4320, description: 'Twin engines, ready for the reef. Placencia.' },
        { title: 'Vintage Mayan Pottery Replica', startingPrice: 250, category: 'art', location: 'Toledo', durationMinutes: 720, description: 'Museum quality replicas from PG.' }
    ];

    for (const l of seedListings) {
        await client.mutation(api.listings.create, {
            ...l,
            sellerId: userId,
        });
        console.log(`Added: ${l.title}`);
    }
    
    console.log("Seeding complete! 🇧🇿⚡");
}

seed().catch(console.error);
