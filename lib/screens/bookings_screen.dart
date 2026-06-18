import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../state/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'results_screen.dart';

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
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Outfit',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Track your appointments and test history',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Tab Toggle Buttons (Pills)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? Colors.grey.shade900
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTabButton(
                        label: 'Upcoming (${upcomingBookings.length})',
                        isActive: _activeTab == 'upcoming',
                        onTap: () => setState(() => _activeTab = 'upcoming'),
                        theme: theme,
                      ),
                    ),
                    Expanded(
                      child: _buildTabButton(
                        label: 'Completed (${completedBookings.length})',
                        isActive: _activeTab == 'completed',
                        onTap: () => setState(() => _activeTab = 'completed'),
                        theme: theme,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Bookings List
              if (currentList.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: Column(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 60,
                          color: theme.hintColor.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No bookings found.',
                          style: theme.textTheme.bodyMedium,
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
                  separatorBuilder: (context, index) => const SizedBox(height: 18),
                  itemBuilder: (context, index) {
                    final booking = currentList[index];
                    return _buildBookingCard(booking, state, theme);
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
    required bool isActive,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: isActive ? AppTheme.blueGradient : null,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isActive
                ? Colors.white
                : (theme.brightness == Brightness.dark
                    ? Colors.grey.shade400
                    : Colors.grey.shade600),
            fontFamily: 'Outfit',
          ),
        ),
      ),
    );
  }

  Widget _buildBookingCard(Booking booking, AppState state, ThemeData theme) {
    final formattedDate = DateFormat('EEE, MMM d, yyyy').format(booking.date);
    
    // Determine status badge color
    Color statusBgColor = AppTheme.primaryBlue.withOpacity(0.1);
    Color statusTextColor = AppTheme.primaryBlue;
    String statusText = 'Pending';

    if (booking.status == BookingStatus.completed) {
      statusBgColor = AppTheme.emeraldGreen.withOpacity(0.1);
      statusTextColor = AppTheme.emeraldGreen;
      statusText = 'Completed';
    } else if (booking.status == BookingStatus.cancelled) {
      statusBgColor = AppTheme.coralRed.withOpacity(0.1);
      statusTextColor = AppTheme.coralRed;
      statusText = 'Cancelled';
    }

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.test.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            booking.lab.name,
                            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          color: statusTextColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Details Row
                _buildCardDetailRow(theme, Icons.calendar_month, formattedDate),
                const SizedBox(height: 8),
                _buildCardDetailRow(theme, Icons.access_time, booking.timeSlot),
                const SizedBox(height: 8),
                _buildCardDetailRow(
                  theme,
                  booking.isHomeCollection ? Icons.home_outlined : Icons.business,
                  booking.isHomeCollection
                      ? 'Home Collection'
                      : 'Lab Visit',
                ),

                if (booking.isHomeCollection) ...[
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Text(
                      booking.patient.id == 'f_self'
                          ? '456 Oak Street, Apt 3B, New York, NY'
                          : 'Patient: ${booking.patient.name}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        color: theme.hintColor,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),

                // Payment Status Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.emeraldGreen.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Payment Status',
                        style: TextStyle(
                          color: AppTheme.emeraldGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        booking.paymentStatus == PaymentStatus.paid ? 'Paid' : 'Unpaid',
                        style: const TextStyle(
                          color: AppTheme.emeraldGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Action Buttons at Bottom
                if (booking.status == BookingStatus.pending) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _showRescheduleDialog(context, booking);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: theme.primaryColor,
                            side: BorderSide(color: theme.primaryColor.withOpacity(0.2)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: const Text('Reschedule', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _showBookingDetails(context, booking);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: const Text('View Details', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  )
                ] else if (booking.status == BookingStatus.completed) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ResultsScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.emeraldGreen,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: const Text('View Report', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  )
                ]
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCardDetailRow(ThemeData theme, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.hintColor.withOpacity(0.7)),
        const SizedBox(width: 8),
        Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 13,
            color: theme.brightness == Brightness.dark ? Colors.grey.shade300 : Colors.grey.shade700,
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
                    color: Colors.grey.withOpacity(0.3),
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
              _buildDetailItem('Payment Status', 'Paid (\$${booking.totalAmount.toInt()})', theme),
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
