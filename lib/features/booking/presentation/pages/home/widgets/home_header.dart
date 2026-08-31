import 'package:flutter/material.dart';
import 'package:nexlab_2026/core/providers/app_state.dart';
import 'package:nexlab_2026/core/theme/app_theme.dart';
import 'package:nexlab_2026/features/health/presentation/pages/results/results_screen.dart';
import 'package:nexlab_2026/features/health/presentation/pages/result_details/result_details_screen.dart';
import 'package:nexlab_2026/shared/widgets/nexlab_logo.dart';

class HomeHeader extends StatelessWidget {
  final AppState state;
  final bool isDark;

  const HomeHeader({
    super.key,
    required this.state,
    required this.isDark,
  });

  void _showNotificationsSheet(BuildContext context) {
    final isArabic = state.isArabic;
    final notifications = state.notifications;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF161F30) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.notifications_active_outlined, size: 20, color: AppTheme.primaryBlue),
                        const SizedBox(width: 8),
                        Text(
                          isArabic ? 'الإشعارات والتنبيهات الطبية' : 'Medical Notifications',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Outfit',
                          ),
                        ),
                      ],
                    ),
                    if (notifications.isNotEmpty)
                      TextButton(
                        onPressed: () {
                          state.markAllNotificationsRead();
                          Navigator.pop(ctx);
                        },
                        child: Text(
                          isArabic ? 'تعيين كمقروء' : 'Mark all read',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.primaryBlue),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                if (notifications.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(Icons.mark_email_read_outlined, size: 40, color: isDark ? Colors.grey.shade600 : Colors.grey.shade400),
                        const SizedBox(height: 10),
                        Text(
                          isArabic ? 'لا توجد إشعارات جديدة حالياً' : 'No new notifications',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isArabic
                              ? 'ستصلك إشعارات فورية عند جاهزية نتائج التحاليل وسحب العينات'
                              : 'You will receive instant alerts when diagnostic results are published',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: notifications.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = notifications[index];
                        final isUnread = item['read'] != 'true';
                        final resultId = item['result_id'] ?? '';

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isUnread
                                  ? AppTheme.primaryBlue.withValues(alpha: 0.15)
                                  : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.science_outlined,
                              size: 18,
                              color: isUnread ? AppTheme.primaryBlue : Colors.grey,
                            ),
                          ),
                          title: Text(
                            item['title'] ?? (isArabic ? 'تقرير طبي جديد' : 'New Medical Result'),
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: isUnread ? FontWeight.w800 : FontWeight.w600,
                              fontFamily: 'Outfit',
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          subtitle: Text(
                            item['body'] ?? (isArabic ? 'تم نشر نتيجة الفحص المخبري الخاص بك' : 'Your diagnostic report has been submitted and is ready to view.'),
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                          trailing: isUnread
                              ? Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppTheme.primaryBlue,
                                    shape: BoxShape.circle,
                                  ),
                                )
                              : null,
                          onTap: () {
                            state.markNotificationRead(index);
                            Navigator.pop(ctx);
                            if (resultId.isNotEmpty && state.results.any((r) => r.id == resultId)) {
                              final matchedResult = state.results.firstWhere((r) => r.id == resultId);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => ResultDetailsScreen(result: matchedResult)),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const ResultsScreen()),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userName = state.currentUser?.name ?? state.primaryUser.name;
    final initial = userName.isNotEmpty ? userName[0].toUpperCase() : 'M';
    final unreadCount = state.unreadNotificationCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Brand & Utility Bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NexLabLogo(
              useFullLogo: true,
              height: 26,
              isWhite: isDark,
            ),
            Row(
              children: [
                // Language Quick Switcher
                InkWell(
                  onTap: () => state.toggleLocale(),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.language, size: 14, color: AppTheme.primaryBlue),
                        const SizedBox(width: 5),
                        Text(
                          state.isArabic ? 'EN' : 'عربي',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primaryBlue,
                            fontFamily: 'Outfit',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Notification Bell Icon with Badge
                Stack(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                        ),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          unreadCount > 0 ? Icons.notifications_active_outlined : Icons.notifications_none_rounded,
                          size: 19,
                          color: unreadCount > 0 ? AppTheme.primaryBlue : (isDark ? Colors.white : const Color(0xFF0F172A)),
                        ),
                        onPressed: () => _showNotificationsSheet(context),
                      ),
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        top: 5,
                        right: 5,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppTheme.coralRed,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),

        // User Profile & Location Row
        Row(
          children: [
            // Glowing Avatar
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppTheme.oceanGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Outfit',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // User info & Tripoli location badge
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        state.isArabic ? 'مرحباً، ' : 'Hello, ',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          userName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Outfit',
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: AppTheme.emeraldGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        state.isArabic ? 'طرابلس، ليبيا' : 'Tripoli, Libya',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
