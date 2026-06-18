import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class ResultDetailsScreen extends StatelessWidget {
  final TestResult result;

  const ResultDetailsScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDate = DateFormat('MMMM d, yyyy').format(result.testDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Details'),
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
              // Summary card
              _buildSummaryHeader(formattedDate, theme),
              const SizedBox(height: 24),

              Text(
                'Biomarkers & Parameters',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Parameter Cards with status meters
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: result.parameters.length,
                separatorBuilder: (context, index) => const SizedBox(height: 18),
                itemBuilder: (context, index) {
                  final param = result.parameters[index];
                  return _buildParameterCard(param, theme);
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryHeader(String formattedDate, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.blueGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  result.test.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Outfit',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Verified',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 12),
          _buildHeaderInfoRow(Icons.business_outlined, 'Diagnostics Lab', result.labName),
          const SizedBox(height: 8),
          _buildHeaderInfoRow(Icons.calendar_today_outlined, 'Test Date', formattedDate),
          const SizedBox(height: 8),
          _buildHeaderInfoRow(Icons.person_outline, 'Patient', 'Monder (Self)'),
        ],
      ),
    );
  }

  Widget _buildHeaderInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.white70),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildParameterCard(ResultParameter param, ThemeData theme) {
    // Determine colors & positions based on status
    Color statusColor = AppTheme.emeraldGreen;
    double sliderVal = 0.5; // normal position: center of bar

    if (param.status == 'Low') {
      statusColor = AppTheme.orangeSunset;
      sliderVal = 0.2; // left side
    } else if (param.status == 'High') {
      statusColor = AppTheme.coralRed;
      sliderVal = 0.8; // right side
    } else if (param.status == 'Borderline') {
      statusColor = AppTheme.amberGold;
      sliderVal = 0.65; // middle-right
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        param.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ref Range: ${param.referenceRange}',
                        style: theme.textTheme.bodyMedium?.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          param.value,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                            fontFamily: 'Outfit',
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          param.unit,
                          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 10),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        param.status.toUpperCase(),
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Horizontal score gauge visual
            Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Multi-colored track line
                    Container(
                      height: 6,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        gradient: const LinearGradient(
                          colors: [
                            AppTheme.orangeSunset,  // Low
                            AppTheme.emeraldGreen,  // Normal
                            AppTheme.amberGold,     // Borderline
                            AppTheme.coralRed,      // High
                          ],
                          stops: [0.15, 0.5, 0.75, 0.95],
                        ),
                      ),
                    ),
                    // Pointer arrow/pin aligning dynamically
                    Align(
                      alignment: Alignment(sliderVal * 2 - 1, 0),
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: statusColor.withOpacity(0.5),
                              blurRadius: 6,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Low', style: theme.textTheme.bodyMedium?.copyWith(fontSize: 9)),
                    Text('Normal', style: theme.textTheme.bodyMedium?.copyWith(fontSize: 9, fontWeight: FontWeight.bold)),
                    Text('Borderline', style: theme.textTheme.bodyMedium?.copyWith(fontSize: 9)),
                    Text('High', style: theme.textTheme.bodyMedium?.copyWith(fontSize: 9)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
