import 'package:flutter/material.dart';
import '../domain/entities.dart';
import '../../health/data/models.dart';

double _parseDouble(dynamic val, [double defaultVal = 0.0]) {
  if (val == null) return defaultVal;
  if (val is num) return val.toDouble();
  return double.tryParse(val.toString()) ?? defaultVal;
}

int _parseInt(dynamic val, [int defaultVal = 0]) {
  if (val == null) return defaultVal;
  if (val is num) return val.toInt();
  return int.tryParse(val.toString()) ?? defaultVal;
}

bool _parseBool(dynamic val, [bool defaultVal = false]) {
  if (val == null) return defaultVal;
  if (val is bool) return val;
  if (val is num) return val != 0;
  final str = val.toString().trim().toLowerCase();
  if (str == 'true' || str == '1' || str == 'yes') return true;
  if (str == 'false' || str == '0' || str == 'no') return false;
  return defaultVal;
}

String _parseString(dynamic val, [String defaultVal = '']) {
  if (val == null) return defaultVal;
  return val.toString().trim();
}

class DiagnosticTestModel extends DiagnosticTest {
  const DiagnosticTestModel({
    required super.id,
    required super.name,
    required super.category,
    required super.subtitle,
    required super.description,
    required super.price,
    required super.sampleType,
    required super.reportsInHours,
    required super.fastingRequired,
    required super.isPopular,
    required super.isPackage,
    required super.icon,
  });

  factory DiagnosticTestModel.fromJson(Map<String, dynamic> json) {
    IconData defaultIcon = Icons.science_outlined;
    final rawName = _parseString(json['name'] ?? json['title'] ?? json['test_name']).toLowerCase();
    
    if (rawName.contains('lipid') || rawName.contains('cholesterol')) {
      defaultIcon = Icons.water_drop_outlined;
    } else if (rawName.contains('complete blood') || rawName.contains('cbc') || rawName.contains('blood')) {
      defaultIcon = Icons.bloodtype_outlined;
    } else if (rawName.contains('thyroid') || rawName.contains('tft') || rawName.contains('tsh')) {
      defaultIcon = Icons.psychology_outlined;
    } else if (rawName.contains('sugar') || rawName.contains('glucose') || rawName.contains('hba1c') || rawName.contains('diabetes')) {
      defaultIcon = Icons.opacity_outlined;
    } else if (rawName.contains('liver') || rawName.contains('alt') || rawName.contains('ast')) {
      defaultIcon = Icons.health_and_safety_outlined;
    } else if (rawName.contains('kidney') || rawName.contains('creatinine') || rawName.contains('urea')) {
      defaultIcon = Icons.medical_services_outlined;
    } else if (rawName.contains('vitamin') || rawName.contains('d3') || rawName.contains('b12')) {
      defaultIcon = Icons.wb_sunny_outlined;
    } else if (rawName.contains('heart') || rawName.contains('cardiac') || rawName.contains('troponin')) {
      defaultIcon = Icons.favorite_border;
    } else if (rawName.contains('full body') || rawName.contains('checkup') || rawName.contains('package')) {
      defaultIcon = Icons.assignment_outlined;
    }

    final testName = _parseString(json['name'] ?? json['title'] ?? json['test_name']);
    final category = _parseString(json['category'] ?? json['category_name'] ?? 'General', 'General');
    final subtitle = _parseString(json['subtitle'] ?? json['short_description'] ?? json['tagline'] ?? category);
    final description = _parseString(json['description'] ?? json['details'] ?? json['overview'] ?? '$testName Diagnostic Panel');
    final sampleType = _parseString(json['sample_type'] ?? json['sample'] ?? json['specimen'] ?? 'Blood', 'Blood');

    return DiagnosticTestModel(
      id: _parseString(json['id'] ?? json['test_id'], 't_${DateTime.now().millisecondsSinceEpoch}'),
      name: testName,
      category: category,
      subtitle: subtitle,
      description: description,
      price: _parseDouble(json['price'] ?? json['cost'] ?? json['fee']),
      sampleType: sampleType,
      reportsInHours: _parseInt(json['reports_in_hours'] ?? json['turnaround_hours'] ?? json['turnaround_time'] ?? json['hours'], 24),
      fastingRequired: _parseBool(json['fasting_required'] ?? json['is_fasting_required'] ?? json['fasting']),
      isPopular: _parseBool(json['is_popular'] ?? json['popular'] ?? json['featured']),
      isPackage: _parseBool(json['is_package'] ?? json['package'] ?? json['bundle']),
      icon: defaultIcon,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'subtitle': subtitle,
      'description': description,
      'price': price,
      'sample_type': sampleType,
      'reports_in_hours': reportsInHours,
      'fasting_required': fastingRequired,
      'is_popular': isPopular,
      'is_package': isPackage,
      'icon_code': icon.codePoint,
    };
  }
}

class LabOptionModel extends LabOption {
  const LabOptionModel({
    required super.id,
    required super.name,
    required super.rating,
    required super.reviewsCount,
    required super.address,
    required super.hours,
    required super.phone,
    required super.hasHomeCollection,
    required super.price,
  });

  factory LabOptionModel.fromJson(Map<String, dynamic> json) {
    return LabOptionModel(
      id: _parseString(json['id'] ?? json['lab_id'], 'l1'),
      name: _parseString(json['name'] ?? json['lab_name'], 'Tripoli Diagnostic Lab'),
      rating: _parseDouble(json['rating'], 4.9),
      reviewsCount: _parseInt(json['reviews_count'] ?? json['reviews'], 120),
      address: _parseString(json['address'] ?? json['location'], 'Tripoli, Libya'),
      hours: _parseString(json['hours'] ?? json['working_hours'], '08:00 AM - 08:00 PM'),
      phone: _parseString(json['phone'] ?? json['mobile'], '+218 91 000 0000'),
      hasHomeCollection: _parseBool(json['has_home_collection'] ?? json['home_visit'], true),
      price: _parseDouble(json['price'] ?? json['home_charge'], 0.0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rating': rating,
      'reviews_count': reviewsCount,
      'address': address,
      'hours': hours,
      'phone': phone,
      'has_home_collection': hasHomeCollection,
      'price': price,
    };
  }
}

class BookingModel extends Booking {
  const BookingModel({
    required super.id,
    required super.test,
    required super.lab,
    required super.date,
    required super.timeSlot,
    required super.patient,
    required super.isHomeCollection,
    required super.status,
    required super.paymentStatus,
    required super.totalAmount,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final statusStr = _parseString(json['status']).toLowerCase();
    BookingStatus statusVal = BookingStatus.pending;
    if (statusStr == 'completed') statusVal = BookingStatus.completed;
    if (statusStr == 'cancelled') statusVal = BookingStatus.cancelled;

    final payStr = _parseString(json['payment_status']).toLowerCase();
    PaymentStatus payVal = PaymentStatus.unpaid;
    if (payStr == 'paid') payVal = PaymentStatus.paid;

    DiagnosticTestModel testObj;
    if (json.containsKey('test') && json['test'] is Map<String, dynamic>) {
      testObj = DiagnosticTestModel.fromJson(json['test'] as Map<String, dynamic>);
    } else {
      final testId = _parseString(json['diagnostic_test_id'] ?? json['test_id'], 't1');
      testObj = DiagnosticTestModel(
        id: testId,
        name: _parseString(json['test_name'], 'Diagnostic Test'),
        category: 'General',
        subtitle: 'Lab Test',
        description: 'Comprehensive Diagnostic Panel',
        price: _parseDouble(json['total_amount'] ?? json['price'], 140.0),
        sampleType: 'Blood',
        reportsInHours: 24,
        fastingRequired: false,
        isPopular: true,
        isPackage: false,
        icon: Icons.science_outlined,
      );
    }

    LabOptionModel labObj;
    if (json.containsKey('lab') && json['lab'] is Map<String, dynamic>) {
      labObj = LabOptionModel.fromJson(json['lab'] as Map<String, dynamic>);
    } else {
      final labId = _parseString(json['partner_lab_id'] ?? json['lab_id'], 'l1');
      labObj = LabOptionModel(
        id: labId,
        name: _parseString(json['lab_name'], 'Tripoli Central Diagnostic Lab'),
        rating: 4.9,
        reviewsCount: 312,
        address: 'Tripoli, Libya',
        hours: '07:00 AM - 08:00 PM',
        phone: '+218 91 000 0000',
        hasHomeCollection: true,
        price: 0.0,
      );
    }

    FamilyMemberModel patientObj;
    if (json.containsKey('patient') && json['patient'] is Map<String, dynamic>) {
      patientObj = FamilyMemberModel.fromJson(json['patient'] as Map<String, dynamic>);
    } else {
      patientObj = FamilyMemberModel(
        id: _parseString(json['patient_id'], 'f_self'),
        name: _parseString(json['patient_name'], 'Patient'),
        relationship: 'Self',
        age: _parseInt(json['patient_age'], 25),
        gender: _parseString(json['patient_gender'], 'Male'),
        bloodGroup: _parseString(json['patient_blood_group'], 'O+'),
      );
    }

    DateTime parsedDate;
    try {
      parsedDate = json['date'] != null ? DateTime.parse(json['date'].toString()) : DateTime.now();
    } catch (_) {
      parsedDate = DateTime.now();
    }

    return BookingModel(
      id: _parseString(json['id'], 'NXL${DateTime.now().millisecondsSinceEpoch}'),
      test: testObj,
      lab: labObj,
      date: parsedDate,
      timeSlot: _parseString(json['time_slot'], '09:00 AM'),
      patient: patientObj,
      isHomeCollection: _parseBool(json['is_home_collection'] ?? json['home_visit']),
      status: statusVal,
      paymentStatus: payVal,
      totalAmount: _parseDouble(json['total_amount'] ?? json['price']),
    );
  }

  Map<String, dynamic> toJson() {
    String statusStr = 'pending';
    if (status == BookingStatus.completed) statusStr = 'completed';
    if (status == BookingStatus.cancelled) statusStr = 'cancelled';

    String payStr = 'unpaid';
    if (paymentStatus == PaymentStatus.paid) payStr = 'paid';

    return {
      'id': id,
      'diagnostic_test_id': test.id.toString(),
      'partner_lab_id': lab.id.toString(),
      'patient_name': patient.name.isNotEmpty ? patient.name : 'Patient',
      'test_id': test.id.toString(),
      'lab_id': lab.id.toString(),
      'date': date.toIso8601String().substring(0, 10),
      'time_slot': timeSlot,
      'patient_id': patient.id,
      'is_home_collection': isHomeCollection,
      'status': statusStr,
      'payment_status': payStr,
      'total_amount': totalAmount,
      'test': {
        'id': test.id,
        'name': test.name,
        'category': test.category,
        'subtitle': test.subtitle,
        'description': test.description,
        'price': test.price,
        'sample_type': test.sampleType,
        'reports_in_hours': test.reportsInHours,
        'fasting_required': test.fastingRequired,
        'is_popular': test.isPopular,
        'is_package': test.isPackage,
      },
      'lab': {
        'id': lab.id,
        'name': lab.name,
        'rating': lab.rating,
        'reviews_count': lab.reviewsCount,
        'address': lab.address,
        'hours': lab.hours,
        'phone': lab.phone,
        'has_home_collection': lab.hasHomeCollection,
        'price': lab.price,
      },
      'patient': {
        'id': patient.id,
        'name': patient.name,
        'relationship': patient.relationship,
        'age': patient.age,
        'gender': patient.gender,
        'blood_group': patient.bloodGroup,
      },
    };
  }
}
