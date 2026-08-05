import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nexlab_2026/core/providers/app_state.dart';

import 'package:nexlab_2026/core/theme/app_theme.dart';
import 'test_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final list = state.favorites;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Saved Tests',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Outfit',
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                list.isEmpty
                    ? 'Nothing saved yet'
                    : '${list.length} ${list.length == 1 ? 'test' : 'tests'} saved',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              if (list.isEmpty)
                _EmptyFavoritesState(isDark: isDark)
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final test = list[index];
                    return _FavoriteCard(
                      key: ValueKey(test.id),
                      test: test,
                      state: state,
                      theme: theme,
                      isDark: isDark,
                      index: index,
                    );
                  },
                ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Empty state ──────────────────────────────────────────────────────────────

class _EmptyFavoritesState extends StatefulWidget {
  final bool isDark;
  const _EmptyFavoritesState({required this.isDark});

  @override
  State<_EmptyFavoritesState> createState() => _EmptyFavoritesStateState();
}

class _EmptyFavoritesStateState extends State<_EmptyFavoritesState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 72),
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _pulse,
              builder: (context, child) => Transform.scale(
                scale: 1.0 + _pulse.value * 0.06,
                child: child,
              ),
              child: Icon(
                Icons.favorite_border_rounded,
                size: 48,
                color: widget.isDark
                    ? Colors.grey.shade700
                    : const Color(0xFFE5E7EB),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Nothing saved yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'Outfit',
                color: widget.isDark
                    ? Colors.grey.shade400
                    : const Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Tap the heart on any test to save it here\nfor quick access later.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: widget.isDark
                    ? Colors.grey.shade500
                    : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Favorite card ─────────────────────────────────────────────────────────────

class _FavoriteCard extends StatefulWidget {
  final DiagnosticTest test;
  final AppState state;
  final ThemeData theme;
  final bool isDark;
  final int index;

  const _FavoriteCard({
    super.key,
    required this.test,
    required this.state,
    required this.theme,
    required this.isDark,
    required this.index,
  });

  @override
  State<_FavoriteCard> createState() => _FavoriteCardState();
}

class _FavoriteCardState extends State<_FavoriteCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _enter;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _enter = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _fade = CurvedAnimation(parent: _enter, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _enter, curve: Curves.easeOutQuart));

    // Stagger by index
    Future.delayed(Duration(milliseconds: widget.index * 60), () {
      if (mounted) _enter.forward();
    });
  }

  @override
  void dispose() {
    _enter.dispose();
    super.dispose();
  }

  Color get _accentColor {
    switch (widget.test.category) {
      case 'Heart':
        return AppTheme.coralRed;
      case 'Thyroid':
        return AppTheme.purpleAmethyst;
      case 'Energy':
        return AppTheme.amberGold;
      default:
        return AppTheme.primaryBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final test = widget.test;
    final isDark = widget.isDark;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: InkWell(
          onTap: () {
            widget.state.startBooking(test);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TestDetailsScreen(test: test),
              ),
            );
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left accent bar
                  Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: _accentColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(14),
                        bottomLeft: Radius.circular(14),
                      ),
                    ),
                  ),
                  // Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Category badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _accentColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  test.category.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.8,
                                    color: _accentColor,
                                    fontFamily: 'Outfit',
                                  ),
                                ),
                              ),
                              const Spacer(),
                              // Remove button — small X, no container
                              GestureDetector(
                                onTap: () {
                                  widget.state.removeFavorite(test);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          '${test.name} removed'),
                                      action: SnackBarAction(
                                        label: 'Undo',
                                        onPressed: () =>
                                            widget.state.toggleFavorite(test),
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: isDark
                                      ? Colors.grey.shade600
                                      : Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            test.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Outfit',
                              letterSpacing: -0.2,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            test.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Meta row
                          Wrap(
                            spacing: 12,
                            children: [
                              _meta(Icons.schedule_outlined,
                                  '${test.reportsInHours}h', isDark),
                              _meta(Icons.water_drop_outlined,
                                  test.sampleType, isDark),
                              if (test.fastingRequired)
                                _meta(Icons.no_food_outlined, 'Fasting',
                                    isDark,
                                    color: AppTheme.orangeSunset),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'From',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isDark
                                          ? Colors.grey.shade500
                                          : Colors.grey.shade400,
                                    ),
                                  ),
                                  Text(
                                    '${test.price.toStringAsFixed(0)} LYD',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'Outfit',
                                      letterSpacing: -0.5,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF111827),
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  widget.state.startBooking(test);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TestDetailsScreen(test: test),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryBlue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                ),
                                child: const Text(
                                  'Book',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _meta(IconData icon, String text, bool isDark, {Color? color}) {
    final c =
        color ?? (isDark ? Colors.grey.shade500 : Colors.grey.shade400);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: c),
        const SizedBox(width: 3),
        Text(
          text,
          style: TextStyle(fontSize: 11, color: c),
        ),
      ],
    );
  }
}
