import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:nexlab_2026/core/l10n/app_localizations.dart';
import 'package:nexlab_2026/core/providers/app_state.dart';
import 'package:nexlab_2026/core/theme/app_theme.dart';
import 'package:nexlab_2026/features/health/presentation/pages/result_details/result_details_screen.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppState>(context, listen: false).refreshResults();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = state.isArabic;
    final l10n = AppLocalizations.of(context);
    final list = state.results;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.testResults,
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
            icon: const Icon(Icons.refresh),
            onPressed: () => state.refreshResults(),
            tooltip: isArabic ? 'تحديث النتائج' : 'Refresh Reports',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => state.refreshResults(),
        color: AppTheme.primaryBlue,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isArabic ? 'التقارير المخبرية' : 'Diagnostic Reports',
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
                    ? '${list.length} تقارير طبية رسمية جاهزة'
                    : '${list.length} official diagnostic report${list.length == 1 ? '' : 's'} available',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 20),

              if (list.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 80),
                    child: Column(
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          size: 48,
                          color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          isArabic ? 'لا توجد نتائج تحاليل حالياً' : 'No diagnostic reports yet',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Outfit',
                            color: isDark ? Colors.grey.shade300 : const Color(0xFF374151),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          isArabic
                              ? 'بمجرد معالجة عيناتك في المختبر، ستظهر التقارير هنا فوراً.'
                              : 'Once your lab samples are processed, official reports will appear here.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
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
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final result = list[index];
                    return _buildResultCard(context, result, isDark, isArabic);
                  },
                ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, TestResult result, bool isDark, bool isArabic) {
    final formattedDate = DateFormat('d MMM yyyy').format(result.testDate);

    Color statusColor = AppTheme.emeraldGreen;
    String statusText = isArabic ? 'سليم وطبيعي' : 'NORMAL';
    if (result.status.toLowerCase().contains('critical') || result.status.toLowerCase().contains('high')) {
      statusColor = AppTheme.coralRed;
      statusText = isArabic ? 'تنبيه سريري' : 'CRITICAL';
    } else if (result.status.toLowerCase().contains('review')) {
      statusColor = AppTheme.amberGold;
      statusText = isArabic ? 'يحتاج متابعة' : 'REVIEW';
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ResultDetailsScreen(result: result)),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF161F30) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          ),
          boxShadow: AppTheme.cardShadow(isDark),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              result.test.name,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Outfit',
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              statusText,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Outfit',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        result.labName,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.calendar_today_rounded, size: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                              const SizedBox(width: 4),
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            isArabic ? 'عرض التقرير التفصيلي ←' : 'View Full Report →',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primaryBlue,
                              fontFamily: 'Outfit',
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
    );
  }
}
