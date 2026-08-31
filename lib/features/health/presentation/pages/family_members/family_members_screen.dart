import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nexlab_2026/core/l10n/app_localizations.dart';
import 'package:nexlab_2026/core/providers/app_state.dart';
import 'package:nexlab_2026/core/theme/app_theme.dart';

class FamilyMembersScreen extends StatefulWidget {
  const FamilyMembersScreen({super.key});

  @override
  State<FamilyMembersScreen> createState() => _FamilyMembersScreenState();
}

class _FamilyMembersScreenState extends State<FamilyMembersScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String _relationship = 'Spouse';
  String _gender = 'Female';
  String _bloodGroup = 'A+';

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _showAddMemberSheet(BuildContext context, AppState state, bool isDark) {
    final isArabic = state.isArabic;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF161F30) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isArabic ? 'إضافة فرد جديد للعائلة' : 'Add Family Member',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Outfit',
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Name Field
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: isArabic ? 'الاسم الكامل' : 'Full Name',
                          prefixIcon: const Icon(Icons.person_outline, size: 20),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty ? (isArabic ? 'يرجى إدخال الاسم' : 'Please enter name') : null,
                      ),
                      const SizedBox(height: 14),

                      // Age & Gender Row
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _ageController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: isArabic ? 'العمر' : 'Age',
                                prefixIcon: const Icon(Icons.cake_outlined, size: 20),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              validator: (val) => val == null || int.tryParse(val) == null ? (isArabic ? 'عمر صحيح' : 'Valid age') : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _gender,
                              decoration: InputDecoration(
                                labelText: isArabic ? 'الجنس' : 'Gender',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              items: ['Male', 'Female'].map((g) {
                                return DropdownMenuItem(
                                  value: g,
                                  child: Text(g == 'Male' ? (isArabic ? 'ذكر' : 'Male') : (isArabic ? 'أنثى' : 'Female')),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setSheetState(() => _gender = val);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Relationship & Blood Group Row
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _relationship,
                              decoration: InputDecoration(
                                labelText: isArabic ? 'صلة القرابة' : 'Relationship',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              items: ['Spouse', 'Child', 'Parent', 'Sibling', 'Other'].map((r) {
                                String label = r;
                                if (isArabic) {
                                  if (r == 'Spouse') label = 'الزوج / الزوجة';
                                  if (r == 'Child') label = 'ابن / ابنة';
                                  if (r == 'Parent') label = 'أب / أم';
                                  if (r == 'Sibling') label = 'أخ / أخت';
                                  if (r == 'Other') label = 'آخر';
                                }
                                return DropdownMenuItem(value: r, child: Text(label));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setSheetState(() => _relationship = val);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _bloodGroup,
                              decoration: InputDecoration(
                                labelText: isArabic ? 'فصيلة الدم' : 'Blood Type',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'].map((bg) {
                                return DropdownMenuItem(value: bg, child: Text(bg));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setSheetState(() => _bloodGroup = val);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              state.addFamilyMember(
                                _nameController.text.trim(),
                                _relationship,
                                int.parse(_ageController.text.trim()),
                                _gender,
                                _bloodGroup,
                              );
                              Navigator.pop(context);
                              _nameController.clear();
                              _ageController.clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(isArabic ? 'تم إضافة الفرد بنجاح' : 'Family member added.'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            isArabic ? 'حفظ وإضافة الفرد' : 'Save Member',
                            style: const TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Outfit'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = state.isArabic;
    final l10n = AppLocalizations.of(context);
    final dependents = state.familyMembers.where((m) => m.relationship != 'Self').toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.familyMembers,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded, color: AppTheme.primaryBlue),
            onPressed: () => _showAddMemberSheet(context, state, isDark),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Primary User Card
            Text(
              isArabic ? 'صاحب الحساب الأساسي' : 'PRIMARY ACCOUNT OWNER',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                letterSpacing: 0.8,
                fontFamily: 'Outfit',
              ),
            ),
            const SizedBox(height: 10),
            _buildMemberCard(state.primaryUser, isDark, isArabic, isPrimary: true),
            const SizedBox(height: 24),

            // 2. Family Members List Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isArabic ? 'أفراد العائلة المسجلين' : 'REGISTERED FAMILY MEMBERS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    letterSpacing: 0.8,
                    fontFamily: 'Outfit',
                  ),
                ),
                Text(
                  '${dependents.length} ${isArabic ? "أفراد" : "members"}',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryBlue,
                    fontFamily: 'Outfit',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (dependents.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                alignment: Alignment.center,
                child: Text(
                  isArabic ? 'لم تقم بإضافة أي أفراد عائلة بعد' : 'No family members registered yet',
                  style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dependents.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final member = dependents[index];
                  return _buildMemberCard(
                    member,
                    isDark,
                    isArabic,
                    onDelete: () => state.deleteFamilyMember(member.id),
                  );
                },
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMemberSheet(context, state, isDark),
        backgroundColor: AppTheme.primaryBlue,
        icon: const Icon(Icons.person_add_rounded, color: Colors.white),
        label: Text(
          isArabic ? 'إضافة فرد جديد' : 'Add Member',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontFamily: 'Outfit'),
        ),
      ),
    );
  }

  Widget _buildMemberCard(
    FamilyMember member,
    bool isDark,
    bool isArabic, {
    bool isPrimary = false,
    VoidCallback? onDelete,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161F30) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPrimary
              ? AppTheme.primaryBlue.withValues(alpha: 0.3)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
        ),
        boxShadow: AppTheme.cardShadow(isDark),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: isPrimary ? AppTheme.oceanGradient : AppTheme.blueGradient,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                member.name.isNotEmpty ? member.name[0].toUpperCase() : 'M',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Outfit',
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        member.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Outfit',
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: (isPrimary ? AppTheme.emeraldGreen : AppTheme.primaryBlue).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        member.relationship,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isPrimary ? AppTheme.emeraldGreen : AppTheme.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${member.age} ${isArabic ? "سنة" : "yrs"}',
                      style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '•',
                      style: TextStyle(color: isDark ? Colors.grey.shade600 : Colors.grey.shade400),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      member.gender,
                      style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '•',
                      style: TextStyle(color: isDark ? Colors.grey.shade600 : Colors.grey.shade400),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppTheme.coralRed.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        member.bloodGroup,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.coralRed),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: AppTheme.coralRed, size: 20),
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }
}
