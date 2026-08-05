import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:nexlab_2026/core/providers/app_state.dart';

import 'package:nexlab_2026/core/theme/app_theme.dart';
import 'package:nexlab_2026/features/health/presentation/pages/results_screen.dart';

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final upcomingBookings = state.bookings
        .where((b) => b.status == BookingStatus.pending)
        .toList();
    final completedBookings = state.bookings
        .where((b) => b.status == BookingStatus.completed || b.status == BookingStatus.cancelled)
        .toList();

    final currentList = _activeTab == 'upcoming' ? upcomingBookings : completedBookings;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Bookings',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Outfit',
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                currentList.isEmpty
                    ? 'All clear for now'
                    : '${currentList.length} ${_activeTab == 'upcoming' ? 'upcoming' : 'completed'} appointment${currentList.length == 1 ? '' : 's'}',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),

              // Underline Tab Toggle
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    _buildTabButton(
                      label: 'Upcoming',
                      count: upcomingBookings.length,
                      isActive: _activeTab == 'upcoming',
                      onTap: () => setState(() => _activeTab = 'upcoming'),
                      theme: theme,
                    ),
                    _buildTabButton(
                      label: 'Completed',
                      count: completedBookings.length,
                      isActive: _activeTab == 'completed',
                      onTap: () => setState(() => _activeTab = 'completed'),
                      theme: theme,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Bookings List
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
                          size: 44,
                          color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _activeTab == 'upcoming'
                              ? 'No upcoming appointments'
                              : 'No completed tests yet',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Outfit',
                            color: isDark ? Colors.grey.shade400 : const Color(0xFF374151),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _activeTab == 'upcoming'
                              ? 'Book a test from the home screen to get started.'
                              : 'Completed bookings will show up here.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
                            height: 1.4,
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
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final booking = currentList[index];
                    return _buildBookingCard(context, booking, state, theme);
                  },
                ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required String label,
    required int count,
    required bool isActive,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    final isDark = theme.brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? AppTheme.primaryBlue : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive
                    ? AppTheme.primaryBlue
                    : (isDark ? Colors.grey.shade400 : Colors.grey.shade500),
                fontFamily: 'Outfit',
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppTheme.primaryBlue.withValues(alpha: 0.12)
                      : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isActive
                        ? AppTheme.primaryBlue
                        : (isDark ? Colors.grey.shade400 : Colors.grey.shade500),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, Booking booking, AppState state, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final formattedDate = DateFormat('EEE, MMM d').format(booking.date);

    Color barColor = AppTheme.primaryBlue;
    Color statusColor = AppTheme.primaryBlue;
    String statusText = 'Upcoming';

    if (booking.status == BookingStatus.completed) {
      barColor = AppTheme.emeraldGreen;
      statusColor = AppTheme.emeraldGreen;
      statusText = 'Completed';
    } else if (booking.status == BookingStatus.cancelled) {
      barColor = AppTheme.coralRed;
      statusColor = AppTheme.coralRed;
      statusText = 'Cancelled';
    }

    return Container(
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
            // Left color bar
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: name + status dot
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            booking.test.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Outfit',
                              letterSpacing: -0.2,
                              color: isDark ? Colors.white : const Color(0xFF111827),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              statusText,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      booking.lab.name,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Date / time / type row
                    Wrap(
                      spacing: 14,
                      children: [
                        _buildMeta(theme, Icons.calendar_today_outlined, formattedDate, isDark),
                        _buildMeta(theme, Icons.access_time_outlined, booking.timeSlot, isDark),
                        _buildMeta(
                          theme,
                          booking.isHomeCollection ? Icons.home_outlined : Icons.business_outlined,
                          booking.isHomeCollection ? 'Home' : 'Lab',
                          isDark,
                        ),
                      ],
                    ),
                    // Payment inline
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          booking.paymentStatus == PaymentStatus.paid ? 'Paid' : 'Unpaid',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: booking.paymentStatus == PaymentStatus.paid
                                ? AppTheme.emeraldGreen
                                : AppTheme.coralRed,
                          ),
                        ),
                        Text(
                          '${booking.totalAmount.toStringAsFixed(0)} LYD',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Outfit',
                            color: isDark ? Colors.white : const Color(0xFF111827),
                          ),
                        ),
                      ],
                    ),
                    if (booking.status == BookingStatus.pending) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _showRescheduleDialog(context, booking),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: theme.primaryColor,
                                side: BorderSide(
                                  color: isDark
                                      ? Colors.grey.shade700
                                      : Colors.grey.shade300,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 9),
                              ),
                              child: const Text('Reschedule', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _showBookingDetails(context, booking),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryBlue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 9),
                              ),
                              child: const Text('Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                    ] else if (booking.status == BookingStatus.completed) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ResultsScreen()),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.emeraldGreen,
                            side: BorderSide(
                              color: AppTheme.emeraldGreen.withValues(alpha: 0.4),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 9),
                          ),
                          child: const Text('View Report', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeta(ThemeData theme, IconData icon, String text, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: isDark ? Colors.grey.shade500 : Colors.grey.shade400),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  void _showRescheduleDialog(BuildContext context, Booking booking) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reschedule Booking'),
          content: Text('Would you like to reschedule your ${booking.test.name} appointment?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Rescheduling feature simulation!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showBookingDetails(BuildContext context, Booking booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Booking Information',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildDetailItem('Booking ID', booking.id, theme),
              _buildDetailItem('Test Name', booking.test.name, theme),
              _buildDetailItem('Diagnostics Lab', booking.lab.name, theme),
              _buildDetailItem('Date & Time', '${DateFormat('MMMM d, yyyy').format(booking.date)} at ${booking.timeSlot}', theme),
              _buildDetailItem('Patient Profile', booking.patient.name, theme),
              _buildDetailItem('Visit Option', booking.isHomeCollection ? 'Home Collection' : 'Lab Visit', theme),
              _buildDetailItem('Payment Status', 'Paid (${booking.totalAmount.toStringAsFixed(0)} LYD)', theme),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Text('Close', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(value, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}
