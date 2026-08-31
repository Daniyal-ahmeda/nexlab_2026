import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:nexlab_2026/core/l10n/app_localizations.dart';
import 'package:nexlab_2026/core/providers/app_state.dart';
import 'package:nexlab_2026/core/theme/app_theme.dart';
import 'package:nexlab_2026/features/booking/presentation/pages/booking_confirmation/booking_confirmation_screen.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  String _activeTab = 'upcoming'; // 'upcoming' or 'completed'

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = state.isArabic;
    final l10n = AppLocalizations.of(context);

    final upcomingBookings = state.bookings
        .where((b) => b.status == BookingStatus.pending)
        .toList();
    final completedBookings = state.bookings
        .where((b) => b.status == BookingStatus.completed || b.status == BookingStatus.cancelled)
        .toList();

    final currentList = _activeTab == 'upcoming' ? upcomingBookings : completedBookings;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => state.refreshAll(),
          color: AppTheme.primaryBlue,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.myBookings,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    fontFamily: 'Outfit',
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isArabic
                      ? '${currentList.length} موعد مسجل'
                      : '${currentList.length} appointment${currentList.length == 1 ? '' : 's'}',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 20),

                // Tab Switcher
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF161F30) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTabPill(
                          label: isArabic ? 'المواعيد القادمة' : 'Upcoming',
                          count: upcomingBookings.length,
                          isActive: _activeTab == 'upcoming',
                          onTap: () => setState(() => _activeTab = 'upcoming'),
                          isDark: isDark,
                        ),
                      ),
                      Expanded(
                        child: _buildTabPill(
                          label: isArabic ? 'السابقة والملغاة' : 'Past & Completed',
                          count: completedBookings.length,
                          isActive: _activeTab == 'completed',
                          onTap: () => setState(() => _activeTab = 'completed'),
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Bookings Cards List
                if (currentList.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: Column(
                        children: [
                          Icon(
                            _activeTab == 'upcoming'
                                ? Icons.calendar_month_outlined
                                : Icons.check_circle_outline,
                            size: 48,
                            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            isArabic ? 'لا توجد مواعيد في هذا القسم' : 'No bookings in this section',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: currentList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final booking = currentList[index];
                      return _buildBookingCard(context, booking, isDark, isArabic, state);
                    },
                  ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabPill({
    required String label,
    required int count,
    required bool isActive,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? (isDark ? const Color(0xFF1E293B) : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                fontFamily: 'Outfit',
                color: isActive
                    ? AppTheme.primaryBlue
                    : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppTheme.primaryBlue.withValues(alpha: 0.12)
                      : (isDark ? const Color(0xFF0F172A) : Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: isActive
                        ? AppTheme.primaryBlue
                        : (isDark ? Colors.grey.shade400 : Colors.grey.shade700),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(
    BuildContext context,
    Booking booking,
    bool isDark,
    bool isArabic,
    AppState state,
  ) {
    final dateStr = DateFormat('EEE, d MMM yyyy').format(booking.date);
    Color statusColor = AppTheme.amberGold;
    String statusLabel = isArabic ? 'قيد الانتظار' : 'Pending';

    if (booking.status == BookingStatus.completed) {
      statusColor = AppTheme.emeraldGreen;
      statusLabel = isArabic ? 'مكتمل' : 'Completed';
    } else if (booking.status == BookingStatus.cancelled) {
      statusColor = AppTheme.coralRed;
      statusLabel = isArabic ? 'ملغي' : 'Cancelled';
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161F30) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
        boxShadow: AppTheme.cardShadow(isDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: ID + Status badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '#${booking.id}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Outfit',
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        statusLabel,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Outfit',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Test Name & Subtitle
                Text(
                  booking.test.name,
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Outfit',
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${booking.lab.name} • ${booking.patient.name}',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 12),

                // Meta Row
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 13, color: AppTheme.primaryBlue),
                    const SizedBox(width: 5),
                    Text(
                      dateStr,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.grey.shade300 : const Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.access_time_rounded, size: 13, color: AppTheme.primaryBlue),
                    const SizedBox(width: 5),
                    Text(
                      booking.timeSlot,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.grey.shade300 : const Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Bottom Action Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${booking.totalAmount.toInt()} ${isArabic ? "د.ل" : "LYD"}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Outfit',
                    color: AppTheme.primaryBlue,
                  ),
                ),
                Row(
                  children: [
                    if (booking.status == BookingStatus.pending)
                      TextButton(
                        onPressed: () => state.cancelBooking(booking.id),
                        child: Text(
                          isArabic ? 'إلغاء الموعد' : 'Cancel',
                          style: const TextStyle(
                            color: AppTheme.coralRed,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookingConfirmationScreen(booking: booking),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                        foregroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        isArabic ? 'عرض الإيصال' : 'View Receipt',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
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
}
