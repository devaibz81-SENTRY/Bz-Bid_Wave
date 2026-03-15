"use client";

import React from "react";
import Link from "next/link";

export default function DownloadPage() {
  return (
    <div className="min-h-screen relative z-10 font-sans flex flex-col items-center justify-center p-6 text-center">
      <div className="max-w-2xl w-full glass-panel p-12 rounded-[40px] border-primary/20">
        <div className="w-20 h-20 bg-primary/10 rounded-2xl flex items-center justify-center text-4xl mb-8 mx-auto">
          📱
        </div>
        
        <h1 className="font-syne text-5xl font-black mb-6 uppercase tracking-tight">
          GET THE <span className="gold-text">APP</span>
        </h1>
        
        <p className="text-slate-400 text-lg mb-10 leading-relaxed">
          The full BZ BidWave experience is now in your pocket. Real-time notifications, biometrics, and the fastest bidding in Belize.
        </p>

        <div className="flex flex-col gap-4">
          <a 
            href="https://github.com/devaibz81-SENTRY/Bz-Bid_Wave/releases/latest" 
            target="_blank"
            className="btn-gold btn-lg text-lg py-5"
          >
            Download v1.0.0 APK
          </a>
          <p className="text-[10px] text-slate-500 uppercase tracking-[0.2em] font-bold">
            v1.0.0 · Stable Production Build 🇧🇿
          </p>
        </div>

        <div className="mt-12 p-6 bg-slate-900/40 rounded-2xl border border-slate-800 text-left">
          <h3 className="text-xs font-bold uppercase tracking-widest text-primary mb-3">Install Instructions</h3>
          <ul className="text-xs text-slate-500 space-y-3">
             <li className="flex gap-2"><span>1.</span> Download the APK file directly to your Android device.</li>
             <li className="flex gap-2"><span>2.</span> Open the file. If prompted, allow "Install from Unknown Sources".</li>
             <li className="flex gap-2"><span>3.</span> Sign in with your BZ BidWave account and start winning.</li>
          </ul>
        </div>
        
        <Link href="/" className="mt-10 inline-block text-xs uppercase tracking-widest font-bold text-slate-500 hover:text-white transition-colors">
          ← Back to World Portal
        </Link>
      </div>
    </div>
  );
}
