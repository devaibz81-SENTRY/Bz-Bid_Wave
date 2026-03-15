import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "BidWave — Premium Real-Time Auctions 🇧🇿",
  description: "The fastest, most secure bidding platform in Belize. Experience premium luxury auctions in real-time.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <head>
        {/* Favicon Placeholder */}
        <link rel="icon" href="https://fav.farm/⚖️" />
      </head>
      <body className="antialiased">
        <div className="marble-canvas">
          <div className="marble-vein"></div>
          <div className="marble-vein-2"></div>
        </div>
        {children}
      </body>
    </html>
  );
}
