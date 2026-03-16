import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:convex_flutter/convex_flutter.dart';

class EnvironmentConfig {
  static const String clerkPublishableKey = "pk_test_d2VsY29tZS1zbmFpbC02NC5jbGVyay5hY2NvdW50cy5kZXYk";
  static const String convexUrl = "https://zealous-orca-596.convex.cloud";
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await ConvexClient.initialize(
      ConvexConfig(
        deploymentUrl: EnvironmentConfig.convexUrl,
      ),
    );
  } catch (e) {
    debugPrint('Convex init failed: $e');
  }
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
        scaffoldBackgroundColor: const Color(0xFF0B0F19),
        primaryColor: const Color(0xFFEAB308),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFEAB308),
          secondary: Color(0xFFCA8A04),
          surface: Color(0xFF151C2C),
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      ),
      home: const AppContainer(child: DashboardScreen()),
    );
  }
}

class AppContainer extends StatelessWidget {
  final Widget child;
  const AppContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0B0F19),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: child,
        ),
      ),
    );
  }
}

class MainScaffold extends StatefulWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const ActivityScreen(),
    const AddListingScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF151C2C).withOpacity(0.95),
          border: const Border(top: BorderSide(color: Colors.white10)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_rounded, 'Home'),
                _buildNavItem(1, Icons.local_fire_department_rounded, 'Activity'),
                _buildAddButton(),
                _buildNavItem(3, Icons.chat_bubble_rounded, 'Chat'),
                _buildNavItem(4, Icons.person_rounded, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _currentIndex = index);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => AppContainer(child: _screens[index])),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? const Color(0xFFEAB308) : Colors.white38, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFFEAB308) : Colors.white38,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => AppContainer(child: _screens[2])),
        );
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFEAB308), Color(0xFFCA8A04)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFEAB308).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.black, size: 28),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<dynamic> _listings = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchListings();
  }

  Future<void> _fetchListings() async {
    setState(() => _isLoading = true);
    try {
      final result = await ConvexClient.instance.query('listings', {});
      if (mounted) {
        setState(() {
          _listings = List.from(result ?? []);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
          _listings = _getSampleListings();
        });
      }
    }
  }

  List<Map<String, dynamic>> _getSampleListings() {
    return [
      {'id': '1', 'title': '2024 Toyota Hilux', 'category': 'Vehicles', 'price': 48500, 'currentBid': 48500, 'bidCount': 12, 'imageUrl': 'https://images.unsplash.com/photo-1626668893632-6f3a4466d22f?w=400'},
      {'id': '2', 'title': 'Omega Speedmaster', 'category': 'Watches', 'price': 4350, 'currentBid': 4350, 'bidCount': 8, 'imageUrl': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400'},
      {'id': '3', 'title': 'Beachfront Property', 'category': 'Property', 'price': 275000, 'currentBid': 275000, 'bidCount': 15, 'imageUrl': 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=400'},
      {'id': '4', 'title': 'MacBook Pro M3', 'category': 'Tech', 'price': 3500, 'currentBid': 3500, 'bidCount': 0, 'imageUrl': 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400'},
      {'id': '5', 'title': 'ATV for Trade', 'category': 'Trade', 'price': 0, 'currentBid': 0, 'bidCount': 0, 'imageUrl': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400'},
    ];
  }

  String _formatPrice(double price) {
    return 'BZD \$${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'BZ BIDWAVE',
                                style: GoogleFonts.syne(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFFEAB308),
                                ),
                              ),
                              const Text('100% Belizean Marketplace', style: TextStyle(color: Colors.white38, fontSize: 12)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF22C55E).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFF22C55E).withOpacity(0.3)),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.circle, color: Color(0xFF22C55E), size: 8),
                                SizedBox(width: 6),
                                Text('LIVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF22C55E))),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Search Bar
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF151C2C),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.05)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.search, color: Colors.white38, size: 20),
                            SizedBox(width: 12),
                            Text('Search auctions...', style: TextStyle(color: Colors.white38)),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Featured Card
                      _buildFeaturedCard(),
                      
                      const SizedBox(height: 24),
                      
                      // Categories
                      Text('CATEGORIES', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white54, letterSpacing: 1)),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 90,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildCategoryItem(Icons.directions_car_rounded, 'Vehicles'),
                            _buildCategoryItem(Icons.watch_rounded, 'Watches'),
                            _buildCategoryItem(Icons.home_rounded, 'Property'),
                            _buildCategoryItem(Icons.palette_rounded, 'Art'),
                            _buildCategoryItem(Icons.devices_rounded, 'Tech'),
                            _buildCategoryItem(Icons.swap_horiz_rounded, 'Trade'),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      Text('LIVE AUCTIONS', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white54, letterSpacing: 1)),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              
              if (_isLoading)
                const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator(color: Color(0xFFEAB308))),
                )
              else if (_listings.isEmpty)
                const SliverToBoxAdapter(
                  child: Center(child: Text('No auctions yet', style: TextStyle(color: Colors.white38))),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildAuctionCard(_listings[index]),
                      childCount: _listings.length,
                    ),
                  ),
                ),
              
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFFEAB308).withOpacity(0.15), const Color(0xFF151C2C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEAB308).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('HOT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          const SizedBox(height: 12),
          Text(
            _formatPrice(48500),
            style: GoogleFonts.syne(fontSize: 36, fontWeight: FontWeight.w900, color: const Color(0xFFEAB308)),
          ),
          const SizedBox(height: 4),
          const Text('2024 Toyota Hilux D4D', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
          const Text('Belize District', style: TextStyle(color: Colors.white38, fontSize: 12)),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAB308),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Place Bid', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Text('12 bids', style: TextStyle(color: Colors.white.withOpacity(0.5))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label) {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF151C2C),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Icon(icon, color: const Color(0xFFEAB308), size: 24),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.white54)),
        ],
      ),
    );
  }

  Widget _buildAuctionCard(Map<String, dynamic> listing) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151C2C),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(14),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: listing['imageUrl'] != null
                  ? Image.network(listing['imageUrl'], fit: BoxFit.cover)
                  : const Icon(Icons.image, color: Colors.white24),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(listing['category'] ?? '', style: const TextStyle(fontSize: 10, color: Color(0xFFEAB308), fontWeight: FontWeight.w600)),
                Text(listing['title'] ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 4),
                Text(_formatPrice((listing['currentBid'] ?? listing['price'] ?? 0).toDouble()),
                    style: GoogleFonts.syne(fontWeight: FontWeight.w800, fontSize: 16, color: const Color(0xFFEAB308))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('${listing['bidCount'] ?? 0} bids', style: const TextStyle(fontSize: 11, color: Color(0xFF22C55E))),
          ),
        ],
      ),
    );
  }
}

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text('Activity', style: GoogleFonts.syne(fontSize: 28, fontWeight: FontWeight.w900)),
                  const Text('Your bidding activity', style: TextStyle(color: Colors.white38)),
                  const SizedBox(height: 24),
                  
                  _buildActivityItem('You placed a bid on Toyota Hilux', '2 min ago', true),
                  _buildActivityItem('New bid on Omega Watch: \$4,500', '15 min ago', false),
                  _buildActivityItem('You won auction for MacBook', '2 hours ago', true),
                  _buildActivityItem('New listing: Beachfront Property', '5 hours ago', false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, bool isOwn) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151C2C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isOwn ? const Color(0xFFEAB308).withOpacity(0.2) : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isOwn ? Icons.arrow_upward : Icons.notifications,
              color: isOwn ? const Color(0xFFEAB308) : Colors.white38,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13)),
                Text(time, style: const TextStyle(fontSize: 11, color: Colors.white38)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({super.key});

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  String _saleType = 'auction';
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text('List Item', style: GoogleFonts.syne(fontSize: 28, fontWeight: FontWeight.w900)),
                  const Text('Create a new listing', style: TextStyle(color: Colors.white38)),
                  const SizedBox(height: 24),
                  
                  // Sale Type
                  const Text('Listing Type', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildTypeBtn('auction', 'Auction', Icons.gavel_rounded),
                      const SizedBox(width: 8),
                      _buildTypeBtn('big_sale', 'Big Sale', Icons.sell_rounded),
                      const SizedBox(width: 8),
                      _buildTypeBtn('trade', 'Trade', Icons.swap_horiz_rounded),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Title
                  _buildInput('Title', _titleController, 'e.g. 2024 Toyota Hilux'),
                  const SizedBox(height: 16),
                  
                  // Price
                  _buildInput('Starting Price (BZD)', _priceController, '1000', isNumber: true),
                  const SizedBox(height: 16),
                  
                  // Description
                  _buildInput('Description', _descController, 'Describe your item...', maxLines: 4),
                  const SizedBox(height: 24),
                  
                  // Submit
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFFEAB308), Color(0xFFCA8A04)]),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text('List Item', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeBtn(String type, String label, IconData icon) {
    final isSelected = _saleType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _saleType = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFEAB308).withOpacity(0.1) : const Color(0xFF151C2C),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? const Color(0xFFEAB308) : Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? const Color(0xFFEAB308) : Colors.white38, size: 20),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(fontSize: 11, color: isSelected ? const Color(0xFFEAB308) : Colors.white38)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, String hint, {bool isNumber = false, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white24),
            filled: true,
            fillColor: const Color(0xFF151C2C),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rooms = ['General', 'Vehicles', 'Property', 'Watches', 'Trade'];
    
    return MainScaffold(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text('Chat', style: GoogleFonts.syne(fontSize: 28, fontWeight: FontWeight.w900)),
                  const Text('Join conversation rooms', style: TextStyle(color: Colors.white38)),
                  const SizedBox(height: 24),
                  
                  ...rooms.map((room) => _buildRoomItem(room)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomItem(String room) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151C2C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFEAB308), Color(0xFFCA8A04)]),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.tag, color: Colors.black, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(room, style: const TextStyle(fontWeight: FontWeight.w600)),
                const Text('Click to join', style: TextStyle(fontSize: 12, color: Colors.white38)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  
                  // Avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFEAB308), Color(0xFFCA8A04)]),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Center(
                      child: Text('BZ', style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Belize User', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  const Text('Member since 2024', style: TextStyle(color: Colors.white38)),
                  
                  const SizedBox(height: 32),
                  
                  // Stats
                  Row(
                    children: [
                      _buildStat('12', 'Bids'),
                      _buildStat('3', 'Wins'),
                      _buildStat('5', 'Listed'),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Menu
                  _buildMenuItem(Icons.person_outline, 'Edit Profile'),
                  _buildMenuItem(Icons.gavel_rounded, 'My Bids'),
                  _buildMenuItem(Icons.inventory_2_outlined, 'My Listings'),
                  _buildMenuItem(Icons.notifications_outlined, 'Notifications'),
                  _buildMenuItem(Icons.settings_outlined, 'Settings'),
                  _buildMenuItem(Icons.help_outline, 'Help & Support'),
                  _buildMenuItem(Icons.logout, 'Sign Out', isDestructive: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF151C2C),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(value, style: GoogleFonts.syne(fontSize: 24, fontWeight: FontWeight.w900, color: const Color(0xFFEAB308))),
            Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, {bool isDestructive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151C2C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: isDestructive ? Colors.red : Colors.white54, size: 22),
          const SizedBox(width: 14),
          Text(label, style: TextStyle(color: isDestructive ? Colors.red : Colors.white)),
          const Spacer(),
          Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.2), size: 14),
        ],
      ),
    );
  }
}
