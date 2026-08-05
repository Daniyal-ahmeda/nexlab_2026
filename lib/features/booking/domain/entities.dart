import 'package:flutter/material.dart';
import '../../health/domain/entities.dart';

class DiagnosticTest {
  final String id;
  final String name;
  final String category;
  final String subtitle;
  final String description;
  final double price;
  final String sampleType;
  final int reportsInHours;
  final bool fastingRequired;
  final bool isPopular;
  final bool isPackage;
  final IconData icon;

  const DiagnosticTest({
    required this.id,
    required this.name,
    required this.category,
    required this.subtitle,
    required this.description,
    required this.price,
    required this.sampleType,
    required this.reportsInHours,
    required this.fastingRequired,
    required this.isPopular,
    required this.isPackage,
    required this.icon,
  });
}

class LabOption {
  final String id;
  final String name;
  final double rating;
  final int reviewsCount;
  final String address;
  final String hours;
  final String phone;
  final bool hasHomeCollection;
  final double price;

  const LabOption({
    required this.id,
    required this.name,
    required this.rating,
    required this.reviewsCount,
    required this.address,
    required this.hours,
    required this.phone,
    required this.hasHomeCollection,
    required this.price,
  });
}

enum BookingStatus { pending, completed, cancelled }
enum PaymentStatus { paid, unpaid }

class Booking {
  final String id;
  final DiagnosticTest test;
  final LabOption lab;
  final DateTime date;
  final String timeSlot;
  final FamilyMember patient;
  final bool isHomeCollection;
  final BookingStatus status;
  final PaymentStatus paymentStatus;
  final double totalAmount;

  const Booking({
    required this.id,
    required this.test,
    required this.lab,
    required this.date,
    required this.timeSlot,
    required this.patient,
    required this.isHomeCollection,
    required this.status,
    required this.paymentStatus,
    required this.totalAmount,
  });

  Booking copyWith({
    BookingStatus? status,
    PaymentStatus? paymentStatus,
  }) {
    return Booking(
      id: id,
      test: test,
      lab: lab,
      date: date,
      timeSlot: timeSlot,
      patient: patient,
      isHomeCollection: isHomeCollection,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      totalAmount: totalAmount,
    );
  }
}
