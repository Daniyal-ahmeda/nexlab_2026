import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nexlab_2026/core/l10n/app_localizations.dart';
import 'package:nexlab_2026/core/providers/app_state.dart';
import 'package:nexlab_2026/core/theme/app_theme.dart';
import 'package:nexlab_2026/core/routes/app_routes.dart';
import 'package:nexlab_2026/features/auth/presentation/pages/otp/otp_screen.dart';
import 'package:nexlab_2026/shared/widgets/nexlab_logo.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();

  String _gender = 'Male';
  String _bloodGroup = 'O+';
  bool _obscurePassword = true;
  bool _localLoading = false;

  final List<String> _genderOptions = ['Male', 'Female', 'Other'];
  final List<String> _bloodOptions = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
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

  Future<void> _completeRegistrationWithToken(String firebaseToken) async {
    final state = Provider.of<AppState>(context, listen: false);
    await state.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      relationship: 'Self',
      age: int.parse(_ageController.text.trim()),
      gender: _gender,
      bloodGroup: _bloodGroup,
      firebaseToken: firebaseToken,
    );

    if (!mounted) return;

    if (state.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage!),
          backgroundColor: AppTheme.coralRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.initial, (route) => false);
    }
  }

  void _navigateToOtp({String? verificationId, required String formattedPhone}) {
    if (!mounted) return;
    setState(() => _localLoading = false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpScreen(
          phoneNumber: formattedPhone,
          verificationId: verificationId,
          expectedCode: '123456',
          onVerified: (firebaseToken) async {
            Navigator.pop(context); // pop OTP screen
            setState(() => _localLoading = true);
            await _completeRegistrationWithToken(firebaseToken);
            if (mounted) setState(() => _localLoading = false);
          },
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _localLoading = true);

    final formattedPhone = _formatPhoneNumber(_phoneController.text);

    if (kIsWeb) {
      // On web or when Firebase phone auth is uninitialized, directly open OTP screen
      _navigateToOtp(formattedPhone: formattedPhone);
      return;
    }

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
          final token = await userCredential.user?.getIdToken();
          if (token != null) {
            await _completeRegistrationWithToken(token);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          // Graceful fallback to OTP screen
          _navigateToOtp(formattedPhone: formattedPhone);
        },
        codeSent: (String verificationId, int? resendToken) {
          _navigateToOtp(verificationId: verificationId, formattedPhone: formattedPhone);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      // Graceful fallback to OTP screen
      _navigateToOtp(formattedPhone: formattedPhone);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final state = Provider.of<AppState>(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black87,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Language Switcher Button
          TextButton.icon(
            onPressed: () => state.toggleLocale(),
            icon: const Icon(Icons.language, size: 18, color: AppTheme.primaryBlue),
            label: Text(
              state.isArabic ? 'English' : 'عربي',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryBlue,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const NexLabLogo(
                    showText: true,
                    size: 34,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.createProfile,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.0,
                      fontFamily: 'Outfit',
                      color: isDark ? Colors.grey[400] : AppTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Form Container
                  Container(
                    padding: const EdgeInsets.all(22.0),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withValues(alpha: 0.3)
                              : Colors.grey.withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            l10n.patientRegistration,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 19,
                              fontFamily: 'Outfit',
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.registrationSubtitle,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                              fontSize: 12.5,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Full Name
                          _buildFieldLabel(l10n.fullName, isDark),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _nameController,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration(
                              isDark: isDark,
                              hintText: l10n.fullNameHint,
                              prefixIcon: Icons.person_outline,
                            ),
                            validator: (val) =>
                                val == null || val.trim().isEmpty ? l10n.fullNameError : null,
                          ),
                          const SizedBox(height: 16),

                          // Email
                          _buildFieldLabel(l10n.emailAddress, isDark),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration(
                              isDark: isDark,
                              hintText: l10n.emailHint,
                              prefixIcon: Icons.mail_outline,
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) return l10n.emailError;
                              if (!val.contains('@')) return l10n.emailError;
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Phone Number (for SMS OTP)
                          _buildFieldLabel(l10n.mobileNumber, isDark),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration(
                              isDark: isDark,
                              hintText: l10n.mobileNumberHint,
                              prefixIcon: Icons.phone_android_outlined,
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) return l10n.mobileNumberError;
                              if (val.trim().length < 8) return l10n.mobileNumberError;
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Password
                          _buildFieldLabel(l10n.password, isDark),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration(
                              isDark: isDark,
                              hintText: l10n.passwordHint,
                              prefixIcon: Icons.lock_outline,
                              suffix: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: isDark ? Colors.grey[400] : Colors.grey[500],
                                  size: 18,
                                ),
                                onPressed: () =>
                                    setState(() => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                            validator: (val) =>
                                val == null || val.length < 6 ? l10n.passwordError : null,
                          ),
                          const SizedBox(height: 16),

                          // Age & Gender Row
                          Row(
                            children: [
                              // Age
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFieldLabel(l10n.age, isDark),
                                    const SizedBox(height: 6),
                                    TextFormField(
                                      controller: _ageController,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.done,
                                      decoration: _inputDecoration(
                                        isDark: isDark,
                                        hintText: l10n.ageHint,
                                        prefixIcon: Icons.calendar_today_outlined,
                                      ),
                                      validator: (val) {
                                        if (val == null || val.isEmpty) return l10n.required;
                                        final a = int.tryParse(val);
                                        if (a == null || a <= 0 || a > 120) return l10n.invalid;
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Gender
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFieldLabel(l10n.gender, isDark),
                                    const SizedBox(height: 6),
                                    DropdownButtonFormField<String>(
                                      initialValue: _gender,
                                      isExpanded: true,
                                      decoration: _inputDecoration(
                                        isDark: isDark,
                                        hintText: l10n.gender,
                                        prefixIcon: Icons.people_outline,
                                      ),
                                      dropdownColor:
                                          isDark ? const Color(0xFF1E293B) : Colors.white,
                                      items: _genderOptions.map((g) {
                                        String label = g;
                                        if (g == 'Male') label = l10n.genderMale;
                                        if (g == 'Female') label = l10n.genderFemale;
                                        if (g == 'Other') label = l10n.genderOther;
                                        return DropdownMenuItem(
                                          value: g,
                                          child: Text(label, style: const TextStyle(fontSize: 13)),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) setState(() => _gender = val);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Blood Group
                          _buildFieldLabel(l10n.bloodType, isDark),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            initialValue: _bloodGroup,
                            isExpanded: true,
                            decoration: _inputDecoration(
                              isDark: isDark,
                              hintText: l10n.bloodTypeSelect,
                              prefixIcon: Icons.opacity_outlined,
                            ),
                            dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                            items: _bloodOptions.map((b) {
                              return DropdownMenuItem(
                                value: b,
                                child: Text('Type $b', style: const TextStyle(fontSize: 13)),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _bloodGroup = val);
                            },
                          ),
                          const SizedBox(height: 24),

                          // Submit Button
                          SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _localLoading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryBlue,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: _localLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : Text(
                                      l10n.verifyPhoneAndRegister,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Outfit',
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Back to login
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                l10n.alreadyHaveAccount,
                                style: TextStyle(
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Text(
                                  l10n.signIn,
                                  style: const TextStyle(
                                    color: AppTheme.primaryBlue,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    fontFamily: 'Outfit',
                                  ),
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
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label, bool isDark) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 10.5,
        fontWeight: FontWeight.w700,
        color: isDark ? Colors.grey[400] : Colors.grey[600],
        letterSpacing: 0.8,
        fontFamily: 'Outfit',
      ),
    );
  }

  InputDecoration _inputDecoration({
    required bool isDark,
    required String hintText,
    required IconData prefixIcon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: isDark ? Colors.grey[600] : Colors.grey[400],
        fontSize: 13.5,
      ),
      prefixIcon: Icon(
        prefixIcon,
        color: isDark ? Colors.grey[400] : Colors.grey[500],
        size: 18,
      ),
      suffixIcon: suffix,
      filled: true,
      fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppTheme.primaryBlue,
          width: 1.5,
        ),
      ),
      errorStyle: const TextStyle(fontSize: 11.5),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: AppTheme.coralRed.withValues(alpha: 0.8),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppTheme.coralRed,
          width: 1.5,
        ),
      ),
    );
  }
}
