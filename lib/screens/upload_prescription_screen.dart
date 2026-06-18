import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class UploadPrescriptionScreen extends StatefulWidget {
  const UploadPrescriptionScreen({super.key});

  @override
  State<UploadPrescriptionScreen> createState() => _UploadPrescriptionScreenState();
}

class _UploadPrescriptionScreenState extends State<UploadPrescriptionScreen> {
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  String _uploadStatusText = '';

  void _simulateUpload(AppState state, String method) async {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
      _uploadStatusText = 'Connecting to camera/gallery...';
    });

    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;

    setState(() {
      _uploadStatusText = 'Uploading document...';
      _uploadProgress = 0.3;
    });

    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    setState(() {
      _uploadStatusText = 'Analyzing prescription with Nexlab AI...';
      _uploadProgress = 0.7;
    });

    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    setState(() {
      _uploadProgress = 1.0;
      _uploadStatusText = 'Success! File registered.';
    });

    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    state.uploadPrescription('prescription_${DateTime.now().millisecondsSinceEpoch}.jpg');

    setState(() {
      _isUploading = false;
    });

    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.check_circle, color: AppTheme.emeraldGreen, size: 50),
          title: const Text('Prescription Uploaded'),
          content: const Text(
            'We have received your prescription. Our medical technicians will analyze it and suggest the appropriate tests within 30 minutes.',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Pop dialog
                Navigator.pop(context); // Pop screen
              },
              child: const Text('Go Back'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Prescription'),
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
              // Why upload description card
              _buildBenefitsCard(theme),
              const SizedBox(height: 28),

              Text(
                'Choose Upload Method',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              if (_isUploading)
                _buildUploadProgressCard(theme)
              else ...[
                _buildUploadMethodCard(
                  theme: theme,
                  title: 'Take Photo',
                  subtitle: 'Use camera to capture prescription',
                  icon: Icons.camera_alt_outlined,
                  color: AppTheme.primaryBlue,
                  onTap: () => _simulateUpload(state, 'camera'),
                ),
                const SizedBox(height: 16),
                _buildUploadMethodCard(
                  theme: theme,
                  title: 'Upload from Gallery',
                  subtitle: 'Select from your photo library',
                  icon: Icons.photo_library_outlined,
                  color: AppTheme.purpleAmethyst,
                  onTap: () => _simulateUpload(state, 'gallery'),
                ),
              ],
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitsCard(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryBlue.withOpacity(0.12),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Why Upload Prescription?',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          _buildBenefitRow(theme, 'Our team will review and suggest relevant tests'),
          const SizedBox(height: 12),
          _buildBenefitRow(theme, 'Get accurate pricing and package recommendations'),
          const SizedBox(height: 12),
          _buildBenefitRow(theme, 'Maintain digital health records for easy access'),
        ],
      ),
    );
  }

  Widget _buildBenefitRow(ThemeData theme, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle_outline, color: AppTheme.primaryBlue, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 13,
              color: theme.brightness == Brightness.dark ? Colors.grey.shade300 : Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadMethodCard({
    required ThemeData theme,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 14, color: theme.hintColor.withOpacity(0.5)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadProgressCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SizedBox(
              height: 56,
              width: 56,
              child: CircularProgressIndicator(
                value: _uploadProgress,
                strokeWidth: 4,
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _uploadStatusText,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(_uploadProgress * 100).toInt()}% completed',
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
