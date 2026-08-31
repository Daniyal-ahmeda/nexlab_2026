import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:nexlab_2026/core/l10n/app_localizations.dart';
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
    for (final b in state.bookings) {
      if (b.lab.id == lab.id &&
          b.date.year == date.year &&
          b.date.month == date.month &&
          b.date.day == date.day &&
          b.status != BookingStatus.cancelled) {
        unavailable.add(b.timeSlot);
      }
    }
    final daySeed = date.day + date.month * 31 + lab.id.hashCode;
    if (daySeed % 2 == 0) unavailable.addAll(['08:30 AM', '03:00 PM']);
    if (daySeed % 3 == 0) unavailable.addAll(['10:00 AM', '04:30 PM']);
    return unavailable;
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = state.isArabic;
    final l10n = AppLocalizations.of(context);
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
        title: Text(
          l10n.selectDateTime,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            fontFamily: 'Outfit',
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Booking Summary Mini Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF161F30) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                ),
                boxShadow: AppTheme.cardShadow(isDark),
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
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Outfit',
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${lab.name} • ${state.isHomeCollection ? (isArabic ? "سحب منزلي" : "Home Collection") : (isArabic ? "زيارة المختبر" : "Lab Visit")}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${test.price.toInt()} ${isArabic ? "د.ل" : "LYD"}',
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
            const SizedBox(height: 20),

            // 2. Select Patient Selector (Self or Family Members)
            Text(
              isArabic ? 'المريض المستفيد' : 'PATIENT BENEFICIARY',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                letterSpacing: 0.8,
                fontFamily: 'Outfit',
              ),
            ),
            const SizedBox(height: 10),
            _buildPatientSelector(state, isDark, isArabic),
            const SizedBox(height: 22),

            // 3. Date Timeline Strip
            Text(
              isArabic ? 'اختر اليوم والتاريخ' : 'SELECT APPOINTMENT DATE',
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
            const SizedBox(height: 22),

            // 4. Morning Time Slots
            Row(
              children: [
                const Icon(Icons.wb_sunny_outlined, size: 16, color: AppTheme.amberGold),
                const SizedBox(width: 6),
                Text(
                  isArabic ? 'الفترة الصباحية (08:00 ص - 12:00 م)' : 'Morning Slots (8:00 AM - 12:00 PM)',
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
            const SizedBox(height: 18),

            // 5. Afternoon Time Slots
            Row(
              children: [
                const Icon(Icons.wb_twilight_outlined, size: 16, color: AppTheme.primaryBlue),
                const SizedBox(width: 6),
                Text(
                  isArabic ? 'الفترة المسائية (02:00 م - 06:00 م)' : 'Afternoon Slots (2:00 PM - 6:00 PM)',
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
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF161F30) : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
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
                            content: Text('${isArabic ? "فشل الحجز" : "Booking failed"}: ${e.toString()}'),
                            backgroundColor: AppTheme.coralRed,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      } finally {
                        if (mounted) setState(() => _isSubmitting = false);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isArabic ? 'تأكيد الحجز ومتابعة الفاتورة' : 'Confirm & View Invoice',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Outfit',
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward_rounded, size: 16),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPatientSelector(AppState state, bool isDark, bool isArabic) {
    final patients = [state.primaryUser, ...state.familyMembers];
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: patients.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final patient = patients[index];
          final isSelected = state.selectedPatient?.id == patient.id;

          return InkWell(
            onTap: () => setState(() => state.selectedPatient = patient),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryBlue
                    : (isDark ? const Color(0xFF161F30) : Colors.white),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryBlue
                      : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 16,
                    color: isSelected ? Colors.white : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    patient.name,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      fontFamily: 'Outfit',
                      color: isSelected ? Colors.white : (isDark ? Colors.white : const Color(0xFF0F172A)),
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

  Widget _buildDatesHorizontalList(bool isDark, Set<String> unavailableSlots) {
    return SizedBox(
      height: 74,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _dates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final date = _dates[index];
          final isSelected = _selectedDate != null &&
              _selectedDate!.year == date.year &&
              _selectedDate!.month == date.month &&
              _selectedDate!.day == date.day;

          final dayName = DateFormat('EEE').format(date);
          final dayNum = DateFormat('d').format(date);
          final monthName = DateFormat('MMM').format(date);

          return InkWell(
            onTap: () {
              setState(() {
                _selectedDate = date;
                if (_selectedTimeSlot != null && unavailableSlots.contains(_selectedTimeSlot)) {
                  _selectedTimeSlot = null;
                }
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 64,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryBlue
                    : (isDark ? const Color(0xFF161F30) : Colors.white),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryBlue
                      : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayName.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white70 : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dayNum,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Outfit',
                      color: isSelected ? Colors.white : (isDark ? Colors.white : const Color(0xFF0F172A)),
                    ),
                  ),
                  Text(
                    monthName,
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white70 : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
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
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 2.1,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        final isUnavailable = unavailableSlots.contains(slot);
        final isSelected = _selectedTimeSlot == slot;

        return InkWell(
          onTap: isUnavailable ? null : () => setState(() => _selectedTimeSlot = slot),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryBlue
                  : (isUnavailable
                      ? (isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9))
                      : (isDark ? const Color(0xFF161F30) : Colors.white)),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? AppTheme.primaryBlue
                    : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
              ),
            ),
            child: Text(
              slot,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                fontFamily: 'Outfit',
                color: isSelected
                    ? Colors.white
                    : (isUnavailable
                        ? (isDark ? Colors.grey.shade700 : Colors.grey.shade400)
                        : (isDark ? Colors.white : const Color(0xFF0F172A))),
                decoration: isUnavailable ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        );
      },
    );
  }
}
