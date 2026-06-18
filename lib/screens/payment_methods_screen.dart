import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();
  final _expiryController = TextEditingController();
  String _cardType = 'Visa';

  @override
  void dispose() {
    _numberController.dispose();
    _expiryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final theme = Theme.of(context);
    final list = state.paymentMethods;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Payment Methods'),
            Text(
              '${list.length} methods saved',
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
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: const BoxDecoration(
              color: AppTheme.primaryBlue,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white, size: 20),
              onPressed: () => _showAddMethodSheet(context, state),
            ),
          )
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
              _buildSecurityTip(theme),
              const SizedBox(height: 24),

              Text(
                'SAVED METHODS',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: theme.hintColor,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),

              // Saved cards list
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final pm = list[index];
                  return _buildPaymentCard(context, state, pm, theme);
                },
              ),
              const SizedBox(height: 20),

              // Dashed Add Card button
              _buildDashedAddButton(context, state, theme),
              const SizedBox(height: 28),

              // We Accept
              Text(
                'WE ACCEPT',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: theme.hintColor,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 16),
              _buildWeAcceptGrid(theme),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityTip(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryBlue.withOpacity(0.12),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, color: AppTheme.primaryBlue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'All payment information is encrypted and secure. We never store your CVV.',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                color: theme.brightness == Brightness.dark ? Colors.grey.shade300 : Colors.grey.shade700,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPaymentCard(BuildContext context, AppState state, PaymentMethod pm, ThemeData theme) {
    IconData cardIcon = Icons.credit_card;
    Color iconColor = AppTheme.primaryBlue;

    if (pm.type == 'UPI') {
      cardIcon = Icons.phone_android;
      iconColor = AppTheme.purpleAmethyst;
    } else if (pm.type == 'Mastercard') {
      cardIcon = Icons.credit_card;
      iconColor = AppTheme.orangeSunset;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                // Card icon container
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark
                        ? Colors.grey.shade800
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(cardIcon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 16),

                // Card details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${pm.type} ${pm.type == "UPI" ? "" : "•••• "}${pm.number.replaceAll("•••• ", "")}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (pm.expiry.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Expires ${pm.expiry}',
                          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                ),

                // Delete trash button (except default)
                if (!pm.isDefault)
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.coralRed.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppTheme.coralRed, size: 16),
                      onPressed: () {
                        state.deletePaymentMethod(pm.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Payment method deleted'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),

            // Default actions row
            Row(
              children: [
                if (pm.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.check, color: AppTheme.primaryBlue, size: 12),
                        SizedBox(width: 4),
                        Text(
                          'Default',
                          style: TextStyle(
                            color: AppTheme.primaryBlue,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  TextButton(
                    onPressed: () => state.setPaymentMethodAsDefault(pm.id),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Set as Default',
                      style: TextStyle(
                        color: AppTheme.primaryBlue,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashedAddButton(BuildContext context, AppState state, ThemeData theme) {
    return InkWell(
      onTap: () => _showAddMethodSheet(context, state),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.primaryColor.withOpacity(0.4),
            width: 1.5,
            style: BorderStyle.solid, // Dynamic dashes are hard, normal colored solid border fits clean
          ),
          color: theme.cardTheme.color?.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: theme.primaryColor, size: 18),
            const SizedBox(width: 8),
            Text(
              'Add Payment Method',
              style: TextStyle(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                fontFamily: 'Outfit',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeAcceptGrid(ThemeData theme) {
    final list = ['Visa', 'Mastercard', 'Amex', 'UPI', 'PayPal', 'Apple Pay'];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: list.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: theme.brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200,
            ),
          ),
          child: Text(
            item,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: theme.brightness == Brightness.dark ? Colors.grey.shade300 : Colors.grey.shade700,
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showAddMethodSheet(BuildContext context, AppState state) {
    _numberController.clear();
    _expiryController.clear();
    _cardType = 'Visa';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AnimatedPadding(
              duration: const Duration(milliseconds: 100),
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                padding: const EdgeInsets.all(24),
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
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Add Payment Method',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),

                      // Method Type Selector
                      DropdownButtonFormField<String>(
                        value: _cardType,
                        decoration: const InputDecoration(
                          labelText: 'Payment Method Type',
                          border: OutlineInputBorder(),
                        ),
                        items: ['Visa', 'Mastercard', 'UPI']
                            .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() => _cardType = val);
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Number Field
                      TextFormField(
                        controller: _numberController,
                        keyboardType: _cardType == 'UPI' ? TextInputType.emailAddress : TextInputType.number,
                        decoration: InputDecoration(
                          labelText: _cardType == 'UPI' ? 'UPI ID' : 'Card Number',
                          hintText: _cardType == 'UPI' ? 'name@upi' : '1234 5678 9012 3456',
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return _cardType == 'UPI' ? 'Enter UPI ID' : 'Enter Card Number';
                          }
                          return null;
                        },
                      ),
                      
                      if (_cardType != 'UPI') ...[
                        const SizedBox(height: 16),
                        // Expiry Field
                        TextFormField(
                          controller: _expiryController,
                          keyboardType: TextInputType.datetime,
                          decoration: const InputDecoration(
                            labelText: 'Expiry Date',
                            hintText: 'MM/YY',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter expiry date';
                            }
                            return null;
                          },
                        ),
                      ],
                      const SizedBox(height: 24),

                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Extract card last 4 digits
                            String formattedNum = _numberController.text;
                            if (_cardType != 'UPI' && formattedNum.length >= 4) {
                              formattedNum = '•••• ${formattedNum.substring(formattedNum.length - 4)}';
                            }
                            state.addPaymentMethod(_cardType, formattedNum, _expiryController.text);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('New payment method added!'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: const Text('Save Payment Method', style: TextStyle(fontWeight: FontWeight.bold)),
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
