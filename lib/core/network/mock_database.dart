import 'package:flutter/material.dart';
import '../../features/auth/data/models.dart';
import '../../features/booking/data/models.dart';
import '../../features/health/data/models.dart';
import '../../features/booking/domain/entities.dart';

class MockDatabase {
  // Singleton instance
  static final MockDatabase instance = MockDatabase._internal();
  MockDatabase._internal() {
    _initDefaultData();
  }

  UserModel? currentUser;


  final List<DiagnosticTestModel> allTests = [
    const DiagnosticTestModel(
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
    const DiagnosticTestModel(
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
    const DiagnosticTestModel(
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
    const DiagnosticTestModel(
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
    const DiagnosticTestModel(
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
    const DiagnosticTestModel(
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
    const DiagnosticTestModel(
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
    const DiagnosticTestModel(
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
    const DiagnosticTestModel(
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

  final List<LabOptionModel> allLabs = [
    const LabOptionModel(
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
    const LabOptionModel(
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
    const LabOptionModel(
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

  final List<FamilyMemberModel> familyMembers = [
    const FamilyMemberModel(id: 'f1', name: 'Sarah Johnson', relationship: 'Spouse', age: 32, gender: 'Female', bloodGroup: 'A+'),
    const FamilyMemberModel(id: 'f2', name: 'Michael Johnson', relationship: 'Son', age: 8, gender: 'Male', bloodGroup: 'A+'),
    const FamilyMemberModel(id: 'f3', name: 'Emily Johnson', relationship: 'Daughter', age: 5, gender: 'Female', bloodGroup: 'A+'),
  ];

  final List<PaymentMethodModel> paymentMethods = [
    const PaymentMethodModel(id: 'pm1', type: 'Edfaaly', number: '0913456789', expiry: '', isDefault: true),
    const PaymentMethodModel(id: 'pm2', type: 'Mobi Cash', number: '0921234567', expiry: '', isDefault: false),
    const PaymentMethodModel(id: 'pm3', type: 'Tadawul', number: 'monder@tadawul', expiry: '', isDefault: false),
  ];

  final List<BookingModel> bookings = [];
  final List<TestResultModel> results = [];
  final List<String> uploadedPrescriptions = [];

  void _initDefaultData() {
    const defaultUser = UserModel(
      id: 'f_self',
      name: 'Monder',
      email: 'monder@nexlab.com',
      relationship: 'Self',
      age: 34,
      gender: 'Male',
      bloodGroup: 'O+',
    );

    bookings.addAll([
      BookingModel(
        id: 'NXL40343641',
        test: allTests.firstWhere((t) => t.id == 't8'),
        lab: allLabs[0],
        date: DateTime.now().add(const Duration(days: 2)),
        timeSlot: '09:00 AM',
        patient: defaultUser.toFamilyMember(),
        isHomeCollection: false,
        status: BookingStatus.pending,
        paymentStatus: PaymentStatus.paid,
        totalAmount: 150.0,
      ),
      BookingModel(
        id: 'NXL40343642',
        test: allTests.firstWhere((t) => t.id == 't4'),
        lab: allLabs[1],
        date: DateTime.now().add(const Duration(days: 4)),
        timeSlot: '10:30 AM',
        patient: familyMembers[0],
        isHomeCollection: true,
        status: BookingStatus.pending,
        paymentStatus: PaymentStatus.paid,
        totalAmount: 25.0,
      ),
      BookingModel(
        id: 'NXL40343630',
        test: allTests.firstWhere((t) => t.id == 't7'),
        lab: allLabs[2],
        date: DateTime.now().subtract(const Duration(days: 10)),
        timeSlot: '11:00 AM',
        patient: defaultUser.toFamilyMember(),
        isHomeCollection: false,
        status: BookingStatus.completed,
        paymentStatus: PaymentStatus.paid,
        totalAmount: 90.0,
      ),
      BookingModel(
        id: 'NXL40343629',
        test: allTests.firstWhere((t) => t.id == 't1'),
        lab: allLabs[0],
        date: DateTime.now().subtract(const Duration(days: 20)),
        timeSlot: '08:00 AM',
        patient: defaultUser.toFamilyMember(),
        isHomeCollection: false,
        status: BookingStatus.completed,
        paymentStatus: PaymentStatus.paid,
        totalAmount: 65.0,
      ),
    ]);

    results.addAll([
      TestResultModel(
        id: 'r1',
        test: allTests.firstWhere((t) => t.id == 't7'),
        labName: 'QuickTest Laboratory',
        testDate: DateTime.now().subtract(const Duration(days: 10)),
        reportDate: DateTime.now().subtract(const Duration(days: 8)),
        status: 'Results Available',
        parameters: const [
          ResultParameterModel(name: 'Vitamin D, 25-Hydroxy', value: '24.5', unit: 'ng/mL', referenceRange: '30.0 - 100.0', status: 'Low'),
          ResultParameterModel(name: 'Calcium', value: '9.4', unit: 'mg/dL', referenceRange: '8.5 - 10.2', status: 'Normal'),
        ],
      ),
      TestResultModel(
        id: 'r2',
        test: allTests.firstWhere((t) => t.id == 't1'),
        labName: 'HealthFirst Diagnostics',
        testDate: DateTime.now().subtract(const Duration(days: 20)),
        reportDate: DateTime.now().subtract(const Duration(days: 18)),
        status: 'Results Available',
        parameters: const [
          ResultParameterModel(name: 'Total Cholesterol', value: '210.0', unit: 'mg/dL', referenceRange: '< 200.0', status: 'High'),
          ResultParameterModel(name: 'Triglycerides', value: '145.0', unit: 'mg/dL', referenceRange: '< 150.0', status: 'Normal'),
          ResultParameterModel(name: 'HDL Cholesterol', value: '48.0', unit: 'mg/dL', referenceRange: '> 40.0', status: 'Normal'),
          ResultParameterModel(name: 'LDL Cholesterol', value: '133.0', unit: 'mg/dL', referenceRange: '< 100.0', status: 'Borderline'),
        ],
      ),
    ]);
  }
}
