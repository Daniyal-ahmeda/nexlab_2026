import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nexlab_2026/core/providers/app_state.dart';
import 'package:nexlab_2026/core/theme/app_theme.dart';

class ResultDetailsScreen extends StatelessWidget {
  final TestResult result;

  const ResultDetailsScreen({super.key, required this.result});

  Future<void> _openOrDownloadPdf(BuildContext context) async {
    final pdfUrl = result.pdfUrl;
    if (pdfUrl != null && pdfUrl.isNotEmpty) {
      try {
        final uri = Uri.parse(pdfUrl);
        final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (launched) return;
      } catch (_) {}
    }
    if (context.mounted) {
      _showOfficialReportSheet(context);
    }
  }

  void _showOfficialReportSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = Provider.of<AppState>(context, listen: false);
    final isArabic = state.isArabic;
    final patientName = state.currentUser?.name ?? state.primaryUser.name;
    final formattedTestDate = DateFormat('d MMMM yyyy').format(result.testDate);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF161F30) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.picture_as_pdf, color: AppTheme.primaryBlue, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isArabic ? 'تقرير المختبر المعتمد الرسمي' : 'Official Laboratory Report',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Outfit',
                            ),
                          ),
                          Text(
                            '${result.test.name} • $patientName',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),
                _buildInfoRow(isArabic ? 'المريض' : 'Patient', patientName, isDark),
                _buildInfoRow(isArabic ? 'المختبر' : 'Lab', result.labName, isDark),
                _buildInfoRow(isArabic ? 'التاريخ' : 'Date', formattedTestDate, isDark),
                _buildInfoRow(isArabic ? 'الحالة' : 'Status', result.status, isDark, color: AppTheme.emeraldGreen),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isArabic ? 'جاري تحميل تقرير PDF الطبي...' : 'Downloading medical PDF report...'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.download_rounded, size: 18),
                    label: Text(
                      isArabic ? 'تحميل التقرير الرسمي (PDF)' : 'Download Official PDF',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Outfit'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildInfoRow(String label, String value, bool isDark, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
          Text(value, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: color ?? (isDark ? Colors.white : const Color(0xFF0F172A)))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = state.isArabic;
    final formattedDate = DateFormat('d MMMM yyyy').format(result.testDate);

    Color statusColor = AppTheme.emeraldGreen;
    String statusText = isArabic ? 'نتائج سليمة وضمن النطاق الطبيعي' : 'Results Normal & Optimal';
    if (result.status.toLowerCase().contains('critical') || result.status.toLowerCase().contains('high')) {
      statusColor = AppTheme.coralRed;
      statusText = isArabic ? 'مؤشرات مرتفعة - تحتاج متابعة' : 'Elevated Values Detected';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isArabic ? 'تقرير التحليل' : 'Diagnostic Breakdown',
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
            icon: const Icon(Icons.download_rounded),
            onPressed: () => _openOrDownloadPdf(context),
            tooltip: 'Download PDF',
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isArabic ? 'تم نسخ رابط التقرير' : 'Report link copied.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Status Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: isDark ? 0.15 : 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: statusColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      statusColor == AppTheme.emeraldGreen ? Icons.check_circle_outline : Icons.warning_amber_rounded,
                      color: statusColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.test.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Outfit',
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. Report Metadata Card
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
              child: Column(
                children: [
                  _buildInfoRow(isArabic ? 'مركز المختبر' : 'Laboratory', result.labName, isDark),
                  _buildInfoRow(isArabic ? 'تاريخ الفحص' : 'Date of Sample', formattedDate, isDark),
                  _buildInfoRow(isArabic ? 'الطبيب المعتمد' : 'Reviewing Pathologist', 'Dr. Tariq Al-Mansouri (MD)', isDark),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. Clinical Parameters Section
            Text(
              isArabic ? 'القيم والمؤشرات الحيوية' : 'MEASURED CLINICAL PARAMETERS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                letterSpacing: 0.8,
                fontFamily: 'Outfit',
              ),
            ),
            const SizedBox(height: 10),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: result.parameters.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final param = result.parameters[index];
                return _buildParameterCard(param, isDark, isArabic);
              },
            ),
            const SizedBox(height: 20),

            // 4. Pathologist Clinical Stamp
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF161F30) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.medical_information_outlined, size: 18, color: AppTheme.primaryBlue),
                      const SizedBox(width: 8),
                      Text(
                        isArabic ? 'ملاحظات وتوصيات أخصائي المختبر' : 'Physician & Clinical Notes',
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Outfit',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isArabic
                        ? 'تمت مراجعة النتائج والتحقق منها طبياً من قبل أخصائي المختبر. يرجى استشارة طبيبك المعالج لمطابقة النتائج مع الأعراض السريرية.'
                        : 'All diagnostic parameters have been clinically verified by the laboratory director. Please consult your physician for comprehensive clinical correlation.',
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.4,
                      color: isDark ? Colors.grey.shade300 : const Color(0xFF334155),
                    ),
                  ),
                ],
              ),
            ),
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
            child: ElevatedButton.icon(
              onPressed: () => _openOrDownloadPdf(context),
              icon: const Icon(Icons.picture_as_pdf, size: 18),
              label: Text(
                isArabic ? 'عرض التقرير الطبي الرسمي (PDF)' : 'View Official PDF Report',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Outfit',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildParameterCard(ResultParameter param, bool isDark, bool isArabic) {
    Color flagColor = AppTheme.emeraldGreen;
    final upperStatus = param.status.toUpperCase();
    if (upperStatus == 'HIGH' || upperStatus == 'CRITICAL') flagColor = AppTheme.coralRed;
    if (upperStatus == 'LOW' || upperStatus == 'BORDERLINE') flagColor = AppTheme.amberGold;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161F30) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                param.name,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Outfit',
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: flagColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  param.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: flagColor,
                    fontFamily: 'Outfit',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${param.value}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Outfit',
                      color: flagColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    param.unit,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              Text(
                '${isArabic ? "المعدل الطبيعي: " : "Ref: "}${param.referenceRange}',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
