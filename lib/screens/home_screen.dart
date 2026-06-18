import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'test_details_screen.dart';
import 'family_members_screen.dart';
import 'upload_prescription_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedTab = 'packages'; // 'packages', 'basic', 'premium'
  String? _selectedCategory; // 'Heart', 'Blood', 'Thyroid', 'Energy' (null for all)
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final theme = Theme.of(context);

    // Filter logic
    List<DiagnosticTest> displayTests = state.allTests.where((test) {
      // Search query filter
      if (_searchQuery.isNotEmpty &&
          !test.name.toLowerCase().contains(_searchQuery.toLowerCase()) &&
          !test.subtitle.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }
      
      // Tab filter
      if (_selectedTab == 'packages' && !test.isPackage) return false;
      if (_selectedTab == 'basic' && (test.isPackage || test.price > 100)) return false;
      if (_selectedTab == 'premium' && test.price <= 100) return false;

      // Category filter
      if (_selectedCategory != null && test.category != _selectedCategory) return false;

      return true;
    }).toList();

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              _buildHeader(state, theme),
              const SizedBox(height: 24),

              // Search Bar
              _buildSearchBar(theme),
              const SizedBox(height: 24),

              // Service Category Grid (Upload, Offers, Family, Help)
              _buildServiceGrid(context, theme),
              const SizedBox(height: 28),

              // Diagnostic Category Header & Horizontal List
              Text(
                'Categories',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              _buildCategoryList(theme),
              const SizedBox(height: 28),

              // Tabs (Health packages, Basic tests, Premium)
              _buildTabs(theme),
              const SizedBox(height: 20),

              // Main content based on selection
              if (_selectedTab == 'packages' && _searchQuery.isEmpty && _selectedCategory == null)
                ...[
                  // Winter Special Promo Card
                  _buildWinterSpecialCard(context, state, theme),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Popular Packages',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedCategory = null;
                            _selectedTab = 'packages';
                          });
                        },
                        child: Text(
                          'See All',
                          style: theme.textTheme.labelLarge,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],

              // Grid / List of filtered tests
              if (displayTests.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Icon(Icons.search_off, size: 60, color: theme.hintColor.withOpacity(0.5)),
                        const SizedBox(height: 16),
                        Text(
                          'No tests found matching your criteria.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                )
              else if (_selectedTab == 'basic')
                // List Layout (as in home2.jpg)
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayTests.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final test = displayTests[index];
                    return _buildBasicTestCard(context, state, test, theme);
                  },
                )
              else
                // Grid Layout for Packages & Premium (as in home3.jpg / popular)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.76,
                  ),
                  itemCount: displayTests.length,
                  itemBuilder: (context, index) {
                    final test = displayTests[index];
                    return _buildGridPackageCard(context, state, test, theme);
                  },
                ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppState state, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppTheme.profileScoreGradient,
                border: Border.all(
                  color: theme.primaryColor.withOpacity(0.2),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColor.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: const Center(
                child: Text(
                  'M',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Outfit',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                  ),
                ),
                Text(
                  state.primaryUser.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.dark
                ? Colors.grey.shade800.withOpacity(0.5)
                : Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No new notifications'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppTheme.coralRed,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? theme.cardColor
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) {
          setState(() {
            _searchQuery = val;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search for tests, packages...',
          hintStyle: TextStyle(color: theme.hintColor),
          prefixIcon: Icon(Icons.search, color: theme.hintColor),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildServiceGrid(BuildContext context, ThemeData theme) {
    final items = [
      {
        'title': 'Upload Prescription',
        'icon': Icons.cloud_upload_outlined,
        'gradient': AppTheme.greenGradient,
        'page': const UploadPrescriptionScreen(),
      },
      {
        'title': 'Offers',
        'icon': Icons.percent,
        'gradient': AppTheme.orangeGradient,
        'page': null,
      },
      {
        'title': 'Family',
        'icon': Icons.people_outline,
        'gradient': AppTheme.purpleGradient,
        'page': const FamilyMembersScreen(),
      },
      {
        'title': 'Help',
        'icon': Icons.help_outline,
        'gradient': AppTheme.pinkGradient,
        'page': null,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          onTap: () {
            if (item['page'] != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => item['page'] as Widget),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item['title']} feature simulation!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: item['gradient'] as LinearGradient,
                  boxShadow: [
                    BoxShadow(
                      color: (item['gradient'] as LinearGradient).colors[0].withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Icon(
                  item['icon'] as IconData,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item['title'] as String,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryList(ThemeData theme) {
    final categories = [
      {'name': 'Heart', 'icon': Icons.favorite_border_rounded, 'color': AppTheme.coralRed},
      {'name': 'Blood', 'icon': Icons.water_drop_outlined, 'color': AppTheme.primaryBlue},
      {'name': 'Thyroid', 'icon': Icons.psychology_outlined, 'color': AppTheme.purpleAmethyst},
      {'name': 'Energy', 'icon': Icons.wb_sunny_outlined, 'color': AppTheme.amberGold},
    ];

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = _selectedCategory == cat['name'];
          final color = cat['color'] as Color;

          return InkWell(
            onTap: () {
              setState(() {
                _selectedCategory = isSelected ? null : cat['name'] as String;
              });
            },
            borderRadius: BorderRadius.circular(24),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? color
                    : (theme.brightness == Brightness.dark
                        ? Colors.grey.shade900
                        : Colors.grey.shade100),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected ? color : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    cat['icon'] as IconData,
                    size: 18,
                    color: isSelected
                        ? Colors.white
                        : (theme.brightness == Brightness.dark
                            ? Colors.grey.shade300
                            : Colors.grey.shade700),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    cat['name'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : (theme.brightness == Brightness.dark
                              ? Colors.grey.shade300
                              : Colors.grey.shade700),
                      fontFamily: 'Outfit',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabs(ThemeData theme) {
    final tabs = [
      {'id': 'packages', 'label': 'Health packages'},
      {'id': 'basic', 'label': 'Basic tests'},
      {'id': 'premium', 'label': 'Premium'},
    ];

    return Row(
      children: tabs.map((tab) {
        final isSelected = _selectedTab == tab['id'];
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedTab = tab['id'] as String;
                });
              },
              borderRadius: BorderRadius.circular(30),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppTheme.blueGradient : null,
                  color: isSelected
                      ? null
                      : (theme.brightness == Brightness.dark
                          ? Colors.grey.shade900
                          : Colors.grey.shade100),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryBlue.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : null,
                ),
                child: Text(
                  tab['label'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? Colors.white
                        : (theme.brightness == Brightness.dark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600),
                    fontFamily: 'Outfit',
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWinterSpecialCard(BuildContext context, AppState state, ThemeData theme) {
    final winterSpecialTest = state.allTests.firstWhere((t) => t.id == 't9'); // Full Body Checkup

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: AppTheme.blueGradient,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.35),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Stack(
        children: [
          // Background graphic elements
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Icons.health_and_safety_outlined,
              size: 150,
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'WINTER SPECIAL',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Full Body Checkup',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Outfit',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Comprehensive health package with 85+ tests',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '\$299',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Outfit',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        state.startBooking(winterSpecialTest);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TestDetailsScreen(test: winterSpecialTest),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Book Now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridPackageCard(BuildContext context, AppState state, DiagnosticTest test, ThemeData theme) {
    final isFav = state.isFavorite(test);

    return InkWell(
      onTap: () {
        state.startBooking(test);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TestDetailsScreen(test: test),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(test.icon, color: theme.primaryColor, size: 20),
                  ),
                  IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? AppTheme.coralRed : theme.hintColor.withOpacity(0.7),
                      size: 20,
                    ),
                    onPressed: () {
                      state.toggleFavorite(test);
                    },
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      test.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      test.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${test.price.toInt()}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.brightness == Brightness.dark
                          ? Colors.white
                          : AppTheme.textMainLight,
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicTestCard(BuildContext context, AppState state, DiagnosticTest test, ThemeData theme) {
    final isFav = state.isFavorite(test);

    return InkWell(
      onTap: () {
        state.startBooking(test);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TestDetailsScreen(test: test),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(test.icon, color: theme.primaryColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            test.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? AppTheme.coralRed : theme.hintColor,
                            size: 18,
                          ),
                          onPressed: () {
                            state.toggleFavorite(test);
                          },
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                    Text(
                      test.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: theme.hintColor),
                        const SizedBox(width: 4),
                        Text(
                          '${test.reportsInHours} hours',
                          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 11),
                        ),
                        if (test.fastingRequired) ...[
                          const SizedBox(width: 12),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: theme.hintColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.restaurant_menu_outlined, size: 14, color: AppTheme.orangeSunset),
                          const SizedBox(width: 4),
                          Text(
                            'Fasting required',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 11,
                              color: AppTheme.orangeSunset,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${test.price.toInt()}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            state.startBooking(test);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TestDetailsScreen(test: test),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: theme.primaryColor,
                            elevation: 0,
                            side: BorderSide(color: theme.primaryColor.withOpacity(0.2)),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Book',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
