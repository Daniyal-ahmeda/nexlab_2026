import 'package:flutter/material.dart';
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

  // Core visual state
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

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
  }) {
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

  Future<void> loadInitialData() async {
    _setLoading(true);
    _setError(null);
    try {
      _currentUser = await _getCurrentUserUseCase();
      _allTests = await _getTestsUseCase();
      _allLabs = await _getLabsUseCase();
      _bookings = await _getBookingsUseCase();
      _results = await _getResultsUseCase();
      _familyMembers = await _getFamilyMembersUseCase();
      _paymentMethods = await _getPaymentMethodsUseCase();

      if (_allTests.isNotEmpty) {
        _favorites = [
          if (_allTests.length > 1) _allTests[1],
          if (_allTests.isNotEmpty) _allTests[0],
          if (_allTests.length > 7) _allTests[7],
        ];
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
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
  Future<void> addPaymentMethod(String type, String number, String expiry) async {
    _setLoading(true);
    _setError(null);
    try {
      final newMethod = await _addPaymentMethodUseCase(
        type: type,
        number: number,
        expiry: expiry,
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
      final booking = Booking(
        id: bookingId,
        test: selectedTest!,
        lab: selectedLab!,
        date: selectedDate ?? DateTime.now(),
        timeSlot: selectedTimeSlot ?? '09:00 AM',
        patient: selectedPatient ?? (_currentUser != null ? _currentUser!.toFamilyMember() : const FamilyMember(id: 'guest', name: 'Guest', relationship: 'Self', age: 30, gender: 'Male', bloodGroup: 'O+')),
        isHomeCollection: isHomeCollection,
        status: BookingStatus.pending,
        paymentStatus: PaymentStatus.paid,
        totalAmount: selectedTest!.price,
      );

      final confirmed = await _createBookingUseCase(booking);
      _bookings.insert(0, confirmed);
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
      );
      await loadInitialData();
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
