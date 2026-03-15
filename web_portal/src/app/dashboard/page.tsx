"use client";

import React, { useState } from "react";
import Link from "next/link";

export default function DashboardPage() {
  const [bigScreen, setBigScreen] = useState(false);

  return (
    <div className={`min-h-screen relative z-10 font-sans flex flex-col ${bigScreen ? 'p-0' : ''}`}>
      {/* Top Banner */}
      <div className="h-1 bg-gradient-to-r from-blue-700 via-white to-red-600"></div>

      {/* Header */}
      {!bigScreen && (
        <header className="glass-panel border-b border-white/5 py-4 px-8 sticky top-0 z-50">
          <div className="max-w-7xl mx-auto flex items-center justify-between">
            <Link href="/" className="font-syne text-xl font-black flex items-center gap-2">
              ⚡ BID<span className="gold-text">WAVE</span>
            </Link>
            
            <nav className="hidden md:flex gap-8">
              <Link href="/" className="text-xs font-bold uppercase tracking-wider text-slate-400 hover:text-white">Home</Link>
              <Link href="/dashboard" className="text-xs font-bold uppercase tracking-wider gold-text">Dashboard</Link>
              <Link href="/download" className="text-xs font-bold uppercase tracking-wider text-slate-400 hover:text-white">Download App</Link>
            </nav>

            <div className="flex items-center gap-4">
               <button 
                onClick={() => setBigScreen(!bigScreen)}
                className="btn-outline py-2 px-4 text-[10px] uppercase font-bold tracking-widest"
               >
                 ⛶ Big Screen
               </button>
               <div className="w-8 h-8 rounded-full bg-primary/20 border border-primary/30 flex items-center justify-center text-primary font-bold text-xs">
                 BZ
               </div>
            </div>
          </div>
        </header>
      )}

      <div className="flex-1 flex max-w-[1600px] mx-auto w-full">
        {/* Sidebar */}
        <aside className="w-80 border-r border-white/5 p-8 hidden xl:flex flex-col gap-10">
          <div>
            <div className="text-[10px] uppercase font-black tracking-[0.2em] text-slate-500 mb-6">Market Overview</div>
            <div className="space-y-6">
              <div className="glass-card p-4">
                <div className="text-2xl font-black font-syne">14</div>
                <div className="text-[10px] uppercase text-slate-500 font-bold">Active Auctions</div>
              </div>
              <div className="glass-card p-4">
                <div className="text-2xl font-black font-syne">247</div>
                <div className="text-[10px] uppercase text-slate-500 font-bold">Live Bidders</div>
              </div>
            </div>
          </div>

          <div className="flex-1">
             <div className="text-[10px] uppercase font-black tracking-[0.2em] text-slate-500 mb-6">Live Activity</div>
             <div className="space-y-4">
                {[1,2,3].map(i => (
                  <div key={i} className="flex gap-3 items-start animate-pulse">
                    <div className="w-2 h-2 rounded-full bg-emerald-500 mt-1"></div>
                    <div className="text-[11px] leading-tight">
                      <span className="text-white font-bold">User_{i}42</span> placed a bid on <span className="text-primary font-bold">Toyota Hilux</span>
                    </div>
                  </div>
                ))}
             </div>
          </div>

          <div className="pt-6 border-t border-white/5 text-[10px] font-bold text-slate-500 uppercase tracking-widest text-center">
            🇧🇿 Proudly Belizean
          </div>
        </aside>

        {/* Main Content */}
        <main className="flex-1 p-8 lg:p-12 overflow-y-auto">
          {/* Top Cards */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-12">
            {[
              { label: "Highest Bid", val: "$4,350", icon: "🔥" },
              { label: "Total Bids", val: "247", icon: "⚡" },
              { label: "Volume", val: "$41.2k", icon: "💰" },
              { label: "Won Today", val: "38", icon: "🏆" }
            ].map(stat => (
              <div key={stat.label} className="glass-card p-6 border-l-2 border-l-primary/30">
                <div className="flex justify-between items-start mb-2">
                  <div className="text-[10px] uppercase font-bold text-slate-500 tracking-widest">{stat.label}</div>
                  <div className="text-xl">{stat.icon}</div>
                </div>
                <div className="text-3xl font-black font-syne gold-text">{stat.val}</div>
              </div>
            ))}
          </div>

          {/* Featured */}
          <section className="glass-card p-1 rounded-[32px] mb-12 relative overflow-hidden group">
            <div className="absolute inset-0 bg-gradient-to-br from-primary/10 to-transparent"></div>
            <div className="relative z-10 grid lg:grid-cols-5 gap-0 items-stretch bg-slate-950/40 rounded-[28px]">
              <div className="lg:col-span-2 overflow-hidden">
                <img 
                  src="https://images.unsplash.com/photo-1547991230-516a7c82dd60?auto=format&fit=crop&q=80&w=600"
                  alt="Feature Item"
                  className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-700"
                />
              </div>
              <div className="lg:col-span-3 p-10 flex flex-col justify-between">
                <div>
                   <div className="flex gap-2 mb-4">
                     <span className="bg-red-500/10 text-red-500 text-[9px] font-black uppercase tracking-[0.2em] px-2 py-1 border border-red-500/20 rounded-md">Hot</span>
                     <span className="bg-emerald-500/10 text-emerald-500 text-[9px] font-black uppercase tracking-[0.2em] px-2 py-1 border border-emerald-500/20 rounded-md">Live</span>
                   </div>
                   <h2 className="font-syne text-4xl font-black mb-4 uppercase">Luxury Timepiece Collection</h2>
                   <p className="text-slate-400 text-sm max-w-lg leading-relaxed">Rare vintage watches, authenticated and certified. BZ BidWave's most watched auction this week — exclusive to the Belizean community.</p>
                </div>
                
                <div className="mt-8 flex flex-wrap items-end justify-between gap-6">
                  <div>
                    <div className="text-[10px] uppercase font-bold text-slate-500 mb-1">Current Bid</div>
                    <div className="text-4xl font-syne font-black gold-text">$4,350.00</div>
                  </div>
                  <Link href="/onboarding" className="btn-gold px-12 py-4">Place Bid Now</Link>
                </div>
              </div>
            </div>
          </section>

          {/* Grid Header */}
          <div className="flex flex-col md:flex-row justify-between items-end gap-6 mb-8 border-b border-white/5 pb-8">
            <div>
              <h2 className="font-syne text-2xl font-black uppercase tracking-tight">Marketplace</h2>
              <div className="flex gap-2 mt-4">
                 {["All Districts", "Belize", "Cayo", "Stann Creek"].map(d => (
                   <button key={d} className={`px-4 py-2 rounded-full text-[10px] font-bold uppercase transition-all ${d === 'All Districts' ? 'bg-primary text-black' : 'bg-slate-900 text-slate-500 hover:text-white'}`}>{d}</button>
                 ))}
              </div>
            </div>
            <div className="flex gap-2">
               <button className="btn-outline py-2 px-6 text-[10px] uppercase font-bold tracking-widest bg-slate-900 border-none">Sort: Newest</button>
               <button className="btn-gold py-2 px-6 text-[10px] uppercase font-bold tracking-widest">+ List Item</button>
            </div>
          </div>

          {/* Placeholder Grid */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {[1,2,3,4,5,6].map(i => (
              <div key={i} className="glass-card overflow-hidden group">
                <div className="aspect-video relative overflow-hidden">
                  <img 
                    src={`https://images.unsplash.com/photo-${1500000000000 + (i * 10000000)}?auto=format&fit=crop&q=80&w=400`}
                    alt="Listing"
                    className="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                  />
                  <div className="absolute top-4 right-4 bg-black/60 backdrop-blur px-2 py-1 rounded text-[10px] font-bold">2h 14m left</div>
                </div>
                <div className="p-6">
                   <div className="text-[10px] uppercase font-bold text-primary tracking-widest mb-1">Vehicles</div>
                   <h3 className="font-bold text-lg mb-3">2024 Toyota Hilux Pro</h3>
                   <div className="flex justify-between items-center">
                     <div>
                       <div className="text-[9px] uppercase text-slate-500 font-bold">Current Bid</div>
                       <div className="text-xl font-syne font-black">$45,000</div>
                     </div>
                     <Link href="/onboarding" className="text-[10px] font-bold uppercase gold-text hover:underline">View Auction →</Link>
                   </div>
                </div>
              </div>
            ))}
          </div>
        </main>
      </div>
    </div>
  );
}
