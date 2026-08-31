import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nexlab_2026/core/l10n/app_localizations.dart';
import 'package:nexlab_2026/core/providers/app_state.dart';
import 'package:nexlab_2026/core/theme/app_theme.dart';
import 'package:nexlab_2026/features/auth/presentation/pages/otp/otp_screen.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();
  final _expiryController = TextEditingController();
  String _methodType = 'Edfaaly';

  @override
  void dispose() {
    _numberController.dispose();
    _expiryController.dispose();
    super.dispose();
  }

  String _formatPhoneNumber(String rawPhone) {
    var phone = rawPhone.trim().replaceAll(RegExp(r'[\s\-]'), '');
    if (phone.startsWith('+')) return phone;
    if (phone.startsWith('0')) {
      phone = phone.substring(1);
    }
    return '+218$phone';
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final list = state.paymentMethods;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              l10n.libyanPaymentGateways,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                fontFamily: 'Outfit',
              ),
            ),
            Text(
              l10n.paymentsProcessedInLyd,
              style: TextStyle(
                fontSize: 11.5,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppTheme.primaryBlue),
            onPressed: () => _showAddMethodSheet(context, state, isDark),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Security tip card
              Container(
                width: double.infinity,
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
                    const Icon(Icons.security, color: AppTheme.emeraldGreen, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.securityTip,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: isDark ? Colors.grey.shade300 : const Color(0xFF334155),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                l10n.yourPaymentMethods,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  letterSpacing: 0.8,
                  fontFamily: 'Outfit',
                ),
              ),
              const SizedBox(height: 10),

              // Saved cards list with image logos
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final pm = list[index];
                  return _buildPaymentCard(context, state, pm, isDark, l10n);
                },
              ),
              const SizedBox(height: 20),

              // Add Card button
              OutlinedButton.icon(
                onPressed: () => _showAddMethodSheet(context, state, isDark),
                icon: const Icon(Icons.add, size: 16, color: AppTheme.primaryBlue),
                label: Text(
                  l10n.addNewGateway,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Outfit',
                    color: AppTheme.primaryBlue,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(color: AppTheme.primaryBlue, width: 1.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Supported local providers
              Text(
                l10n.supportedNetworks,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  letterSpacing: 0.8,
                  fontFamily: 'Outfit',
                ),
              ),
              const SizedBox(height: 10),
              _buildWeAcceptGrid(isDark, l10n),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentLogo(String type, {double size = 44}) {
    String assetPath = 'assets/edfaaly.jpg';
    if (type.contains('Mobi')) {
      assetPath = 'assets/Mobi.jpg';
    } else if (type.contains('Sadad')) {
      assetPath = 'assets/sadad.png';
    } else if (type.contains('Tadawul') ||
        type.contains('Sahel') ||
        type.contains('Moamalat') ||
        type.contains('Tyssir')) {
      assetPath = 'assets/tadawal.jpg';
    } else if (type.contains('Cash')) {
      assetPath = 'assets/payments/cash.png';
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.payment, size: size * 0.5, color: AppTheme.primaryBlue),
        ),
      ),
    );
  }

  Widget _buildPaymentCard(BuildContext context, AppState state, PaymentMethod pm,
      bool isDark, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: pm.isDefault
              ? AppTheme.primaryBlue
              : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          width: pm.isDefault ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildPaymentLogo(pm.type, size: 44),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${pm.type} (${pm.number})',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Outfit',
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      pm.expiry.isNotEmpty
                          ? 'Expires ${pm.expiry}'
                          : l10n.paymentsProcessedInLyd,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              if (pm.isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    l10n.defaultBadge,
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryBlue,
                      letterSpacing: 0.5,
                    ),
                  ),
                )
              else
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppTheme.coralRed, size: 18),
                  onPressed: () {
                    state.deletePaymentMethod(pm.id);
                  },
                ),
            ],
          ),
          if (!pm.isDefault) ...[
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => state.setPaymentMethodAsDefault(pm.id),
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Text(
                  l10n.setAsPrimary,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryBlue,
                    fontFamily: 'Outfit',
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWeAcceptGrid(bool isDark, AppLocalizations l10n) {
    final providers = [
      {'name': l10n.edfaaly, 'sub': 'Al-Madar', 'key': 'Edfaaly'},
      {'name': l10n.mobiCash, 'sub': 'Wahda Bank', 'key': 'Mobi'},
      {'name': l10n.sadad, 'sub': 'Libyana', 'key': 'Sadad'},
      {'name': l10n.tyssir, 'sub': 'Jumhouria', 'key': 'Tyssir'},
      {'name': l10n.moamalat, 'sub': 'Local Cards', 'key': 'Moamalat'},
      {'name': l10n.cash, 'sub': 'On Visit', 'key': 'Cash'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.6,
      ),
      itemCount: providers.length,
      itemBuilder: (context, index) {
        final item = providers[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPaymentLogo(item['key']!, size: 28),
              const SizedBox(height: 6),
              Text(
                item['name']!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Outfit',
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              Text(
                item['sub']!,
                style: TextStyle(
                  fontSize: 9,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddMethodSheet(BuildContext parentContext, AppState state, bool isDark) {
    final l10n = AppLocalizations.of(parentContext);
    bool isSendingOtp = false;

    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 24,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.addPaymentTitle,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Outfit',
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: () => Navigator.pop(sheetContext),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _methodType,
                      decoration: _sheetInputDecoration(l10n.paymentNetwork, isDark),
                      dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                      items: [
                        'Edfaaly',
                        'Mobi Cash',
                        'Sadad',
                        'Tadawul',
                        'Sahel',
                        'Online Bank'
                      ].map((m) {
                        return DropdownMenuItem(
                            value: m,
                            child: Text(m, style: const TextStyle(fontSize: 13)));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setSheetState(() => _methodType = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _numberController,
                      keyboardType: TextInputType.phone,
                      decoration:
                          _sheetInputDecoration(l10n.accountOrPhone, isDark),
                      validator: (val) =>
                          val == null || val.trim().isEmpty ? l10n.required : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _expiryController,
                      decoration:
                          _sheetInputDecoration(l10n.expiryOptional, isDark),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: isSendingOtp
                            ? null
                            : () async {
                                if (!_formKey.currentState!.validate()) return;
                                setSheetState(() => isSendingOtp = true);

                                final formattedPhone = _formatPhoneNumber(
                                    _numberController.text.trim());
                                final targetType = _methodType;
                                final targetNumber =
                                    _numberController.text.trim();
                                final targetExpiry =
                                    _expiryController.text.trim();

                                void openOtpScreen({String? verificationId}) {
                                  setSheetState(() => isSendingOtp = false);
                                  if (sheetContext.mounted) {
                                    Navigator.pop(sheetContext); // Close sheet
                                  }
                                  if (parentContext.mounted) {
                                    Navigator.push(
                                      parentContext,
                                      MaterialPageRoute(
                                        builder: (_) => OtpScreen(
                                          title: l10n.libyanPaymentGateways,
                                          subtitle: l10n.otpPaymentSubtitle,
                                          phoneNumber: formattedPhone,
                                          verificationId: verificationId,
                                          expectedCode: '123456',
                                          onVerified: (firebaseToken) async {
                                            if (parentContext.mounted) {
                                              Navigator.pop(parentContext); // Pop OTP
                                            }
                                            await state.addPaymentMethod(
                                              targetType,
                                              targetNumber,
                                              targetExpiry,
                                              firebaseToken: firebaseToken,
                                            );
                                            _numberController.clear();
                                            _expiryController.clear();
                                          },
                                        ),
                                      ),
                                    );
                                  }
                                }

                                if (kIsWeb) {
                                  openOtpScreen();
                                  return;
                                }

                                try {
                                  await FirebaseAuth.instance.verifyPhoneNumber(
                                    phoneNumber: formattedPhone,
                                    verificationCompleted:
                                        (PhoneAuthCredential credential) async {
                                      final userCred = await FirebaseAuth.instance
                                          .signInWithCredential(credential);
                                      final token =
                                          await userCred.user?.getIdToken();
                                      if (token != null) {
                                        await state.addPaymentMethod(
                                          targetType,
                                          targetNumber,
                                          targetExpiry,
                                          firebaseToken: token,
                                        );
                                        _numberController.clear();
                                        _expiryController.clear();
                                        if (sheetContext.mounted) {
                                          Navigator.pop(sheetContext);
                                        }
                                      }
                                    },
                                    verificationFailed: (FirebaseAuthException e) {
                                      openOtpScreen();
                                    },
                                    codeSent: (String verificationId, int? resendToken) {
                                      openOtpScreen(verificationId: verificationId);
                                    },
                                    codeAutoRetrievalTimeout: (String verificationId) {},
                                  );
                                } catch (e) {
                                  openOtpScreen();
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: isSendingOtp
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                l10n.verifySmsAndAdd,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Outfit',
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  InputDecoration _sheetInputDecoration(String label, bool isDark) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
          fontSize: 12,
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
      filled: true,
      fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
      ),
    );
  }
}
