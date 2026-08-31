import 'package:flutter/foundation.dart';

class ApiConstants {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000/api';
    }
    return 'http://192.168.0.101:8000/api';
  }
  static const String login = '/login';
  static const String register = '/register';
  static const String logout = '/logout';
  static const String me = '/me';
  static const String tests = '/tests';
  static const String labs = '/labs';
  static const String bookings = '/bookings';
  static const String results = '/results';
  static const String familyMembers = '/family-members';
  static const String paymentMethods = '/payment-methods';
}
