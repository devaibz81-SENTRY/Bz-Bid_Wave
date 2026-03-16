import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
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
        scaffoldBackgroundColor: const Color(0xFF09090b),
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
      color: const Color(0xFF09090b),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: child,
        ),
      ),
    );
  }
}

class Listing {
  String id;
  String title;
  String category;
  String district;
  double startingPrice;
  double currentBid;
  String imageUrl;
  String endTime;
  String saleType;
  int bidCount;
  List<Map<String, dynamic>> bids;
  String status;
  String seller;
  String description;

  Listing({
    required this.id,
    required this.title,
    required this.category,
    required this.district,
    required this.startingPrice,
    required this.currentBid,
    required this.imageUrl,
    required this.endTime,
    required this.saleType,
    required this.bidCount,
    required this.bids,
    required this.status,
    required this.seller,
    this.description = '',
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      district: json['district'] ?? 'Belize',
      startingPrice: (json['startingPrice'] ?? 0).toDouble(),
      currentBid: (json['currentBid'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      endTime: json['endTime'] ?? '',
      saleType: json['saleType'] ?? 'auction',
      bidCount: json['bidCount'] ?? 0,
      bids: List<Map<String, dynamic>>.from(json['bids'] ?? []),
      status: json['status'] ?? 'active',
      seller: json['seller'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'district': district,
      'startingPrice': startingPrice,
      'currentBid': currentBid,
      'imageUrl': imageUrl,
      'endTime': endTime,
      'saleType': saleType,
      'bidCount': bidCount,
      'bids': bids,
      'status': status,
      'seller': seller,
      'description': description,
    };
  }
}

class StorageService {
  static const String _listingsKey = 'bz_listings';
  static const String _userKey = 'bz_user';
  static const String _sessionKey = 'bz_session';

  static Future<List<Listing>> getListings() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_listingsKey);
    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((e) => Listing.fromJson(e)).toList();
    }
    return _getSampleListings();
  }

  static Future<void> saveListings(List<Listing> listings) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(listings.map((e) => e.toJson()).toList());
    await prefs.setString(_listingsKey, data);
  }

  static List<Listing> _getSampleListings() {
    final now = DateTime.now();
    return [
      Listing(
        id: '1',
        title: '2024 Toyota Hilux D4D',
        category: 'Vehicles',
        district: 'Belize',
        startingPrice: 45000,
        currentBid: 48500,
        imageUrl: 'https://images.unsplash.com/photo-1626668893632-6f3a4466d22f?w=400',
        endTime: now.add(const Duration(days: 2)).toIso8601String(),
        saleType: 'auction',
        bidCount: 12,
        bids: [
          {'bidder': 'BZ_Buyer_1', 'amount': 48500, 'time': DateTime.now().millisecondsSinceEpoch - 3600000}
        ],
        status: 'active',
        seller: 'AutoDealer_BZ',
        description: 'Excellent condition Toyota Hilux D4D. Low mileage, full service history.',
      ),
      Listing(
        id: '2',
        title: 'Luxury Timepiece Collection',
        category: 'Art & Antiques',
        district: 'Cayo',
        startingPrice: 3500,
        currentBid: 4350,
        imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400',
        endTime: now.add(const Duration(days: 5)).toIso8601String(),
        saleType: 'auction',
        bidCount: 8,
        bids: [],
        status: 'active',
        seller: 'LuxuryDealer',
        description: 'Rare luxury timepiece in excellent condition.',
      ),
      Listing(
        id: '3',
        title: 'Beachfront Property - Placencia',
        category: 'Real Estate',
        district: 'Stann Creek',
        startingPrice: 250000,
        currentBid: 275000,
        imageUrl: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=400',
        endTime: now.add(const Duration(days: 7)).toIso8601String(),
        saleType: 'auction',
        bidCount: 15,
        bids: [],
        status: 'active',
        seller: 'BZ_Properties',
        description: 'Beautiful beachfront property in Placencia. Prime location.',
      ),
      Listing(
        id: '4',
        title: 'MacBook Pro M3 Max',
        category: 'Electronics',
        district: 'Belize',
        startingPrice: 3500,
        currentBid: 3500,
        imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400',
        endTime: now.add(const Duration(days: 3)).toIso8601String(),
        saleType: 'big_sale',
        bidCount: 0,
        bids: [],
        status: 'active',
        seller: 'TechGuy_BZ',
        description: 'Latest MacBook Pro M3 Max. Like new condition.',
      ),
      Listing(
        id: '5',
        title: 'Looking to Trade: ATV for Boat',
        category: 'Trade',
        district: 'Orange Walk',
        startingPrice: 0,
        currentBid: 0,
        imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
        endTime: now.add(const Duration(days: 14)).toIso8601String(),
        saleType: 'trade',
        bidCount: 0,
        bids: [],
        status: 'active',
        seller: 'OutdoorMike',
        description: 'Looking to trade my ATV for a boat. Open to offers.',
      ),
    ];
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_userKey);
    if (data != null) {
      return jsonDecode(data);
    }
    return {'displayName': 'Belize User', 'createdAt': DateTime.now().toIso8601String()};
  }

  static Future<void> saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user));
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
        setState(() => _currentIndex = 2);
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
  List<Listing> _listings = [];
  bool _isLoading = true;
  String _selectedDistrict = '';

  @override
  void initState() {
    super.initState();
    _fetchListings();
  }

  Future<void> _fetchListings() async {
    setState(() => _isLoading = true);
    final listings = await StorageService.getListings();
    if (mounted) {
      setState(() {
        _listings = listings;
        _isLoading = false;
      });
    }
  }

  String _formatPrice(double price) {
    return 'BZD \$${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
  }

  String _getTimeLeft(String endTime) {
    final diff = DateTime.parse(endTime).difference(DateTime.now());
    if (diff.isNegative) return 'Ended';
    final days = diff.inDays;
    final hours = diff.inHours % 24;
    if (days > 0) return '${days}d ${hours}h';
    final mins = diff.inMinutes % 60;
    return '${hours}h ${mins}m';
  }

  String _getSaleTypeBadge(String type) {
    switch (type) {
      case 'auction':
        return 'Auction';
      case 'big_sale':
        return 'Big Sale';
      case 'trade':
        return 'Trade';
      default:
        return '';
    }
  }

  Color _getSaleTypeColor(String type) {
    switch (type) {
      case 'auction':
        return const Color(0xFFEAB308);
      case 'big_sale':
        return Colors.blue;
      case 'trade':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  List<Listing> get _filteredListings {
    if (_selectedDistrict.isEmpty) return _listings;
    return _listings.where((l) => l.district == _selectedDistrict).toList();
  }

  Listing? get _featuredListing {
    return _listings.cast<Listing?>().firstWhere(
      (l) => l!.saleType == 'auction' && l.status == 'active',
      orElse: () => null,
    );
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

                      if (_featuredListing != null) _buildFeaturedCard(_featuredListing!),

                      const SizedBox(height: 24),

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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('LIVE AUCTIONS', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white54, letterSpacing: 1)),
                          PopupMenuButton<String>(
                            initialValue: _selectedDistrict,
                            onSelected: (value) => setState(() => _selectedDistrict = value),
                            itemBuilder: (context) => [
                              const PopupMenuItem(value: '', child: Text('All Districts')),
                              const PopupMenuItem(value: 'Belize', child: Text('Belize')),
                              const PopupMenuItem(value: 'Cayo', child: Text('Cayo')),
                              const PopupMenuItem(value: 'Stann Creek', child: Text('Stann Creek')),
                              const PopupMenuItem(value: 'Orange Walk', child: Text('Orange Walk')),
                            ],
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF151C2C),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Text(_selectedDistrict.isEmpty ? 'All' : _selectedDistrict, style: const TextStyle(fontSize: 12)),
                                  const Icon(Icons.arrow_drop_down, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),

              if (_isLoading)
                const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator(color: Color(0xFFEAB308))),
                )
              else if (_filteredListings.isEmpty)
                const SliverToBoxAdapter(
                  child: Center(child: Text('No auctions yet', style: TextStyle(color: Colors.white38))),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildAuctionCard(_filteredListings[index]),
                      childCount: _filteredListings.length,
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

  Widget _buildFeaturedCard(Listing listing) {
    return GestureDetector(
      onTap: () => _showListingDetail(listing),
      child: Container(
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('HOT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAB308),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('LIVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _formatPrice(listing.currentBid),
              style: GoogleFonts.syne(fontSize: 36, fontWeight: FontWeight.w900, color: const Color(0xFFEAB308)),
            ),
            const SizedBox(height: 4),
            Text(listing.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            Text(listing.district, style: const TextStyle(color: Colors.white38, fontSize: 12)),
            const SizedBox(height: 16),
            Row(
              children: [
                GestureDetector(
                  onTap: () => _placeBid(listing),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAB308),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('Place Bid', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Text('${listing.bidCount} bids • ${_getTimeLeft(listing.endTime)}', style: TextStyle(color: Colors.white.withOpacity(0.5))),
              ],
            ),
          ],
        ),
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

  Widget _buildAuctionCard(Listing listing) {
    return GestureDetector(
      onTap: () => _showListingDetail(listing),
      child: Container(
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
                child: listing.imageUrl.isNotEmpty
                    ? Image.network(listing.imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image, color: Colors.white24))
                    : const Icon(Icons.image, color: Colors.white24),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getSaleTypeColor(listing.saleType).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(_getSaleTypeBadge(listing.saleType), style: TextStyle(fontSize: 9, color: _getSaleTypeColor(listing.saleType), fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 6),
                      Text(listing.category, style: const TextStyle(fontSize: 10, color: Color(0xFFEAB308), fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(listing.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(
                    listing.saleType == 'trade' ? 'Trade' : _formatPrice(listing.currentBid),
                    style: GoogleFonts.syne(fontWeight: FontWeight.w800, fontSize: 16, color: const Color(0xFFEAB308))),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('${listing.bidCount} bids', style: const TextStyle(fontSize: 11, color: Color(0xFF22C55E))),
                ),
                const SizedBox(height: 4),
                Text(_getTimeLeft(listing.endTime), style: const TextStyle(fontSize: 10, color: Colors.white38)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showListingDetail(Listing listing) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF151C2C),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => ListingDetailSheet(listing: listing, onBidPlaced: () => _fetchListings()),
    );
  }

  Future<void> _placeBid(Listing listing) async {
    final controller = TextEditingController(text: (listing.currentBid + 100).toStringAsFixed(0));
    final result = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF151C2C),
        title: Text('Place Bid - ${listing.title}', style: GoogleFonts.syne(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current: ${_formatPrice(listing.currentBid)}', style: const TextStyle(color: Colors.white38)),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Your Bid (BZD)',
                labelStyle: const TextStyle(color: Colors.white38),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFEAB308)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(controller.text);
              if (amount != null && amount > listing.currentBid) {
                Navigator.pop(context, amount);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEAB308)),
            child: const Text('Place Bid', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );

    if (result != null) {
      listing.bids.add({
        'bidder': 'You',
        'amount': result,
        'time': DateTime.now().millisecondsSinceEpoch,
      });
      listing.currentBid = result;
      listing.bidCount++;
      await StorageService.saveListings(_listings);
      _fetchListings();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bid placed: ${_formatPrice(result)}'), backgroundColor: const Color(0xFF22C55E)));
      }
    }
  }
}

class ListingDetailSheet extends StatefulWidget {
  final Listing listing;
  final VoidCallback onBidPlaced;
  const ListingDetailSheet({super.key, required this.listing, required this.onBidPlaced});

  @override
  State<ListingDetailSheet> createState() => _ListingDetailSheetState();
}

class _ListingDetailSheetState extends State<ListingDetailSheet> {
  late Listing listing;

  @override
  void initState() {
    super.initState();
    listing = widget.listing;
  }

  String _formatPrice(double price) {
    return 'BZD \$${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
  }

  String _getTimeLeft(String endTime) {
    final diff = DateTime.parse(endTime).difference(DateTime.now());
    if (diff.isNegative) return 'Ended';
    final days = diff.inDays;
    final hours = diff.inHours % 24;
    if (days > 0) return '${days}d ${hours}h';
    final mins = diff.inMinutes % 60;
    return '${hours}h ${mins}m';
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(listing.imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(height: 200, color: Colors.white10, child: const Icon(Icons.image, size: 48))),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFEAB308).withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                    child: Text(listing.saleType.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFEAB308))),
                  ),
                  const SizedBox(width: 8),
                  Text(listing.category, style: const TextStyle(color: Colors.white54)),
                ],
              ),
              const SizedBox(height: 12),
              Text(listing.title, style: GoogleFonts.syne(fontSize: 24, fontWeight: FontWeight.w900)),
              Text(listing.district, style: const TextStyle(color: Colors.white38)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Current Bid', style: TextStyle(color: Colors.white38, fontSize: 12)),
                            Text(_formatPrice(listing.currentBid), style: GoogleFonts.syne(fontSize: 28, fontWeight: FontWeight.w900, color: const Color(0xFFEAB308))),
                            Text('${listing.bidCount} bids', style: const TextStyle(color: Colors.white54)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Time Left', style: TextStyle(color: Colors.white38, fontSize: 12)),
                            Text(_getTimeLeft(listing.endTime), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF22C55E))),
                          ],
                        ),
                      ],
                    ),
                    if (listing.bids.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Divider(color: Colors.white12),
                      const SizedBox(height: 8),
                      ...listing.bids.reversed.take(3).map((b) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(b['bidder'] ?? '', style: const TextStyle(color: Colors.white)),
                            Text(_formatPrice((b['amount'] as num).toDouble()), style: const TextStyle(color: Color(0xFFEAB308))),
                          ],
                        ),
                      )),
                    ],
                    const SizedBox(height: 16),
                    if (listing.saleType == 'auction')
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _placeBid,
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEAB308), padding: const EdgeInsets.symmetric(vertical: 14)),
                          child: const Text('Place Bid', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text('Description', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(listing.description.isEmpty ? 'No description provided.' : listing.description, style: const TextStyle(color: Colors.white38)),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Seller: ', style: TextStyle(color: Colors.white38)),
                  Text(listing.seller, style: const TextStyle(color: Colors.white)),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _placeBid() async {
    final controller = TextEditingController(text: (listing.currentBid + 100).toStringAsFixed(0));
    final result = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF151C2C),
        title: const Text('Place Bid'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Your Bid (BZD)',
            labelStyle: const TextStyle(color: Colors.white38),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white24)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEAB308))),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(controller.text);
              if (amount != null && amount > listing.currentBid) Navigator.pop(context, amount);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEAB308)),
            child: const Text('Place Bid', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );

    if (result != null) {
      listing.bids.add({'bidder': 'You', 'amount': result, 'time': DateTime.now().millisecondsSinceEpoch});
      listing.currentBid = result;
      listing.bidCount++;
      final listings = await StorageService.getListings();
      final idx = listings.indexWhere((l) => l.id == listing.id);
      if (idx >= 0) listings[idx] = listing;
      await StorageService.saveListings(listings);
      setState(() {});
      widget.onBidPlaced();
      if (mounted) Navigator.pop(context);
    }
  }
}

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  List<Map<String, String>> _activities = [];

  @override
  void initState() {
    super.initState();
    _activities = [
      {'title': 'You placed a bid on Toyota Hilux', 'time': '2 min ago', 'isOwn': 'true'},
      {'title': 'New bid on Omega Watch: \$4,500', 'time': '15 min ago', 'isOwn': 'false'},
      {'title': 'You won auction for MacBook', 'time': '2 hours ago', 'isOwn': 'true'},
      {'title': 'New listing: Beachfront Property', 'time': '5 hours ago', 'isOwn': 'false'},
    ];
  }

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

                  ..._activities.map((activity) => _buildActivityItem(
                    activity['title']!,
                    activity['time']!,
                    activity['isOwn'] == 'true',
                  )),
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
  String _category = 'Vehicles';
  String _district = 'Belize';
  String _imageUrl = '';
  int _duration = 5;

  final List<String> _categories = ['Vehicles', 'Real Estate', 'Electronics', 'Furniture', 'Art & Antiques', 'Machinery', 'Livestock', 'Other'];
  final List<String> _districts = ['Belize', 'Cayo', 'Stann Creek', 'Orange Walk', 'Corozal', 'Toledo'];

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text('List Item', style: GoogleFonts.syne(fontSize: 28, fontWeight: FontWeight.w900)),
            const Text('Create a new listing', style: TextStyle(color: Colors.white38)),
            const SizedBox(height: 24),

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

            _buildInput('Title', _titleController, 'e.g. 2024 Toyota Hilux'),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(child: _buildDropdown('Category', _category, _categories, (v) => setState(() => _category = v!))),
                const SizedBox(width: 12),
                Expanded(child: _buildDropdown('District', _district, _districts, (v) => setState(() => _district = v!))),
              ],
            ),
            const SizedBox(height: 16),

            if (_saleType != 'trade') ...[
              _buildInput('Starting Price (BZD)', _priceController, '1000', isNumber: true),
              const SizedBox(height: 16),
            ],

            if (_saleType == 'auction') ...[
              const Text('Duration', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [1, 3, 5, 7, 14].map((d) => ChoiceChip(
                  label: Text('$d days'),
                  selected: _duration == d,
                  selectedColor: const Color(0xFFEAB308),
                  onSelected: (_) => setState(() => _duration = d),
                )).toList(),
              ),
              const SizedBox(height: 16),
            ],

            _buildInput('Description', _descController, 'Describe your item...', maxLines: 4),
            const SizedBox(height: 16),

            _buildInput('Image URL (optional)', _imageUrlController, 'https://...'),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: _submitListing,
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
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  final TextEditingController _imageUrlController = TextEditingController();

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

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF151C2C),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: const Color(0xFF151C2C),
            style: const TextStyle(color: Colors.white),
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Future<void> _submitListing() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a title')));
      return;
    }

    final price = _saleType == 'trade' ? 0.0 : double.tryParse(_priceController.text) ?? 0;
    if (_saleType != 'trade' && price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid price')));
      return;
    }

    final user = await StorageService.getUser();
    final listing = Listing(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      category: _category,
      district: _district,
      startingPrice: price,
      currentBid: price,
      imageUrl: _imageUrlController.text.isNotEmpty 
          ? _imageUrlController.text 
          : 'https://images.unsplash.com/photo-1534120247760-c44c3e4a62f1?w=400',
      endTime: DateTime.now().add(Duration(days: _duration)).toIso8601String(),
      saleType: _saleType,
      bidCount: 0,
      bids: [],
      status: 'active',
      seller: user?['displayName'] ?? 'Anonymous',
      description: _descController.text,
    );

    final listings = await StorageService.getListings();
    listings.insert(0, listing);
    await StorageService.saveListings(listings);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Listing created!'), backgroundColor: Color(0xFF22C55E)));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AppContainer(child: DashboardScreen())),
      );
    }
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<String> _rooms = ['General', 'Vehicles', 'Property', 'Watches', 'Trade'];

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
                  Text('Chat', style: GoogleFonts.syne(fontSize: 28, fontWeight: FontWeight.w900)),
                  const Text('Join conversation rooms', style: TextStyle(color: Colors.white38)),
                  const SizedBox(height: 24),

                  ..._rooms.map((room) => _buildRoomItem(room)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomItem(String room) {
    return GestureDetector(
      onTap: () => _openChatRoom(room),
      child: Container(
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
      ),
    );
  }

  void _openChatRoom(String room) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AppContainer(child: ChatRoomScreen(room: room))),
    );
  }
}

class ChatRoomScreen extends StatefulWidget {
  final String room;
  const ChatRoomScreen({super.key, required this.room});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _controller = TextEditingController();
  List<Map<String, String>> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF151C2C),
        title: Text(widget.room, style: GoogleFonts.syne(fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(child: Text('No messages yet. Start the conversation!', style: TextStyle(color: Colors.white38)))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isOwn = msg['isOwn'] == 'true';
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: isOwn ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(msg['user'] ?? '', style: TextStyle(fontSize: 11, color: isOwn ? const Color(0xFFEAB308) : Colors.white38)),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isOwn ? const Color(0xFFEAB308).withOpacity(0.2) : Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(msg['text'] ?? '', style: const TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF151C2C),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFEAB308), borderRadius: BorderRadius.circular(24)),
                    child: const Icon(Icons.send, color: Colors.black, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _messages.add({'user': 'You', 'text': _controller.text, 'isOwn': 'true'});
    });
    _controller.clear();
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _user;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _district = 'Belize';
  final _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await StorageService.getUser();
    if (mounted) {
      setState(() {
        _user = user;
        _nameController.text = user?['displayName'] ?? 'Belize User';
        _phoneController.text = user?['phone'] ?? '';
        _district = user?['district'] ?? 'Belize';
        _bioController.text = user?['bio'] ?? '';
      });
    }
  }

  Future<void> _saveProfile() async {
    final user = {
      'displayName': _nameController.text,
      'phone': _phoneController.text,
      'district': _district,
      'bio': _bioController.text,
      'createdAt': _user?['createdAt'] ?? DateTime.now().toIso8601String(),
    };
    await StorageService.saveUser(user);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile saved!'), backgroundColor: Color(0xFF22C55E)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 60),

            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFEAB308), Color(0xFFCA8A04)]),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text((_nameController.text.isNotEmpty ? _nameController.text : 'BZ').substring(0, 2).toUpperCase(), style: const TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              decoration: const InputDecoration(border: InputBorder.none, hintText: 'Your Name'),
            ),
            Text('Member since 2024', style: TextStyle(color: Colors.white.withOpacity(0.38))),

            const SizedBox(height: 32),

            Row(
              children: [
                _buildStat('12', 'Bids'),
                _buildStat('3', 'Wins'),
                _buildStat('5', 'Listed'),
              ],
            ),

            const SizedBox(height: 32),

            _buildInput('Phone', _phoneController, '+501 123-4567'),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF151C2C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: _district,
                isExpanded: true,
                underline: const SizedBox(),
                dropdownColor: const Color(0xFF151C2C),
                style: const TextStyle(color: Colors.white),
                items: ['Belize', 'Cayo', 'Stann Creek', 'Orange Walk', 'Corozal', 'Toledo'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setState(() => _district = v!),
              ),
            ),
            const SizedBox(height: 12),

            _buildInput('Bio', _bioController, 'Tell us about yourself...', maxLines: 3),

            const SizedBox(height: 16),

            GestureDetector(
              onTap: _saveProfile,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFEAB308), Color(0xFFCA8A04)]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: Text('Save Profile', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
              ),
            ),

            const SizedBox(height: 24),

            _buildMenuItem(Icons.gavel_rounded, 'My Bids'),
            _buildMenuItem(Icons.inventory_2_outlined, 'My Listings'),
            _buildMenuItem(Icons.notifications_outlined, 'Notifications'),
            _buildMenuItem(Icons.settings_outlined, 'Settings'),
            _buildMenuItem(Icons.help_outline, 'Help & Support'),

            const SizedBox(height: 100),
          ],
        ),
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

  Widget _buildInput(String label, TextEditingController controller, String hint, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        filled: true,
        fillColor: const Color(0xFF151C2C),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.all(16),
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
