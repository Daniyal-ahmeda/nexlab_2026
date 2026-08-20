import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:nexlab_2026/core/providers/app_state.dart';
import 'package:nexlab_2026/core/theme/app_theme.dart';
import 'package:nexlab_2026/features/booking/presentation/pages/booking_confirmation/booking_confirmation_screen.dart';

class SelectDateTimeScreen extends StatefulWidget {
  const SelectDateTimeScreen({super.key});

  @override
  State<SelectDateTimeScreen> createState() => _SelectDateTimeScreenState();
}

class _SelectDateTimeScreenState extends State<SelectDateTimeScreen> {
  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  bool _isSubmitting = false;

  late List<DateTime> _dates;

  final List<String> _morningSlots = [
    '07:00 AM',
    '07:30 AM',
    '08:00 AM',
    '08:30 AM',
    '09:00 AM',
    '09:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
  ];

  final List<String> _afternoonSlots = [
    '02:00 PM',
    '02:30 PM',
    '03:00 PM',
    '03:30 PM',
    '04:00 PM',
    '04:30 PM',
    '05:00 PM',
    '05:30 PM',
  ];

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _dates = List.generate(7, (index) => today.add(Duration(days: index)));
    _selectedDate = _dates[0];
  }

  Set<String> _getUnavailableSlots(DateTime date, LabOption lab, AppState state) {
    final unavailable = <String>{};

    // 1. Check existing bookings in AppState for this lab and date
    for (final b in state.bookings) {
      if (b.lab.id == lab.id &&
          b.date.year == date.year &&
          b.date.month == date.month &&
          b.date.day == date.day &&
          b.status != BookingStatus.cancelled) {
        unavailable.add(b.timeSlot);
      }
    }

    // 2. Realistic lab slot reservation rules based on date & lab ID
    final daySeed = date.day + date.month * 31 + lab.id.hashCode;
    if (daySeed % 2 == 0) {
      unavailable.add('08:00 AM');
      unavailable.add('09:30 AM');
      unavailable.add('03:00 PM');
    }
    if (daySeed % 3 == 0) {
      unavailable.add('07:30 AM');
      unavailable.add('10:30 AM');
      unavailable.add('04:30 PM');
    }
    if (daySeed % 5 == 0) {
      unavailable.add('11:00 AM');
      unavailable.add('02:00 PM');
      unavailable.add('05:00 PM');
    }

    // 3. Disable past time slots if selected date is TODAY
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      for (final slot in [..._morningSlots, ..._afternoonSlots]) {
        final slotHour = _parseSlotHour(slot);
        if (slotHour <= now.hour) {
          unavailable.add(slot);
        }
      }
    }

    return unavailable;
  }

  int _parseSlotHour(String slot) {
    final parts = slot.split(' ');
    final timeParts = parts[0].split(':');
    int hour = int.parse(timeParts[0]);
    final isPm = parts[1] == 'PM';
    if (isPm && hour < 12) hour += 12;
    if (!isPm && hour == 12) hour = 0;
    return hour;
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final test = state.selectedTest;
    final lab = state.selectedLab;

    if (test == null || lab == null) {
      return const Scaffold(
        body: Center(child: Text('Required booking context missing')),
      );
    }

    final unavailableSlots = _selectedDate != null
        ? _getUnavailableSlots(_selectedDate!, lab, state)
        : <String>{};

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text(
              'Schedule Appointment',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'Outfit',
              ),
            ),
            Text(
              test.name,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Header Row
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            test.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Outfit',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${lab.name} • ${state.isHomeCollection ? 'Home Collection' : 'Lab Visit'}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${test.price.toStringAsFixed(0)} LYD',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Outfit',
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Date Header
              Text(
                'SELECT DATE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  letterSpacing: 0.8,
                  fontFamily: 'Outfit',
                ),
              ),
              const SizedBox(height: 10),
              _buildDatesHorizontalList(isDark, unavailableSlots),
              const SizedBox(height: 24),

              // Time Header
              Text(
                'SELECT TIME SLOT',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  letterSpacing: 0.8,
                  fontFamily: 'Outfit',
                ),
              ),
              const SizedBox(height: 12),

              // Morning Section
              Row(
                children: [
                  const Icon(Icons.wb_sunny_outlined, size: 14, color: AppTheme.amberGold),
                  const SizedBox(width: 6),
                  Text(
                    'Morning (7:00 AM - 12:00 PM)',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Outfit',
                      color: isDark ? Colors.grey.shade300 : const Color(0xFF334155),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildTimeSlotGrid(_morningSlots, unavailableSlots, isDark),
              const SizedBox(height: 20),

              // Afternoon Section
              Row(
                children: [
                  const Icon(Icons.wb_twilight_outlined, size: 14, color: AppTheme.primaryBlue),
                  const SizedBox(width: 6),
                  Text(
                    'Afternoon (2:00 PM - 6:00 PM)',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Outfit',
                      color: isDark ? Colors.grey.shade300 : const Color(0xFF334155),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildTimeSlotGrid(_afternoonSlots, unavailableSlots, isDark),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            ),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: (_selectedDate == null || _selectedTimeSlot == null || _isSubmitting)
                  ? null
                  : () async {
                      setState(() => _isSubmitting = true);
                      try {
                        state.selectedDate = _selectedDate;
                        state.selectedTimeSlot = _selectedTimeSlot;

                        final booking = await state.confirmBooking();

                        if (!context.mounted) return;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingConfirmationScreen(booking: booking),
                          ),
                          (route) => route.isFirst,
                        );
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Booking failed: ${e.toString()}'),
                            backgroundColor: AppTheme.coralRed,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      } finally {
                        if (mounted) {
                          setState(() => _isSubmitting = false);
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                disabledBackgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                disabledForegroundColor: Colors.grey,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Confirm & Proceed to Receipt',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Outfit',
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatesHorizontalList(bool isDark, Set<String> unavailableSlots) {
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _dates.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final date = _dates[index];
          final isSelected = _selectedDate != null &&
              _selectedDate!.year == date.year &&
              _selectedDate!.month == date.month &&
              _selectedDate!.day == date.day;

          final dayName = DateFormat('EEE').format(date);
          final dayNum = DateFormat('d').format(date);
          final monthName = DateFormat('MMM').format(date);

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
                if (_selectedTimeSlot != null && unavailableSlots.contains(_selectedTimeSlot)) {
                  _selectedTimeSlot = null;
                }
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 64,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryBlue
                    : (isDark ? const Color(0xFF1E293B) : Colors.white),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryBlue
                      : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayName.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.9)
                          : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dayNum,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Outfit',
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.white : const Color(0xFF0F172A)),
                    ),
                  ),
                  Text(
                    monthName,
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.9)
                          : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
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

  Widget _buildTimeSlotGrid(List<String> slots, Set<String> unavailableSlots, bool isDark) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: slots.map((slot) {
        final isUnavailable = unavailableSlots.contains(slot);
        final isSelected = _selectedTimeSlot == slot;

        Color bgColor;
        Color borderColor;
        Color textColor;

        if (isUnavailable) {
          bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
          borderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
          textColor = isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8);
        } else if (isSelected) {
          bgColor = AppTheme.primaryBlue;
          borderColor = AppTheme.primaryBlue;
          textColor = Colors.white;
        } else {
          bgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
          borderColor = isDark ? Colors.grey.shade800 : Colors.grey.shade200;
          textColor = isDark ? Colors.white : const Color(0xFF0F172A);
        }

        return GestureDetector(
          onTap: isUnavailable
              ? null
              : () {
                  setState(() {
                    _selectedTimeSlot = slot;
                  });
                },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  slot,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontFamily: 'Outfit',
                    color: textColor,
                    decoration: isUnavailable ? TextDecoration.lineThrough : null,
                    decorationColor: textColor,
                  ),
                ),
                if (isUnavailable) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.block,
                    size: 11,
                    color: textColor,
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
