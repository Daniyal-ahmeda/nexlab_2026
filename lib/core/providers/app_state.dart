import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../notifications/notification_config.dart';
import '../network/api_client.dart';
import '../../features/auth/domain/entities.dart';
import '../../features/booking/domain/entities.dart';
import '../../features/health/domain/entities.dart';
import '../../features/auth/domain/repositories.dart';
import '../../features/booking/domain/repositories.dart';
import '../../features/health/domain/repositories.dart';
import '../../features/auth/domain/usecases.dart';
import '../../features/booking/domain/usecases.dart';
import '../../features/health/domain/usecases.dart';

export '../../features/auth/domain/entities.dart';
export '../../features/booking/domain/entities.dart';
export '../../features/health/domain/entities.dart';

class AppState extends ChangeNotifier {
  final AuthRepository authRepository;
  final BookingRepository bookingRepository;
  final HealthRepository healthRepository;

  // Usecases
  late final LoginUseCase _loginUseCase;
  late final RegisterUseCase _registerUseCase;
  late final LogoutUseCase _logoutUseCase;
  late final GetCurrentUserUseCase _getCurrentUserUseCase;

  late final GetTestsUseCase _getTestsUseCase;
  late final GetLabsUseCase _getLabsUseCase;
  late final GetBookingsUseCase _getBookingsUseCase;
  late final CreateBookingUseCase _createBookingUseCase;
  late final CancelBookingUseCase _cancelBookingUseCase;

  late final GetResultsUseCase _getResultsUseCase;
  late final UploadPrescriptionUseCase _uploadPrescriptionUseCase;
  late final GetFamilyMembersUseCase _getFamilyMembersUseCase;
  late final AddFamilyMemberUseCase _addFamilyMemberUseCase;
  late final DeleteFamilyMemberUseCase _deleteFamilyMemberUseCase;
  late final GetPaymentMethodsUseCase _getPaymentMethodsUseCase;
  late final AddPaymentMethodUseCase _addPaymentMethodUseCase;
  late final SetPaymentMethodAsDefaultUseCase _setPaymentMethodAsDefaultUseCase;
  late final DeletePaymentMethodUseCase _deletePaymentMethodUseCase;

  // Core visual & localization state
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  Locale _locale = const Locale('ar');
  Locale get locale => _locale;
  bool get isArabic => _locale.languageCode == 'ar';

  void setLocale(Locale newLocale) {
    if (_locale == newLocale) return;
    _locale = newLocale;
    notifyListeners();
  }

  void toggleLocale() {
    _locale = _locale.languageCode == 'ar' ? const Locale('en') : const Locale('ar');
    notifyListeners();
  }

  // Loading & Error States
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Cached Domain Data
  List<DiagnosticTest> _allTests = [];
  List<DiagnosticTest> get allTests => _allTests;

  List<LabOption> _allLabs = [];
  List<LabOption> get allLabs => _allLabs;

  List<Booking> _bookings = [];
  List<Booking> get bookings => _bookings;

  List<TestResult> _results = [];
  List<TestResult> get results => _results;

  List<FamilyMember> _familyMembers = [];
  List<FamilyMember> get familyMembers => [
        if (_currentUser != null) _currentUser!.toFamilyMember(),
        ..._familyMembers
      ];

  List<PaymentMethod> _paymentMethods = [];
  List<PaymentMethod> get paymentMethods => _paymentMethods;

  List<DiagnosticTest> _favorites = [];
  List<DiagnosticTest> get favorites => _favorites;

  final List<String> _uploadedPrescriptions = [];
  List<String> get uploadedPrescriptions => _uploadedPrescriptions;

  // In-app notification banners (from FCM foreground messages)
  final List<Map<String, String>> _notifications = [];
  List<Map<String, String>> get notifications => List.unmodifiable(_notifications);
  int get unreadNotificationCount => _notifications.where((n) => n['read'] != 'true').length;

  ApiClient? _apiClient;

  // Authentication info
  User? _currentUser;
  User? get currentUser => _currentUser;

  FamilyMember get primaryUser => _currentUser != null
      ? _currentUser!.toFamilyMember()
      : const FamilyMember(
          id: 'f_self',
          name: 'Monder',
          relationship: 'Self',
          age: 34,
          gender: 'Male',
          bloodGroup: 'O+',
        );

  // Checkout workflow state variables
  DiagnosticTest? selectedTest;
  LabOption? selectedLab;
  DateTime? selectedDate;
  String? selectedTimeSlot;
  FamilyMember? selectedPatient;
  bool isHomeCollection = false;

  AppState({
    required this.authRepository,
    required this.bookingRepository,
    required this.healthRepository,
    ApiClient? apiClient,
  }) {
    _apiClient = apiClient;
    _loginUseCase = LoginUseCase(authRepository);
    _registerUseCase = RegisterUseCase(authRepository);
    _logoutUseCase = LogoutUseCase(authRepository);
    _getCurrentUserUseCase = GetCurrentUserUseCase(authRepository);

    _getTestsUseCase = GetTestsUseCase(bookingRepository);
    _getLabsUseCase = GetLabsUseCase(bookingRepository);
    _getBookingsUseCase = GetBookingsUseCase(bookingRepository);
    _createBookingUseCase = CreateBookingUseCase(bookingRepository);
    _cancelBookingUseCase = CancelBookingUseCase(bookingRepository);

    _getResultsUseCase = GetResultsUseCase(healthRepository);
    _uploadPrescriptionUseCase = UploadPrescriptionUseCase(healthRepository);
    _getFamilyMembersUseCase = GetFamilyMembersUseCase(healthRepository);
    _addFamilyMemberUseCase = AddFamilyMemberUseCase(healthRepository);
    _deleteFamilyMemberUseCase = DeleteFamilyMemberUseCase(healthRepository);
    _getPaymentMethodsUseCase = GetPaymentMethodsUseCase(healthRepository);
    _addPaymentMethodUseCase = AddPaymentMethodUseCase(healthRepository);
    _setPaymentMethodAsDefaultUseCase = SetPaymentMethodAsDefaultUseCase(healthRepository);
    _deletePaymentMethodUseCase = DeletePaymentMethodUseCase(healthRepository);

    // Initial data load
    loadInitialData();
  }

  /// Call this right after login/register to wire up FCM and register the device token.
  Future<void> initFcm(ApiClient apiClient) async {
    _apiClient = apiClient;
    try {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        final token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          await _registerDeviceToken(token);
        }
        FirebaseMessaging.instance.onTokenRefresh.listen(_registerDeviceToken);
      }

      // Foreground messages - show as local notification + add to in-app list + auto-refresh
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _addNotification(message);
        _showLocalNotification(message);
        refreshResults();
      });

      // User tapped a notification from background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _addNotification(message);
        // Refresh results so new one appears immediately
        refreshResults();
      });
    } catch (e) {
      debugPrint('FCM init error: $e');
    }
  }

  Future<void> _registerDeviceToken(String token) async {
    try {
      await _apiClient?.post('/device-token', body: {'fcm_token': token});
    } catch (e) {
      debugPrint('FCM token registration error: $e');
    }
  }

  void _addNotification(RemoteMessage message) {
    final notification = message.notification;
    _notifications.insert(0, {
      'title': notification?.title ?? 'NexLab',
      'body': notification?.body ?? '',
      'result_id': message.data['result_id'] ?? '',
      'time': DateTime.now().toIso8601String(),
      'read': 'false',
    });
    notifyListeners();
  }

  void markNotificationRead(int index) {
    if (index < _notifications.length) {
      _notifications[index] = Map.from(_notifications[index])..['read'] = 'true';
      notifyListeners();
    }
  }

  void markAllNotificationsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = Map.from(_notifications[i])..['read'] = 'true';
    }
    notifyListeners();
  }

  void _showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;
    localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          resultChannel.id,
          resultChannel.name,
          channelDescription: resultChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: message.data['result_id'],
    );
  }

  /// Pull fresh results from API ï¿½ useful after a push notification arrives.
  Future<void> refreshResults() async {
    try {
      _results = await _getResultsUseCase();
      notifyListeners();
    } catch (_) {}
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void _setError(String? msg) {
    _errorMessage = msg;
    notifyListeners();
  }

  Future<void> refreshAll() async {
    await loadInitialData();
  }

  Future<void> loadInitialData() async {
    _setLoading(true);
    _setError(null);

    try {
      _allTests = await _getTestsUseCase();
    } catch (e) {
      debugPrint('Error fetching tests: $e');
    }

    try {
      _allLabs = await _getLabsUseCase();
    } catch (e) {
      debugPrint('Error fetching labs: $e');
    }

    try {
      final user = await _getCurrentUserUseCase();
      if (user != null) {
        _currentUser = user;

        try {
          _bookings = await _getBookingsUseCase();
        } catch (e) {
          debugPrint('Error fetching bookings: $e');
        }

        try {
          _results = await _getResultsUseCase();
        } catch (e) {
          debugPrint('Error fetching results: $e');
        }

        try {
          _familyMembers = await _getFamilyMembersUseCase();
        } catch (e) {
          debugPrint('Error fetching family members: $e');
        }

        try {
          _paymentMethods = await _getPaymentMethodsUseCase();
        } catch (e) {
          debugPrint('Error fetching payment methods: $e');
        }
      }
    } catch (_) {
      // Session not active on fresh startup, user will log in
    }

    if (_allTests.isNotEmpty) {
      _favorites = [
        if (_allTests.length > 1) _allTests[1],
        if (_allTests.isNotEmpty) _allTests[0],
        if (_allTests.length > 7) _allTests[7],
      ];
    }

    _setLoading(false);
  }

  // Favorites Operations
  bool isFavorite(DiagnosticTest test) {
    return _favorites.any((t) => t.id == test.id);
  }

  void toggleFavorite(DiagnosticTest test) {
    if (isFavorite(test)) {
      _favorites.removeWhere((t) => t.id == test.id);
    } else {
      _favorites.add(test);
    }
    notifyListeners();
  }

  void removeFavorite(DiagnosticTest test) {
    _favorites.removeWhere((t) => t.id == test.id);
    notifyListeners();
  }

  // Family Operations
  Future<void> addFamilyMember(String name, String relationship, int age, String gender, String bloodGroup) async {
    _setLoading(true);
    _setError(null);
    try {
      final newMember = await _addFamilyMemberUseCase(
        name: name,
        relationship: relationship,
        age: age,
        gender: gender,
        bloodGroup: bloodGroup,
      );
      _familyMembers.add(newMember);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteFamilyMember(String id) async {
    _setLoading(true);
    _setError(null);
    try {
      await _deleteFamilyMemberUseCase(id);
      _familyMembers.removeWhere((m) => m.id == id);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Payment Operations
  Future<void> addPaymentMethod(String type, String number, String expiry, {required String firebaseToken}) async {
    _setLoading(true);
    _setError(null);
    try {
      final newMethod = await _addPaymentMethodUseCase(
        type: type,
        number: number,
        expiry: expiry,
        firebaseToken: firebaseToken,
      );
      _paymentMethods.add(newMethod);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> setPaymentMethodAsDefault(String id) async {
    _setLoading(true);
    _setError(null);
    try {
      await _setPaymentMethodAsDefaultUseCase(id);
      _paymentMethods = _paymentMethods.map((pm) {
        return PaymentMethod(
          id: pm.id,
          type: pm.type,
          number: pm.number,
          expiry: pm.expiry,
          isDefault: pm.id == id,
        );
      }).toList();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deletePaymentMethod(String id) async {
    _setLoading(true);
    _setError(null);
    try {
      await _deletePaymentMethodUseCase(id);
      _paymentMethods.removeWhere((pm) => pm.id == id);
      if (_paymentMethods.isNotEmpty && !_paymentMethods.any((pm) => pm.isDefault)) {
        await setPaymentMethodAsDefault(_paymentMethods[0].id);
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Prescription Upload Simulation
  Future<void> uploadPrescription(String path) async {
    _setLoading(true);
    _setError(null);
    try {
      await _uploadPrescriptionUseCase(path);
      _uploadedPrescriptions.add(path);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Booking Checkout Flow
  void startBooking(DiagnosticTest test) {
    selectedTest = test;
    selectedLab = null;
    selectedDate = null;
    selectedTimeSlot = null;
    selectedPatient = _currentUser?.toFamilyMember();
    isHomeCollection = false;
  }

  Future<Booking> confirmBooking() async {
    _setLoading(true);
    _setError(null);
    try {
      final bookingId = 'NXL${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
      final patientObj = selectedPatient ??
          (_currentUser != null
              ? _currentUser!.toFamilyMember()
              : const FamilyMember(
                  id: 'f_self',
                  name: 'izwa',
                  relationship: 'Self',
                  age: 28,
                  gender: 'Female',
                  bloodGroup: 'O+',
                ));

      final booking = Booking(
        id: bookingId,
        test: selectedTest!,
        lab: selectedLab!,
        date: selectedDate ?? DateTime.now(),
        timeSlot: selectedTimeSlot ?? '09:00 AM',
        patient: patientObj,
        isHomeCollection: isHomeCollection,
        status: BookingStatus.pending,
        paymentStatus: PaymentStatus.paid,
        totalAmount: selectedTest!.price,
      );

      final confirmed = await _createBookingUseCase(booking);
      _bookings.insert(0, confirmed);
      notifyListeners();
      return confirmed;
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> cancelBooking(String id) async {
    _setLoading(true);
    _setError(null);
    try {
      await _cancelBookingUseCase(id);
      _bookings = _bookings.map((b) {
        if (b.id == id) {
          return b.copyWith(status: BookingStatus.cancelled);
        }
        return b;
      }).toList();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Authentication Flow
  Future<void> login(String email, String password) async {
    _setLoading(true);
    _setError(null);
    try {
      _currentUser = await _loginUseCase(email, password);
      await loadInitialData();
      if (_apiClient != null) unawaited(initFcm(_apiClient!));
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String relationship,
    required int age,
    required String gender,
    required String bloodGroup,
    required String firebaseToken,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      _currentUser = await _registerUseCase(
        name: name,
        email: email,
        password: password,
        relationship: relationship,
        age: age,
        gender: gender,
        bloodGroup: bloodGroup,
        firebaseToken: firebaseToken,
      );
      await loadInitialData();
      if (_apiClient != null) unawaited(initFcm(_apiClient!));
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    _setError(null);
    try {
      await _logoutUseCase();
      _currentUser = null;
      _bookings.clear();
      _results.clear();
      _familyMembers.clear();
      _paymentMethods.clear();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
}


