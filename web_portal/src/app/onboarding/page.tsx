"use client";

import React, { useState } from "react";
import Link from "next/link";

export default function OnboardingPage() {
  const [step, setStep] = useState(1);
  const [role, setRole] = useState("bidder");

  const nextStep = () => setStep((s) => Math.min(s + 1, 3));
  const prevStep = () => setStep((s) => Math.max(s - 1, 1));

  return (
    <div className="min-h-screen relative z-10 font-sans">
      <nav className="p-10 flex items-center justify-between">
        <Link href="/" className="font-syne text-xl font-black flex items-center gap-2">
          BID<span className="gold-text">WAVE</span>
        </Link>
        <Link href="/" className="btn-outline text-xs">← Back to Home</Link>
      </nav>

      <main className="max-w-6xl mx-auto px-6 py-12">
        <div className="grid lg:grid-cols-2 gap-12 glass-panel rounded-3xl overflow-hidden min-h-[600px]">
          {/* Left Info Column */}
          <div className="p-12 bg-slate-900/40 border-r border-slate-800 hidden lg:flex flex-col justify-between">
            <div>
              <div className="inline-block px-3 py-1 rounded-full bg-primary/10 border border-primary/20 text-[10px] font-bold text-primary tracking-widest uppercase mb-6">
                Phase One Launch
              </div>
              <h1 className="font-syne text-5xl font-black leading-[1.1] mb-6">
                THE FUTURE OF<br />
                <span className="gold-text uppercase">Belizean</span><br />
                AUCTIONS.
              </h1>
              <p className="text-slate-400 leading-relaxed mb-10 max-w-sm">
                Join the first open bidding platform designed specifically for Belize. Secure, transparent, and real-time.
              </p>
              
              <div className="space-y-6">
                <div className="flex gap-4">
                  <div className="w-10 h-10 rounded-lg bg-slate-800 flex items-center justify-center text-xl">⚡</div>
                  <div>
                    <h3 className="font-bold text-sm">Instant Bids</h3>
                    <p className="text-xs text-slate-500">Real-time updates across the country.</p>
                  </div>
                </div>
                <div className="flex gap-4">
                  <div className="w-10 h-10 rounded-lg bg-slate-800 flex items-center justify-center text-xl">🔒</div>
                  <div>
                    <h3 className="font-bold text-sm">Verified Sellers</h3>
                    <p className="text-xs text-slate-500">Trusted local partners and fair play.</p>
                  </div>
                </div>
              </div>
            </div>
            
            <div className="text-[10px] uppercase tracking-widest text-slate-500 font-bold">
              🇧🇿 Proudly built in Belize for Belizeans.
            </div>
          </div>

          {/* Right Flow Column */}
          <div className="p-12 flex flex-col items-center justify-center">
            {/* Progress */}
            <div className="flex gap-2 mb-12">
              {[1, 2, 3].map((s) => (
                <div 
                  key={s}
                  className={`w-12 h-1 ${s <= step ? 'bg-primary' : 'bg-slate-800'} rounded-full transition-colors`}
                />
              ))}
            </div>

            <div className="w-full max-w-sm">
              {step === 1 && (
                <div className="animate-in fade-in slide-in-from-bottom-4 duration-500">
                  <h2 className="font-syne text-3xl font-bold mb-2">Create Account</h2>
                  <p className="text-slate-400 text-sm mb-10">Enter your details to get started with BZ BidWave.</p>
                  
                  {/* Placeholder for Clerk UI */}
                  <div className="glass-card p-8 text-center border-dashed border-slate-700">
                    <p className="text-xs text-slate-500 mb-6">Secure Authentication via Clerk</p>
                    <button onClick={nextStep} className="btn-gold w-full">Sign Up with Email</button>
                    <div className="mt-4 text-[10px] text-slate-500">
                      Already have an account? <span className="text-primary cursor-pointer">Sign In</span>
                    </div>
                  </div>
                  
                  <p className="mt-8 text-[10px] text-slate-500 text-center leading-relaxed">
                    By signing up, you agree to the <span className="text-slate-300">Terms of Service</span> and <span className="text-slate-300">Privacy Policy</span>. You agree to be legally bound to pay for any winning bids.
                  </p>
                </div>
              )}

              {step === 2 && (
                <div className="animate-in fade-in slide-in-from-bottom-4 duration-500">
                  <h2 className="font-syne text-3xl font-bold mb-2">Your Profile</h2>
                  <p className="text-slate-400 text-sm mb-10">How should we identify you in the arena?</p>
                  
                  <div className="space-y-6">
                    <div>
                      <label className="text-[10px] uppercase tracking-widest font-bold text-slate-500 block mb-2">Display Name</label>
                      <input 
                        type="text" 
                        className="w-full bg-slate-900/50 border border-slate-800 rounded-xl px-4 py-3 text-sm focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-all"
                        placeholder="e.g. BZ_Bidder_01"
                      />
                    </div>

                    <div>
                      <label className="text-[10px] uppercase tracking-widest font-bold text-slate-500 block mb-2">Primary Role</label>
                      <div className="grid grid-cols-2 gap-3">
                        <div 
                          onClick={() => setRole("bidder")}
                          className={`p-4 rounded-xl border cursor-pointer transition-all ${role === 'bidder' ? 'bg-primary/10 border-primary' : 'bg-slate-900/50 border-slate-800'}`}
                        >
                          <div className="text-xl mb-2">🔨</div>
                          <div className="font-bold text-xs">Bidder</div>
                          <div className="text-[9px] text-slate-500">I want to buy</div>
                        </div>
                        <div 
                          onClick={() => setRole("seller")}
                          className={`p-4 rounded-xl border cursor-pointer transition-all ${role === 'seller' ? 'bg-primary/10 border-primary' : 'bg-slate-900/50 border-slate-800'}`}
                        >
                          <div className="text-xl mb-2">🏷️</div>
                          <div className="font-bold text-xs">Seller</div>
                          <div className="text-[9px] text-slate-500">I want to sell</div>
                        </div>
                      </div>
                    </div>

                    <div className="flex gap-3 pt-4">
                      <button onClick={prevStep} className="btn-outline flex-1">Back</button>
                      <button onClick={nextStep} className="btn-gold flex-1">Continue →</button>
                    </div>
                  </div>
                </div>
              )}

              {step === 3 && (
                <div className="animate-in fade-in slide-in-from-bottom-4 duration-500">
                  <h2 className="font-syne text-3xl font-bold mb-2">Interests</h2>
                  <p className="text-slate-400 text-sm mb-10">Select categories you're interested in.</p>
                  
                  <div className="flex wrap gap-2">
                    {["Luxury ⌚", "Vehicles 🚗", "Real Estate 🏠", "Electronics 💻", "Collectibles 🎨", "Land 🇧🇿", "Industrial 🚜"].map((cat) => (
                      <div key={cat} className="px-3 py-2 rounded-lg bg-slate-900 border border-slate-800 text-xs hover:border-primary/50 cursor-pointer transition-colors">
                        {cat}
                      </div>
                    ))}
                  </div>
                  
                  <Link href="/dashboard" className="btn-gold btn-lg w-full mt-12 text-center">Complete Setup 🇧🇿</Link>
                </div>
              )}
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
