import 'package:flutter/material.dart';
import '../models/models.dart';

class AppState extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // Pre-populated data lists
  final List<DiagnosticTest> allTests = [
    const DiagnosticTest(
      id: 't1',
      name: 'Lipid Profile',
      category: 'Blood',
      subtitle: 'Cholesterol, triglycerides, HDL, LDL analysis',
      description: 'This comprehensive panel provides detailed insights into your health status and helps detect potential issues early. The test is performed using advanced equipment and analyzed by certified professionals.',
      price: 65.0,
      sampleType: 'Blood',
      reportsInHours: 24,
      fastingRequired: true,
      isPopular: true,
      isPackage: false,
      icon: Icons.water_drop_outlined,
    ),
    const DiagnosticTest(
      id: 't2',
      name: 'Complete Blood Count (CBC)',
      category: 'Blood',
      subtitle: 'Comprehensive blood analysis including RBC, WBC, platelets',
      description: 'A complete blood count (CBC) is a blood test used to evaluate your overall health and detect a wide range of disorders, including anemia, infection and leukemia.',
      price: 45.0,
      sampleType: 'Blood',
      reportsInHours: 24,
      fastingRequired: false,
      isPopular: true,
      isPackage: false,
      icon: Icons.bloodtype_outlined,
    ),
    const DiagnosticTest(
      id: 't3',
      name: 'Thyroid Function Test (TFT)',
      category: 'Thyroid',
      subtitle: 'T3, T4, TSH levels measurement',
      description: 'Thyroid function tests are a series of blood tests used to measure how well your thyroid gland is working. Available tests include the T3, T4, and TSH.',
      price: 80.0,
      sampleType: 'Blood',
      reportsInHours: 48,
      fastingRequired: false,
      isPopular: true,
      isPackage: false,
      icon: Icons.psychology_outlined,
    ),
    const DiagnosticTest(
      id: 't4',
      name: 'Blood Sugar (Fasting)',
      category: 'Blood',
      subtitle: 'Fasting glucose level measurement',
      description: 'A fasting blood sugar test measures the amount of sugar (glucose) in your blood after you have not eaten for at least 8 hours.',
      price: 25.0,
      sampleType: 'Blood',
      reportsInHours: 24,
      fastingRequired: true,
      isPopular: true,
      isPackage: false,
      icon: Icons.opacity_outlined,
    ),
    const DiagnosticTest(
      id: 't5',
      name: 'Liver Function Test (LFT)',
      category: 'Blood',
      subtitle: 'Comprehensive liver enzyme analysis',
      description: 'Liver function tests help determine the health of your liver by measuring the levels of proteins, liver enzymes, and bilirubin in your blood.',
      price: 75.0,
      sampleType: 'Blood',
      reportsInHours: 24,
      fastingRequired: true,
      isPopular: false,
      isPackage: false,
      icon: Icons.health_and_safety_outlined,
    ),
    const DiagnosticTest(
      id: 't6',
      name: 'Kidney Function Test (KFT)',
      category: 'Blood',
      subtitle: 'Creatinine, BUN, uric acid analysis',
      description: 'Kidney function tests are simple blood and urine tests that can identify problems with your kidneys, which filter waste from your blood.',
      price: 70.0,
      sampleType: 'Blood',
      reportsInHours: 24,
      fastingRequired: false,
      isPopular: false,
      isPackage: false,
      icon: Icons.medical_services_outlined,
    ),
    const DiagnosticTest(
      id: 't7',
      name: 'Vitamin D Test',
      category: 'Energy',
      subtitle: 'Vitamin D (25-OH) level measurement',
      description: 'This test measures the level of vitamin D in your blood. Vitamin D is essential for healthy bones and teeth, and it helps keep your immune system functioning properly.',
      price: 90.0,
      sampleType: 'Blood',
      reportsInHours: 48,
      fastingRequired: false,
      isPopular: false,
      isPackage: false,
      icon: Icons.wb_sunny_outlined,
    ),
    const DiagnosticTest(
      id: 't8',
      name: 'Heart Health Package',
      category: 'Heart',
      subtitle: 'ECG, Lipid Profile, and cardiac markers',
      description: 'A comprehensive evaluation of cardiac risk factors. Includes electrocardiogram (ECG), lipid panel, and critical biomarkers to assess overall cardiovascular wellness.',
      price: 150.0,
      sampleType: 'Blood',
      reportsInHours: 24,
      fastingRequired: true,
      isPopular: true,
      isPackage: true,
      icon: Icons.favorite_border,
    ),
    const DiagnosticTest(
      id: 't9',
      name: 'Full Body Checkup',
      category: 'Heart',
      subtitle: 'Comprehensive health package with 85+ tests',
      description: 'Our most complete health package. Covers liver, kidney, thyroid, heart, blood sugar, lipid panel, hemogram, vitamins, and minerals. Highly recommended for annual wellness tracking.',
      price: 299.0,
      sampleType: 'Blood & Urine',
      reportsInHours: 24,
      fastingRequired: true,
      isPopular: true,
      isPackage: true,
      icon: Icons.assignment_outlined,
    ),
  ];

  final List<LabOption> allLabs = [
    const LabOption(
      id: 'l1',
      name: 'HealthFirst Diagnostics',
      rating: 4.8,
      reviewsCount: 285,
      address: '123 Medical Plaza, Downtown',
      hours: '7:00 AM - 9:00 PM',
      phone: '+1 (555) 123-4567',
      hasHomeCollection: true,
      price: 0,
    ),
    const LabOption(
      id: 'l2',
      name: 'CityLab Medical Center',
      rating: 4.6,
      reviewsCount: 254,
      address: '456 Health Avenue, Midtown',
      hours: '8:00 AM - 8:00 PM',
      phone: '+1 (555) 987-6543',
      hasHomeCollection: true,
      price: 0,
    ),
    const LabOption(
      id: 'l3',
      name: 'QuickTest Laboratory',
      rating: 4.5,
      reviewsCount: 184,
      address: '789 Diagnostics Blvd, Uptown',
      hours: '7:30 AM - 6:30 PM',
      phone: '+1 (555) 234-5678',
      hasHomeCollection: true,
      price: 0,
    ),
  ];

  // User details state
  final FamilyMember primaryUser = const FamilyMember(
    id: 'f_self',
    name: 'Monder',
    relationship: 'Self',
    age: 34,
    gender: 'Male',
    bloodGroup: 'O+',
  );

  List<FamilyMember> _familyMembers = [];
  List<FamilyMember> get familyMembers => [primaryUser, ..._familyMembers];

  List<PaymentMethod> _paymentMethods = [
    const PaymentMethod(id: 'pm1', type: 'Visa', number: '•••• 4242', expiry: '12/26', isDefault: true),
    const PaymentMethod(id: 'pm2', type: 'Mastercard', number: '•••• 8888', expiry: '12/26', isDefault: false),
    const PaymentMethod(id: 'pm3', type: 'UPI', number: 'monder@upi', expiry: '', isDefault: false),
  ];
  List<PaymentMethod> get paymentMethods => _paymentMethods;

  List<DiagnosticTest> _favorites = [];
  List<DiagnosticTest> get favorites => _favorites;

  List<Booking> _bookings = [];
  List<Booking> get bookings => _bookings;

  List<TestResult> _results = [];
  List<TestResult> get results => _results;

  List<String> _uploadedPrescriptions = [];
  List<String> get uploadedPrescriptions => _uploadedPrescriptions;

  // Checkout workflow state variables
  DiagnosticTest? selectedTest;
  LabOption? selectedLab;
  DateTime? selectedDate;
  String? selectedTimeSlot;
  FamilyMember? selectedPatient;
  bool isHomeCollection = false;

  AppState() {
    // Populate some default favorites matching the screens
    _favorites = [
      allTests.firstWhere((t) => t.id == 't2'), // CBC
      allTests.firstWhere((t) => t.id == 't1'), // Lipid Profile
      allTests.firstWhere((t) => t.id == 't8'), // Heart Health
    ];

    // Populate mock family members matching family member screens
    _familyMembers = [
      const FamilyMember(id: 'f1', name: 'Sarah Johnson', relationship: 'Spouse', age: 32, gender: 'Female', bloodGroup: 'A+'),
      const FamilyMember(id: 'f2', name: 'Michael Johnson', relationship: 'Son', age: 8, gender: 'Male', bloodGroup: 'A+'),
      const FamilyMember(id: 'f3', name: 'Emily Johnson', relationship: 'Daughter', age: 5, gender: 'Female', bloodGroup: 'A+'),
    ];

    // Populate default bookings (upcoming and completed)
    _bookings = [
      Booking(
        id: 'NXL40343641',
        test: allTests.firstWhere((t) => t.id == 't8'), // Heart Health
        lab: allLabs[0],
        date: DateTime.now().add(const Duration(days: 2)),
        timeSlot: '09:00 AM',
        patient: primaryUser,
        isHomeCollection: false,
        status: BookingStatus.pending,
        paymentStatus: PaymentStatus.paid,
        totalAmount: 150.0,
      ),
      Booking(
        id: 'NXL40343642',
        test: allTests.firstWhere((t) => t.id == 't4'), // Blood sugar fasting
        lab: allLabs[1],
        date: DateTime.now().add(const Duration(days: 4)),
        timeSlot: '10:30 AM',
        patient: _familyMembers[0], // Spouse
        isHomeCollection: true,
        status: BookingStatus.pending,
        paymentStatus: PaymentStatus.paid,
        totalAmount: 25.0,
      ),
      Booking(
        id: 'NXL40343630',
        test: allTests.firstWhere((t) => t.id == 't7'), // Vitamin D
        lab: allLabs[2],
        date: DateTime.now().subtract(const Duration(days: 10)),
        timeSlot: '11:00 AM',
        patient: primaryUser,
        isHomeCollection: false,
        status: BookingStatus.completed,
        paymentStatus: PaymentStatus.paid,
        totalAmount: 90.0,
      ),
      Booking(
        id: 'NXL40343629',
        test: allTests.firstWhere((t) => t.id == 't1'), // Lipid Profile
        lab: allLabs[0],
        date: DateTime.now().subtract(const Duration(days: 20)),
        timeSlot: '08:00 AM',
        patient: primaryUser,
        isHomeCollection: false,
        status: BookingStatus.completed,
        paymentStatus: PaymentStatus.paid,
        totalAmount: 65.0,
      ),
    ];

    // Populate mock completed test results
    _results = [
      TestResult(
        id: 'r1',
        test: allTests.firstWhere((t) => t.id == 't7'), // Vitamin D
        labName: 'QuickTest Laboratory',
        testDate: DateTime.now().subtract(const Duration(days: 10)),
        reportDate: DateTime.now().subtract(const Duration(days: 8)),
        status: 'Results Available',
        parameters: [
          const ResultParameter(name: 'Vitamin D, 25-Hydroxy', value: '24.5', unit: 'ng/mL', referenceRange: '30.0 - 100.0', status: 'Low'),
          const ResultParameter(name: 'Calcium', value: '9.4', unit: 'mg/dL', referenceRange: '8.5 - 10.2', status: 'Normal'),
        ],
      ),
      TestResult(
        id: 'r2',
        test: allTests.firstWhere((t) => t.id == 't1'), // Lipid Profile
        labName: 'HealthFirst Diagnostics',
        testDate: DateTime.now().subtract(const Duration(days: 20)),
        reportDate: DateTime.now().subtract(const Duration(days: 18)),
        status: 'Results Available',
        parameters: [
          const ResultParameter(name: 'Total Cholesterol', value: '210.0', unit: 'mg/dL', referenceRange: '< 200.0', status: 'High'),
          const ResultParameter(name: 'Triglycerides', value: '145.0', unit: 'mg/dL', referenceRange: '< 150.0', status: 'Normal'),
          const ResultParameter(name: 'HDL Cholesterol', value: '48.0', unit: 'mg/dL', referenceRange: '> 40.0', status: 'Normal'),
          const ResultParameter(name: 'LDL Cholesterol', value: '133.0', unit: 'mg/dL', referenceRange: '< 100.0', status: 'Borderline'),
        ],
      ),
    ];
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
  void addFamilyMember(String name, String relationship, int age, String gender, String bloodGroup) {
    final newMember = FamilyMember(
      id: 'f_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      relationship: relationship,
      age: age,
      gender: gender,
      bloodGroup: bloodGroup,
    );
    _familyMembers.add(newMember);
    notifyListeners();
  }

  void deleteFamilyMember(String id) {
    _familyMembers.removeWhere((m) => m.id == id);
    notifyListeners();
  }

  // Payment Operations
  void addPaymentMethod(String type, String number, String expiry) {
    final newMethod = PaymentMethod(
      id: 'pm_${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      number: number,
      expiry: expiry,
      isDefault: _paymentMethods.isEmpty,
    );
    _paymentMethods.add(newMethod);
    notifyListeners();
  }

  void setPaymentMethodAsDefault(String id) {
    _paymentMethods = _paymentMethods.map((pm) {
      return PaymentMethod(
        id: pm.id,
        type: pm.type,
        number: pm.number,
        expiry: pm.expiry,
        isDefault: pm.id == id,
      );
    }).toList();
    notifyListeners();
  }

  void deletePaymentMethod(String id) {
    _paymentMethods.removeWhere((pm) => pm.id == id);
    if (_paymentMethods.isNotEmpty && !_paymentMethods.any((pm) => pm.isDefault)) {
      setPaymentMethodAsDefault(_paymentMethods[0].id);
    }
    notifyListeners();
  }

  // Prescription Upload Simulation
  void uploadPrescription(String path) {
    _uploadedPrescriptions.add(path);
    notifyListeners();
  }

  // Booking Checkout flow helpers
  void startBooking(DiagnosticTest test) {
    selectedTest = test;
    selectedLab = null;
    selectedDate = null;
    selectedTimeSlot = null;
    selectedPatient = primaryUser;
    isHomeCollection = false;
  }

  Booking confirmBooking() {
    final bookingId = 'NXL${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    final newBooking = Booking(
      id: bookingId,
      test: selectedTest!,
      lab: selectedLab!,
      date: selectedDate ?? DateTime.now(),
      timeSlot: selectedTimeSlot ?? '09:00 AM',
      patient: selectedPatient ?? primaryUser,
      isHomeCollection: isHomeCollection,
      status: BookingStatus.pending,
      paymentStatus: PaymentStatus.paid,
      totalAmount: selectedTest!.price,
    );
    _bookings.insert(0, newBooking);
    notifyListeners();
    return newBooking;
  }

  void cancelBooking(String id) {
    _bookings = _bookings.map((b) {
      if (b.id == id) {
        return b.copyWith(status: BookingStatus.cancelled);
      }
      return b;
    }).toList();
    notifyListeners();
  }
}
