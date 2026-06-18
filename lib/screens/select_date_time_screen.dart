import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../state/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'booking_confirmation_screen.dart';

class SelectDateTimeScreen extends StatefulWidget {
  const SelectDateTimeScreen({super.key});

  @override
  State<SelectDateTimeScreen> createState() => _SelectDateTimeScreenState();
}

class _SelectDateTimeScreenState extends State<SelectDateTimeScreen> {
  DateTime? _selectedDate;
  String? _selectedTimeSlot;

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
    // Generate dates: Today and next 6 days
    final today = DateTime.now();
    _dates = List.generate(7, (index) => today.add(Duration(days: index)));
    _selectedDate = _dates[0]; // Select today by default
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final theme = Theme.of(context);
    final test = state.selectedTest;
    final lab = state.selectedLab;

    if (test == null || lab == null) {
      return const Scaffold(
        body: Center(child: Text('Required booking context missing')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Select Date & Time'),
            Text(
              test.name,
              style: TextStyle(
                fontSize: 12,
                color: theme.brightness == Brightness.dark ? Colors.grey.shade400 : Colors.grey.shade600,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
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
              // Summary Header Card
              _buildSummaryCard(test, lab, theme),
              const SizedBox(height: 24),

              // Select Date Title
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 20, color: AppTheme.primaryBlue),
                  const SizedBox(width: 8),
                  Text(
                    'Select Date',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Dates horizontal view
              _buildDatesHorizontalList(theme),
              const SizedBox(height: 28),

              // Select Time Slot Title
              Row(
                children: [
                  const Icon(Icons.access_time, size: 20, color: AppTheme.primaryBlue),
                  const SizedBox(width: 8),
                  Text(
                    'Select Time Slot',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Morning Slots
              Text(
                'Morning (7:00 AM - 12:00 PM)',
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildTimeSlotGrid(_morningSlots, theme),
              const SizedBox(height: 24),

              // Afternoon Slots
              Text(
                'Afternoon (2:00 PM - 6:00 PM)',
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildTimeSlotGrid(_afternoonSlots, theme),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(
              color: theme.brightness == Brightness.dark
                  ? Colors.grey.shade900
                  : Colors.grey.shade100,
            ),
          ),
        ),
        child: ElevatedButton(
          onPressed: (_selectedDate == null || _selectedTimeSlot == null)
              ? null
              : () {
                  state.selectedDate = _selectedDate;
                  state.selectedTimeSlot = _selectedTimeSlot;
                  
                  // Confirm booking
                  final booking = state.confirmBooking();
                  
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingConfirmationScreen(booking: booking),
                    ),
                    (route) => route.isFirst,
                  );
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
            disabledBackgroundColor: theme.brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200,
            disabledForegroundColor: Colors.grey,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Confirm Booking',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(DiagnosticTest test, LabOption lab, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryBlue.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                test.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
              ),
              Text(
                'Total Amount',
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lab.name,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '\$${test.price.toInt()}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDatesHorizontalList(ThemeData theme) {
    final now = DateTime.now();

    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _dates.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final date = _dates[index];
          final isSelected = _selectedDate != null &&
              _selectedDate!.year == date.year &&
              _selectedDate!.month == date.month &&
              _selectedDate!.day == date.day;

          final dayAbbr = DateFormat('E').format(date); // e.g. Sat
          final dayNum = DateFormat('d').format(date); // e.g. 16
          final monthAbbr = DateFormat('MMM').format(date); // e.g. May

          final isToday = date.year == now.year && date.month == now.month && date.day == now.day;

          return InkWell(
            onTap: () {
              setState(() {
                _selectedDate = date;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 76,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryBlue.withOpacity(0.06)
                    : theme.cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppTheme.primaryBlue : (theme.brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryBlue.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayAbbr,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppTheme.primaryBlue : theme.hintColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dayNum,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppTheme.primaryBlue : (theme.brightness == Brightness.dark ? Colors.white : Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isToday ? 'Today' : monthAbbr,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppTheme.primaryBlue : theme.hintColor,
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

  Widget _buildTimeSlotGrid(List<String> slots, ThemeData theme) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.3,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        final isSelected = _selectedTimeSlot == slot;

        return InkWell(
          onTap: () {
            setState(() {
              _selectedTimeSlot = slot;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryBlue : theme.cardTheme.color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppTheme.primaryBlue : (theme.brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200),
                width: 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppTheme.primaryBlue.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                slot,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : (theme.brightness == Brightness.dark ? Colors.white70 : Colors.black87),
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
