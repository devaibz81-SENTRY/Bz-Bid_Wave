"use client";

import React, { useEffect, useState } from "react";
import Link from "next/link";

export default function LandingPage() {
  const [scrolled, setScrolled] = useState(false);

  useEffect(() => {
    const handleScroll = () => setScrolled(window.scrollY > 50);
    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  return (
    <div className="min-h-screen relative z-10">
      {/* Navigation */}
      <nav className={`fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${scrolled ? 'glass-panel py-3' : 'py-6 px-10'}`}>
        <div className="max-w-7xl mx-auto flex items-center justify-between px-6">
          <Link href="/" className="font-syne text-2xl font-black flex items-center gap-2">
            BID<span className="gold-text">WAVE</span>
          </Link>
          
          <div className="hidden md:flex items-center gap-8">
            <Link href="#features" className="text-sm font-medium text-slate-400 hover:text-white transition-colors">Marketplace</Link>
            <Link href="#how-it-works" className="text-sm font-medium text-slate-400 hover:text-white transition-colors">How it Works</Link>
            <Link href="/onboarding" className="btn-gold">Get Started</Link>
          </div>
        </div>
      </nav>

      {/* Hero Section */}
      <section className="pt-40 pb-32 px-6">
        <div className="max-w-7xl mx-auto grid lg:grid-cols-2 gap-16 items-center">
          <div>
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-slate-800/50 border border-slate-700/50 mb-6">
              <span className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
              <span className="text-[10px] font-bold uppercase tracking-widest text-slate-400">Live in Belize 🇧🇿</span>
            </div>
            
            <h1 className="font-syne text-6xl lg:text-8xl font-black leading-[0.9] mb-8">
              BID HIGH. <br />
              <span className="gold-text">WIN BIG.</span>
            </h1>
            
            <p className="text-xl text-slate-400 max-w-lg mb-10 leading-relaxed">
              Experience the adrenaline of real-time auctions. A premium, secure platform designed for Belize's most exclusive listings.
            </p>
            
            <div className="flex flex-wrap gap-4">
              <Link href="/onboarding" className="btn-gold btn-lg">Browse Auctions</Link>
              <Link href="/download" className="btn-outline btn-lg">Download App</Link>
            </div>

            <div className="mt-16 flex items-center gap-8 border-t border-slate-800 pt-10">
              <div>
                <div className="text-3xl font-syne font-bold">1.2k+</div>
                <div className="text-xs text-slate-500 uppercase tracking-wider font-bold">Active Bidders</div>
              </div>
              <div>
                <div className="text-3xl font-syne font-bold">$4.5M</div>
                <div className="text-xs text-slate-500 uppercase tracking-wider font-bold">Volume Handled</div>
              </div>
            </div>
          </div>

          <div className="relative">
            <div className="glass-card p-2 rounded-[32px] overflow-hidden rotate-2 hover:rotate-0 transition-transform duration-500">
              <img 
                src="https://images.unsplash.com/photo-1554118811-1e0d58224f24?auto=format&fit=crop&q=80&w=800"
                alt="Luxury Item"
                className="rounded-[24px] w-full h-[600px] object-cover"
              />
              <div className="absolute inset-0 bg-gradient-to-t from-black via-transparent to-transparent"></div>
              
              <div className="absolute bottom-8 left-8 right-8 p-6 glass-panel rounded-2xl border-primary/20">
                <div className="flex justify-between items-end">
                  <div>
                    <div className="text-[10px] uppercase tracking-widest text-primary font-bold mb-1">Current Highest Bid</div>
                    <div className="text-3xl font-syne font-black">$24,500.00</div>
                  </div>
                  <div className="bg-emerald-500/20 text-emerald-400 px-3 py-1 rounded-lg text-xs font-bold border border-emerald-500/30">
                    Live Session
                  </div>
                </div>
              </div>
            </div>
            
            {/* Decorative elements */}
            <div className="absolute -top-10 -right-10 w-40 h-40 bg-gold-500/10 blur-[100px] rounded-full"></div>
            <div className="absolute -bottom-10 -left-10 w-60 h-60 bg-primary/20 blur-[120px] rounded-full"></div>
          </div>
        </div>
      </section>

      {/* Feature Section */}
      <section className="py-32 px-6 border-t border-slate-900 bg-slate-950/30" id="features">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-20">
            <h2 className="font-syne text-4xl font-bold mb-4">Elite <span className="gold-text">Tech</span> for Elite Bidding</h2>
            <p className="text-slate-500 max-w-xl mx-auto tracking-wide">Built on Convex real-time streams and Clerk ultra-secure authentication.</p>
          </div>

          <div className="grid md:grid-cols-3 gap-8">
            <div className="glass-card p-10">
              <div className="w-12 h-12 bg-primary/20 rounded-xl flex items-center justify-center mb-6 text-primary">
                 <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="m12 14 4-4 4 4"/><path d="M3.34 19a10 10 0 1 1 17.32 0"/></svg>
              </div>
              <h3 className="text-xl font-bold mb-3">Latency-Free</h3>
              <p className="text-sm text-slate-500 leading-relaxed">Milliseconds matter. Our Convex-powered stream ensures you see bids as they happen, instantly.</p>
            </div>
            
            <div className="glass-card p-10 mt-8 md:mt-0">
              <div className="w-12 h-12 bg-primary/20 rounded-xl flex items-center justify-center mb-6 text-primary">
                 <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
              </div>
              <h3 className="text-xl font-bold mb-3">Ironclad Auth</h3>
              <p className="text-sm text-slate-500 leading-relaxed">Clerk enterprise-grade security protects your account and your bids with MFA and biometric support.</p>
            </div>

            <div className="glass-card p-10 mt-8 md:mt-0">
              <div className="w-12 h-12 bg-primary/20 rounded-xl flex items-center justify-center mb-6 text-primary">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M12 2v20"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
              </div>
              <h3 className="text-xl font-bold mb-3">Escrow Verified</h3>
              <p className="text-sm text-slate-500 leading-relaxed">Every winning bid is backed by our secure payment gateway, ensuring zero-risk for buyers and sellers.</p>
            </div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="py-20 px-6 border-t border-slate-900">
        <div className="max-w-7xl mx-auto flex flex-col md:flex-row justify-between items-center gap-10">
          <div className="font-syne text-xl font-black">
            BID<span className="gold-text">WAVE</span>
          </div>
          <div className="text-slate-500 text-xs tracking-widest uppercase">
            Built with Passion for the Belizean Marketplace
          </div>
          <div className="flex gap-6">
            <Link href="/tos" className="text-xs text-slate-500 hover:text-white transition-colors">Terms</Link>
            <Link href="/privacy" className="text-xs text-slate-500 hover:text-white transition-colors">Privacy</Link>
          </div>
        </div>
      </footer>
    </div>
  );
}
