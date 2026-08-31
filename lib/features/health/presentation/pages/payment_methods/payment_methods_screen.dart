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
    if (phone.startsWith('0')) phone = phone.substring(1);
    return '+218$phone';
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final list = state.paymentMethods;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              l10n.libyanPaymentGateways,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
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
            icon: const Icon(Icons.add_circle_outline_rounded, color: AppTheme.primaryBlue),
            onPressed: () => _showAddMethodSheet(context, state, isDark),
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
            // Security Card
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
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.emeraldGreen.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.shield_outlined, color: AppTheme.emeraldGreen, size: 20),
                  ),
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

            // Saved Payment Gateways Header
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

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final pm = list[index];
                return _buildPaymentCard(context, state, pm, isDark, l10n);
              },
            ),
            const SizedBox(height: 16),

            // Add new gateway button
            OutlinedButton.icon(
              onPressed: () => _showAddMethodSheet(context, state, isDark),
              icon: const Icon(Icons.add_rounded, size: 18, color: AppTheme.primaryBlue),
              label: Text(
                l10n.addNewGateway,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Outfit',
                  color: AppTheme.primaryBlue,
                ),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                side: const BorderSide(color: AppTheme.primaryBlue),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),

            // Supported Libyan Networks Grid
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
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentLogo(String type, {double size = 44}) {
    String assetPath = 'assets/edfaaly.jpg';
    if (type.contains('Mobi')) assetPath = 'assets/Mobi.jpg';
    if (type.contains('Sadad')) assetPath = 'assets/sadad.png';
    if (type.contains('Tadawul') || type.contains('Sahel') || type.contains('Moamalat') || type.contains('Tyssir')) {
      assetPath = 'assets/tadawal.jpg';
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(Icons.account_balance_wallet_outlined, size: size * 0.5, color: AppTheme.primaryBlue),
        ),
      ),
    );
  }

  Widget _buildPaymentCard(BuildContext context, AppState state, PaymentMethod pm, bool isDark, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161F30) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: pm.isDefault
              ? AppTheme.primaryBlue.withValues(alpha: 0.4)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
        ),
        boxShadow: AppTheme.cardShadow(isDark),
      ),
      child: Row(
        children: [
          _buildPaymentLogo(pm.type),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      pm.type,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Outfit',
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    if (pm.isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          l10n.defaultMethod,
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  pm.number,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, size: 20, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
            onSelected: (action) {
              if (action == 'default') state.setPaymentMethodAsDefault(pm.id);
              if (action == 'delete') state.deletePaymentMethod(pm.id);
            },
            itemBuilder: (context) => [
              if (!pm.isDefault)
                PopupMenuItem(value: 'default', child: Text(l10n.setAsDefault)),
              PopupMenuItem(
                value: 'delete',
                child: Text(l10n.deleteMethod, style: const TextStyle(color: AppTheme.coralRed)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeAcceptGrid(bool isDark, AppLocalizations l10n) {
    final gateways = [
      {'name': l10n.gatewayEdfaaly, 'asset': 'assets/edfaaly.jpg'},
      {'name': l10n.gatewayMobiCash, 'asset': 'assets/Mobi.jpg'},
      {'name': l10n.gatewaySadad, 'asset': 'assets/sadad.png'},
      {'name': l10n.gatewayTadawul, 'asset': 'assets/tadawal.jpg'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.6,
      ),
      itemCount: gateways.length,
      itemBuilder: (context, index) {
        final g = gateways[index];
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF161F30) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            children: [
              _buildPaymentLogo(g['name']!, size: 34),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  g['name']!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Outfit',
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddMethodSheet(BuildContext context, AppState state, bool isDark) {
    final l10n = AppLocalizations.of(context);
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
                        l10n.addPaymentMethodTitle,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Outfit'),
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value: _methodType,
                        decoration: InputDecoration(
                          labelText: l10n.selectPaymentGateway,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: ['Edfaaly', 'Mobi Cash', 'Sadad', 'Tadawul', 'Sahel', 'Moamalat', 'Tyssir'].map((t) {
                          return DropdownMenuItem(value: t, child: Text(t));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setSheetState(() => _methodType = val);
                        },
                      ),
                      const SizedBox(height: 14),

                      TextFormField(
                        controller: _numberController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: l10n.walletOrCardNumber,
                          hintText: '0912345678 / 0923456789',
                          prefixIcon: const Icon(Icons.phone_android_rounded, size: 20),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty ? l10n.enterAccountNumber : null,
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final phone = _formatPhoneNumber(_numberController.text);
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OtpScreen(
                                    phoneNumber: phone,
                                    title: '${l10n.verifyCode} - $_methodType',
                                    subtitle: l10n.enterOtpSubtitle,
                                    onVerified: (token) {
                                      Navigator.pop(context);
                                      state.addPaymentMethod(
                                        _methodType,
                                        _numberController.text.trim(),
                                        '12/28',
                                        firebaseToken: token,
                                      );
                                      _numberController.clear();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(l10n.paymentMethodAddedSuccess),
                                          backgroundColor: AppTheme.emeraldGreen,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.sms_outlined, size: 18),
                          label: Text(
                            l10n.verifyViaSmsAndAdd,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Outfit'),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
}
