import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  bool get isArabic => locale.languageCode == 'ar';

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // General & Branding
      'appName': 'NexLab',
      'appSubtitle': 'Next-Gen Diagnostic Portal',
      'createProfile': 'Create Medical Profile',
      'patientRegistration': 'New Patient Registration',
      'registrationSubtitle': 'Enter your details for diagnostic records & reports.',
      'save': 'Save',
      'cancel': 'Cancel',
      'done': 'Done',
      'back': 'Back',
      'continueText': 'Continue',
      'loading': 'Loading...',
      'error': 'Error',
      'required': 'Required',
      'invalid': 'Invalid',

      // Auth & Registration
      'fullName': 'FULL NAME',
      'fullNameHint': 'e.g. Mahmoud El-Sayed',
      'fullNameError': 'Please enter your name',
      'emailAddress': 'EMAIL ADDRESS',
      'emailHint': 'name@example.com',
      'emailError': 'Please enter a valid email',
      'mobileNumber': 'MOBILE NUMBER (FOR SMS OTP)',
      'mobileNumberHint': '091-XXXXXXX or 092-XXXXXXX',
      'mobileNumberError': 'Please enter a valid mobile number',
      'password': 'PASSWORD',
      'passwordHint': 'Min 6 characters',
      'passwordError': 'Password must be at least 6 characters',
      'age': 'AGE',
      'ageHint': 'Years',
      'gender': 'GENDER',
      'genderMale': 'Male',
      'genderFemale': 'Female',
      'genderOther': 'Other',
      'bloodType': 'BLOOD TYPE',
      'bloodTypeSelect': 'Select Blood Type',
      'verifyPhoneAndRegister': 'Verify Phone & Register',
      'alreadyHaveAccount': 'Already have an account? ',
      'dontHaveAccount': "Don't have an account? ",
      'signIn': 'Sign In',
      'signUp': 'Sign Up',
      'welcomeBack': 'Welcome Back',
      'loginSubtitle': 'Access your medical tests & reports securely',
      'signOut': 'Sign Out',

      // OTP Verification
      'verifyYourPhone': 'Verify Your Phone',
      'otpSubtitle': 'Enter the 6-digit code sent to your phone number.',
      'otpPaymentSubtitle': 'Enter the 6-digit verification code to link your Libyan payment gateway.',
      'verifyAndContinue': 'Verify & Continue',
      'resendCode': 'Resend Code',
      'resendIn': 'Resend in',
      'seconds': 's',
      'codeIncorrect': 'Incorrect code. Please check and try again.',
      'enterFullOtp': 'Please enter the full 6-digit code',
      'demoOtpNotice': 'Demo / Offline Code: ',

      // Navigation
      'navHome': 'Home',
      'navTests': 'Tests',
      'navBookings': 'Bookings',
      'navResults': 'Results',
      'navProfile': 'Profile',

      // Payment Methods
      'libyanPaymentGateways': 'Libyan Payment Gateways',
      'paymentsProcessedInLyd': 'All payments processed in LYD',
      'securityTip': 'Direct integration with Libyan local payment services (Edfaaly, Sadad, Mobi Cash, Local Cards). Settled instantly in LYD.',
      'yourPaymentMethods': 'YOUR PAYMENT METHODS',
      'addNewGateway': 'Add New Libyan Payment Gateway',
      'supportedNetworks': 'SUPPORTED LIBYAN NETWORKS',
      'defaultBadge': 'DEFAULT',
      'setAsPrimary': 'Set as Primary Payment Method',
      'addPaymentTitle': 'Add Libyan Payment Method',
      'paymentNetwork': 'Payment Network',
      'accountOrPhone': 'Mobile / Account Number (e.g. 091-XXXXXXX)',
      'expiryOptional': 'Expiry (MM/YY, optional)',
      'verifySmsAndAdd': 'Verify via SMS & Add Method',
      'edfaaly': 'Edfaaly',
      'mobiCash': 'Mobi Cash',
      'sadad': 'Sadad',
      'tadawul': 'Tadawul',
      'sahel': 'Sahel',
      'moamalat': 'Moamalat',
      'tyssir': 'Tyssir',
      'cash': 'Cash on Visit',

      // Settings
      'settingsTitle': 'Settings & Security',
      'language': 'Language / اللغة',
      'arabic': 'العربية (Arabic)',
      'english': 'English (الإنجليزية)',
      'notificationsSection': 'NOTIFICATIONS & ALERTS',
      'pushNotifications': 'Push Notifications',
      'pushSubtitle': 'Alerts for sample updates & report ready',
      'emailNotifications': 'Email Notifications',
      'emailSubtitle': 'Official PDF report copies sent to email',
      'smsNotifications': 'SMS Appointment Reminders',
      'smsSubtitle': 'Text updates for home technician arrival',
      'appearanceSection': 'APPEARANCE & THEME',
      'darkMode': 'Dark Mode',
      'storageSection': 'STORAGE & CACHE',
      'clearCache': 'Clear Report Cache',
      'cacheFreed': 'Temporary medical report cache cleared.',
      'accountSection': 'ACCOUNT',

      // Health & Booking
      'myAccount': 'My Account',
      'manageProfileSubtitle': 'Manage profile, family members & preferences',
      'familyMembers': 'Family Members',
      'myBookings': 'My Bookings',
      'testResults': 'Test Results',
      'uploadPrescription': 'Upload Prescription',
      'selectLab': 'Select Lab',
      'selectDateTime': 'Select Date & Time',
      'bookingConfirmation': 'Booking Confirmation',
      'homeCollection': 'Home Collection',
      'labVisit': 'Lab Visit',
      'totalAmount': 'Total Amount',
      'confirmBooking': 'Confirm Booking',
      'statusPending': 'Pending',
      'statusConfirmed': 'Confirmed',
      'statusCompleted': 'Completed',
      'statusCancelled': 'Cancelled',
    },
    'ar': {
      // General & Branding
      'appName': 'نكست لاب',
      'appSubtitle': 'بوابة الفحوصات والتحاليل الطبية الذكية',
      'createProfile': 'إنشاء الملف الطبي',
      'patientRegistration': 'تسجيل مريض جديد',
      'registrationSubtitle': 'أدخل بياناتك للسجلات والتقارير المخبرية والطبية.',
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'done': 'تم',
      'back': 'رجوع',
      'continueText': 'متابعة',
      'loading': 'جاري التحميل...',
      'error': 'خطأ',
      'required': 'مطلوب',
      'invalid': 'غير صالح',

      // Auth & Registration
      'fullName': 'الاسم بالكامل',
      'fullNameHint': 'مثال: محمود السيد',
      'fullNameError': 'يرجى إدخال الاسم',
      'emailAddress': 'البريد الإلكتروني',
      'emailHint': 'name@example.com',
      'emailError': 'يرجى إدخال بريد إلكتروني صالح',
      'mobileNumber': 'رقم الهاتف المحمول (لتأكيد الرسالة القصيرة)',
      'mobileNumberHint': '091-XXXXXXX أو 092-XXXXXXX',
      'mobileNumberError': 'يرجى إدخال رقم هاتف محمول صالح',
      'password': 'كلمة المرور',
      'passwordHint': '6 أحرف على الأقل',
      'passwordError': 'يجب أن لا تقل كلمة المرور عن 6 أحرف',
      'age': 'العمر',
      'ageHint': 'بالسنوات',
      'gender': 'الجنس',
      'genderMale': 'ذكر',
      'genderFemale': 'أنثى',
      'genderOther': 'غير ذلك',
      'bloodType': 'فصيلة الدم',
      'bloodTypeSelect': 'اختر فصيلة الدم',
      'verifyPhoneAndRegister': 'تأكيد الهاتف وإنشاء الحساب',
      'alreadyHaveAccount': 'لديك حساب بالفعل؟ ',
      'dontHaveAccount': 'ليس لديك حساب؟ ',
      'signIn': 'تسجيل الدخول',
      'signUp': 'إنشاء حساب',
      'welcomeBack': 'مرحباً بك مجدداً',
      'loginSubtitle': 'سجل دخولك لمتابعة تحاليلك وتقاريرك الطبية بأمان',
      'signOut': 'تسجيل الخروج',

      // OTP Verification
      'verifyYourPhone': 'تأكيد رقم هاتفك',
      'otpSubtitle': 'أدخل رمز التحقق المكون من 6 أرقام المرسل إلى هاتفك.',
      'otpPaymentSubtitle': 'أدخل رمز التحقق المكون من 6 أرقام لتأكيد ربط وسيلة الدفع الليبية.',
      'verifyAndContinue': 'تأكيد الرمز والمتابعة',
      'resendCode': 'إعادة إرسال الرمز',
      'resendIn': 'إعادة الإرسال خلال',
      'seconds': 'ثانية',
      'codeIncorrect': 'الرمز غير صحيح. يرجى التحقق وإعادة المحاولة.',
      'enterFullOtp': 'يرجى إدخال رمز التحقق المكون من 6 أرقام بالكامل',
      'demoOtpNotice': 'رمز التحقق التجريبي: ',

      // Navigation
      'navHome': 'الرئيسية',
      'navTests': 'التحاليل',
      'navBookings': 'حجوزاتي',
      'navResults': 'النتائج',
      'navProfile': 'حسابي',

      // Payment Methods
      'libyanPaymentGateways': 'بوابات الدفع الليبية',
      'paymentsProcessedInLyd': 'جميع المدفوعات تُعالج بالدينار الليبي (د.ل)',
      'securityTip': 'تكامل مباشر مع خدمات الدفع الإلكتروني الليبية (إدفع لي، سداد، مو كاش، البطاقات المصرفية المحلية). تسوية فورية بالدينار الليبي.',
      'yourPaymentMethods': 'وسائل الدفع المسجلة',
      'addNewGateway': 'إضافة وسيلة دفع ليبية جديدة',
      'supportedNetworks': 'الشبكات والخدمات الليبية المدعومة',
      'defaultBadge': 'افتراضي',
      'setAsPrimary': 'تعيين كوسيلة دفع رئيسية',
      'addPaymentTitle': 'إضافة وسيلة دفع ليبية',
      'paymentNetwork': 'شبكة / وسيلة الدفع',
      'accountOrPhone': 'رقم الهاتف أو الحساب (مثال: 091-XXXXXXX)',
      'expiryOptional': 'تاريخ الصلاحية (اختياري للشهر/السنة)',
      'verifySmsAndAdd': 'تأكيد برمز الرسالة وإضافة الوسيلة',
      'edfaaly': 'إدفع لي',
      'mobiCash': 'موبي كاش',
      'sadad': 'سداد',
      'tadawul': 'تداول',
      'sahel': 'تداول - سهل',
      'moamalat': 'معاملات',
      'tyssir': 'تيسير',
      'cash': 'نقداً عند الزيارة',

      // Settings
      'settingsTitle': 'الإعدادات والأمان',
      'language': 'اللغة / Language',
      'arabic': 'العربية (Arabic)',
      'english': 'English (الإنجليزية)',
      'notificationsSection': 'الإشعارات والتنبيهات',
      'pushNotifications': 'الإشعارات المباشرة',
      'pushSubtitle': 'تنبيهات فورية لجهوزية العينات والتقارير الطبية',
      'emailNotifications': 'إشعارات البريد الإلكتروني',
      'emailSubtitle': 'إرسال نسخ تقارير PDF الرسمية إلى بريدك',
      'smsNotifications': 'تذكيرات الرسائل القصيرة (SMS)',
      'smsSubtitle': 'تحديثات وصول الفني عند السحب المنزلي',
      'appearanceSection': 'المظهر والسمات',
      'darkMode': 'الوضع الليلي (الداكن)',
      'storageSection': 'التخزين والذاكرة',
      'clearCache': 'مسح ذاكرة التخزين المؤقت للتقارير',
      'cacheFreed': 'تم تفريغ ذاكرة التخزين المؤقت للتقارير بنجاح.',
      'accountSection': 'إدارة الحساب',

      // Health & Booking
      'myAccount': 'حسابي',
      'manageProfileSubtitle': 'إدارة الملف الشخصي، أفراد العائلة، والخيارات',
      'familyMembers': 'أفراد العائلة',
      'myBookings': 'حجوزاتي',
      'testResults': 'نتائج التحاليل',
      'uploadPrescription': 'رفع الروشتة الطبية',
      'selectLab': 'اختيار المختبر',
      'selectDateTime': 'اختيار الموعد والتوقيت',
      'bookingConfirmation': 'تأكيد الحجز',
      'homeCollection': 'سحب عينة منزلي',
      'labVisit': 'زيارة للمختبر',
      'totalAmount': 'المبلغ الإجمالي',
      'confirmBooking': 'تأكيد الحجز والدفع',
      'statusPending': 'قيد الانتظار',
      'statusConfirmed': 'مؤكد',
      'statusCompleted': 'مكتمل',
      'statusCancelled': 'ملغي',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }

  // Quick Getters
  String get appName => translate('appName');
  String get appSubtitle => translate('appSubtitle');
  String get createProfile => translate('createProfile');
  String get patientRegistration => translate('patientRegistration');
  String get registrationSubtitle => translate('registrationSubtitle');
  String get save => translate('save');
  String get cancel => translate('cancel');
  String get done => translate('done');
  String get back => translate('back');
  String get continueText => translate('continueText');
  String get loading => translate('loading');
  String get error => translate('error');
  String get required => translate('required');
  String get invalid => translate('invalid');

  String get fullName => translate('fullName');
  String get fullNameHint => translate('fullNameHint');
  String get fullNameError => translate('fullNameError');
  String get emailAddress => translate('emailAddress');
  String get emailHint => translate('emailHint');
  String get emailError => translate('emailError');
  String get mobileNumber => translate('mobileNumber');
  String get mobileNumberHint => translate('mobileNumberHint');
  String get mobileNumberError => translate('mobileNumberError');
  String get password => translate('password');
  String get passwordHint => translate('passwordHint');
  String get passwordError => translate('passwordError');
  String get age => translate('age');
  String get ageHint => translate('ageHint');
  String get gender => translate('gender');
  String get genderMale => translate('genderMale');
  String get genderFemale => translate('genderFemale');
  String get genderOther => translate('genderOther');
  String get bloodType => translate('bloodType');
  String get bloodTypeSelect => translate('bloodTypeSelect');
  String get verifyPhoneAndRegister => translate('verifyPhoneAndRegister');
  String get alreadyHaveAccount => translate('alreadyHaveAccount');
  String get dontHaveAccount => translate('dontHaveAccount');
  String get signIn => translate('signIn');
  String get signUp => translate('signUp');
  String get welcomeBack => translate('welcomeBack');
  String get loginSubtitle => translate('loginSubtitle');
  String get signOut => translate('signOut');

  String get verifyYourPhone => translate('verifyYourPhone');
  String get otpSubtitle => translate('otpSubtitle');
  String get otpPaymentSubtitle => translate('otpPaymentSubtitle');
  String get verifyAndContinue => translate('verifyAndContinue');
  String get resendCode => translate('resendCode');
  String get resendIn => translate('resendIn');
  String get seconds => translate('seconds');
  String get codeIncorrect => translate('codeIncorrect');
  String get enterFullOtp => translate('enterFullOtp');
  String get demoOtpNotice => translate('demoOtpNotice');

  String get navHome => translate('navHome');
  String get navTests => translate('navTests');
  String get navBookings => translate('navBookings');
  String get navResults => translate('navResults');
  String get navProfile => translate('navProfile');

  String get libyanPaymentGateways => translate('libyanPaymentGateways');
  String get paymentsProcessedInLyd => translate('paymentsProcessedInLyd');
  String get securityTip => translate('securityTip');
  String get yourPaymentMethods => translate('yourPaymentMethods');
  String get addNewGateway => translate('addNewGateway');
  String get supportedNetworks => translate('supportedNetworks');
  String get defaultBadge => translate('defaultBadge');
  String get setAsPrimary => translate('setAsPrimary');
  String get addPaymentTitle => translate('addPaymentTitle');
  String get paymentNetwork => translate('paymentNetwork');
  String get accountOrPhone => translate('accountOrPhone');
  String get expiryOptional => translate('expiryOptional');
  String get verifySmsAndAdd => translate('verifySmsAndAdd');
  String get edfaaly => translate('edfaaly');
  String get mobiCash => translate('mobiCash');
  String get sadad => translate('sadad');
  String get tadawul => translate('tadawul');
  String get sahel => translate('sahel');
  String get moamalat => translate('moamalat');
  String get tyssir => translate('tyssir');
  String get cash => translate('cash');

  String get settingsTitle => translate('settingsTitle');
  String get language => translate('language');
  String get arabic => translate('arabic');
  String get english => translate('english');
  String get notificationsSection => translate('notificationsSection');
  String get pushNotifications => translate('pushNotifications');
  String get pushSubtitle => translate('pushSubtitle');
  String get emailNotifications => translate('emailNotifications');
  String get emailSubtitle => translate('emailSubtitle');
  String get smsNotifications => translate('smsNotifications');
  String get smsSubtitle => translate('smsSubtitle');
  String get appearanceSection => translate('appearanceSection');
  String get darkMode => translate('darkMode');
  String get storageSection => translate('storageSection');
  String get clearCache => translate('clearCache');
  String get cacheFreed => translate('cacheFreed');
  String get accountSection => translate('accountSection');

  String get myAccount => translate('myAccount');
  String get manageProfileSubtitle => translate('manageProfileSubtitle');
  String get familyMembers => translate('familyMembers');
  String get myBookings => translate('myBookings');
  String get testResults => translate('testResults');
  String get uploadPrescription => translate('uploadPrescription');
  String get selectLab => translate('selectLab');
  String get selectDateTime => translate('selectDateTime');
  String get bookingConfirmation => translate('bookingConfirmation');
  String get homeCollection => translate('homeCollection');
  String get labVisit => translate('labVisit');
  String get totalAmount => translate('totalAmount');
  String get confirmBooking => translate('confirmBooking');
  String get statusPending => translate('statusPending');
  String get statusConfirmed => translate('statusConfirmed');
  String get statusCompleted => translate('statusCompleted');
  String get statusCancelled => translate('statusCancelled');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
