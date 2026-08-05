import 'package:flutter/material.dart';
import '../domain/entities.dart';
import '../../health/data/models.dart';

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
    final name = json['name']?.toString().toLowerCase() ?? '';
    
    if (name.contains('lipid')) {
      defaultIcon = Icons.water_drop_outlined;
    } else if (name.contains('complete blood') || name.contains('cbc')) {
      defaultIcon = Icons.bloodtype_outlined;
    } else if (name.contains('thyroid') || name.contains('tft')) {
      defaultIcon = Icons.psychology_outlined;
    } else if (name.contains('sugar') || name.contains('glucose')) {
      defaultIcon = Icons.opacity_outlined;
    } else if (name.contains('liver')) {
      defaultIcon = Icons.health_and_safety_outlined;
    } else if (name.contains('kidney')) {
      defaultIcon = Icons.medical_services_outlined;
    } else if (name.contains('vitamin')) {
      defaultIcon = Icons.wb_sunny_outlined;
    } else if (name.contains('heart')) {
      defaultIcon = Icons.favorite_border;
    } else if (name.contains('full body') || name.contains('checkup')) {
      defaultIcon = Icons.assignment_outlined;
    }

    return DiagnosticTestModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      subtitle: json['subtitle'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      sampleType: json['sample_type'] ?? 'Blood',
      reportsInHours: json['reports_in_hours'] as int? ?? 24,
      fastingRequired: json['fasting_required'] as bool? ?? false,
      isPopular: json['is_popular'] as bool? ?? false,
      isPackage: json['is_package'] as bool? ?? false,
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
      id: json['id'].toString(),
      name: json['name'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: json['reviews_count'] as int? ?? 0,
      address: json['address'] ?? '',
      hours: json['hours'] ?? '',
      phone: json['phone'] ?? '',
      hasHomeCollection: json['has_home_collection'] as bool? ?? false,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
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
    BookingStatus statusVal = BookingStatus.pending;
    if (json['status'] == 'completed') statusVal = BookingStatus.completed;
    if (json['status'] == 'cancelled') statusVal = BookingStatus.cancelled;

    PaymentStatus payVal = PaymentStatus.unpaid;
    if (json['payment_status'] == 'paid') payVal = PaymentStatus.paid;

    return BookingModel(
      id: json['id'].toString(),
      test: DiagnosticTestModel.fromJson(json['test']),
      lab: LabOptionModel.fromJson(json['lab']),
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      timeSlot: json['time_slot'] ?? '',
      patient: FamilyMemberModel.fromJson(json['patient']),
      isHomeCollection: json['is_home_collection'] as bool? ?? false,
      status: statusVal,
      paymentStatus: payVal,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
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
      'test_id': test.id,
      'lab_id': lab.id,
      'date': date.toIso8601String().substring(0, 10),
      'time_slot': timeSlot,
      'patient_id': patient.id,
      'is_home_collection': isHomeCollection,
      'status': statusStr,
      'payment_status': payStr,
      'total_amount': totalAmount,
      'test': (test as DiagnosticTestModel).toJson(),
      'lab': (lab as LabOptionModel).toJson(),
      'patient': (patient as FamilyMemberModel).toJson(),
    };
  }
}
