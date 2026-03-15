import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const BidWaveApp());
}

class BidWaveApp extends StatelessWidget {
  const BidWaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BZ BidWave',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF04040A),
        primaryColor: const Color(0xFF8B5CF6),
        textTheme: GoogleFonts.spaceGroteskTextTheme(ThemeData.dark().textTheme),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Background Gradient Spot
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF8B5CF6).withOpacity(0.1),
              ),
            ),
          ),
          
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'BZ BIDWAVE',
                              style: GoogleFonts.syne(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFCE1126).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(color: const Color(0xFFCE1126).withOpacity(0.3)),
                              ),
                              child: const Text('LIVE 🇧🇿', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFCE1126))),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text('100% Belizean Marketplace', style: TextStyle(color: Colors.white38, fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 32),
                        
                        // Featured Card (Editorial Style)
                        _buildFeaturedCard(),
                        
                        const SizedBox(height: 48),
                        Text(
                          'MARKETPLACE',
                          style: GoogleFonts.syne(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                            color: Colors.white54,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildAuctionItem('Toyota Hilux 2024', '\$45,000', '🛻', 'VEHICLES'),
                      _buildAuctionItem('Luxury Timepiece', '\$4,350', '⌚', 'LUXURY'),
                      _buildAuctionItem('Mahogany Art', '\$1,200', '🎨', 'ART'),
                      _buildAuctionItem('iPhone 15 Pro', '\$1,100', '📱', 'TECH'),
                      const SizedBox(height: 100), // Spacing for bottom sash
                    ]),
                  ),
                ),
              ],
            ),
          ),

          // National Sash Footer (aligned with Web)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF0A0A12).withOpacity(0.9),
                border: const Border(top: BorderSide(color: Colors.white10)),
              ),
              child: Stack(
                children: [
                   // Sash Stripe
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 3,
                    child: Row(
                      children: [
                        Expanded(child: Container(color: const Color(0xFF003F87))),
                        Expanded(child: Container(color: const Color(0xFFCE1126))),
                        Expanded(child: Container(color: const Color(0xFF003F87))),
                      ],
                    ),
                  ),
                  Center(
                    child: Text(
                      'BELMOPAN • BELIZE CITY • SAN PEDRO',
                      style: GoogleFonts.syne(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white24),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF8B5CF6),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget _buildFeaturedCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E1E2E), Color(0xFF04040A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('TOP BID TODAY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF8B5CF6), letterSpacing: 1.5)),
          const SizedBox(height: 8),
          Text(
            '\$45,000.00',
            style: GoogleFonts.syne(fontSize: 42, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -2),
          ),
          const SizedBox(height: 4),
          const Text('2024 Toyota Hilux — Belize City', style: TextStyle(color: Colors.white54, fontSize: 13)),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('Place Bid →', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildAuctionItem(String title, String bid, String icon, String cat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white05),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(child: Text(icon, style: const TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cat, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white38, letterSpacing: 1)),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(bid, style: GoogleFonts.syne(fontWeight: FontWeight.w800, color: const Color(0xFF8B5CF6))),
              ],
            ),
          ),
          const Icon(Icons.favorite_border, size: 18, color: Colors.white24),
        ],
      ),
    );
  }
}

