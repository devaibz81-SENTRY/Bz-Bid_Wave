import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:convex/convex.dart';

class EnvironmentConfig {
  static const String clerkPublishableKey = "pk_test_d2VsY29tZS1zbmFpbC02NC5jbGVyay5hY2NvdW50cy5kZXYk";
  static const String convexUrl = "https://zealous-orca-596.convex.cloud";
}

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

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final ConvexClient _convex;
  List<dynamic> _listings = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _convex = ConvexClient(EnvironmentConfig.convexUrl);
    _fetchListings();
  }

  Future<void> _fetchListings() async {
    try {
      final List<dynamic> listings = await _convex.query('listings');
      if (mounted) {
        setState(() {
          _listings = listings;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _convex.dispose();
    super.dispose();
  }

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
                        _isLoading
                            ? const Center(child: CircularProgressIndicator(color: Color(0xFF8B5CF6)))
                            : _error != null
                                ? Center(child: Text('Error: $_error', style: TextStyle(color: Colors.red)))
                                : _listings.isEmpty
                                    ? const Center(child: Text('No listings found', style: TextStyle(color: Colors.white54)))
                                    : Column(
                                        children: [
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
                      ],
                    ),
                  ),
                ),
                
                // Only show the list if we have data and not loading/error
                if (!_isLoading && _error == null && _listings.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        _listings.take(4).map((listing) {
                          // Assuming each listing has: title, price, category, and maybe an icon or image
                          // We'll use placeholder values if fields are missing
                          final title = listing['title'] ?? 'Unknown Item';
                          final price = listing['price'] ?? '\$0';
                          // We don't have an icon field in the backend, so we'll use a default based on category or a fixed icon
                          final category = listing['category'] ?? 'GENERAL';
                          // Map category to an icon (simplified)
                          String icon;
                          switch (category.toLowerCase()) {
                            case 'vehicles':
                              icon = '🚗';
                              break;
                            case 'luxury':
                              icon = '⌚';
                              break;
                            case 'art':
                              icon = '🎨';
                              break;
                            case 'tech':
                              icon = '📱';
                              break;
                            default:
                              icon = '📦';
                          }
                          return _buildAuctionItem(title, price, icon, category);
                        }).toList(),
                      ),
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
                      'COROZAL • ORANGE WALK • BELIZE • CAYO • STANN CREEK • TOLEDO • BELMOPAN',
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
        onPressed: _fetchListings, // Refresh on press
        backgroundColor: const Color(0xFF8B5CF6),
        child: const Icon(Icons.refresh, color: Colors.white),
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
        border: Border.all(color: Colors.white.withOpacity(0.05)),
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

