import 'package:nexlab_2026/core/network/api_client.dart';
import 'package:nexlab_2026/core/network/mock_database.dart';
import 'package:nexlab_2026/features/booking/domain/entities.dart';
import 'models.dart';

abstract class BookingRemoteDataSource {
  Future<List<DiagnosticTestModel>> getTests();
  Future<List<LabOptionModel>> getLabs();
  Future<List<BookingModel>> getBookings();
  Future<BookingModel> createBooking(BookingModel booking);
  Future<void> cancelBooking(String bookingId);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final ApiClient apiClient;
  BookingRemoteDataSourceImpl(this.apiClient);

  List<dynamic> _extractList(dynamic response) {
    if (response is List) {
      return response;
    }
    if (response is Map<String, dynamic>) {
      if (response.containsKey('data')) {
        final d = response['data'];
        if (d is List) return d;
        if (d is Map<String, dynamic>) {
          if (d.containsKey('data') && d['data'] is List) return d['data'] as List<dynamic>;
          if (d.containsKey('tests') && d['tests'] is List) return d['tests'] as List<dynamic>;
          if (d.containsKey('labs') && d['labs'] is List) return d['labs'] as List<dynamic>;
          if (d.containsKey('bookings') && d['bookings'] is List) return d['bookings'] as List<dynamic>;
        }
      }
      if (response.containsKey('tests') && response['tests'] is List) {
        return response['tests'] as List<dynamic>;
      }
      if (response.containsKey('labs') && response['labs'] is List) {
        return response['labs'] as List<dynamic>;
      }
      if (response.containsKey('bookings') && response['bookings'] is List) {
        return response['bookings'] as List<dynamic>;
      }
      if (response.containsKey('results') && response['results'] is List) {
        return response['results'] as List<dynamic>;
      }
      if (response.containsKey('items') && response['items'] is List) {
        return response['items'] as List<dynamic>;
      }
    }
    return [];
  }

  @override
  Future<List<DiagnosticTestModel>> getTests() async {
    final response = await apiClient.get('/tests');
    final list = _extractList(response);
    return list.map((json) => DiagnosticTestModel.fromJson(json)).toList();
  }

  @override
  Future<List<LabOptionModel>> getLabs() async {
    final response = await apiClient.get('/labs');
    final list = _extractList(response);
    return list.map((json) => LabOptionModel.fromJson(json)).toList();
  }

  @override
  Future<List<BookingModel>> getBookings() async {
    final response = await apiClient.get('/bookings');
    final list = _extractList(response);
    return list.map((json) => BookingModel.fromJson(json)).toList();
  }

  @override
  Future<BookingModel> createBooking(BookingModel booking) async {
    final response = await apiClient.post('/bookings', body: booking.toJson());
    if (response is Map<String, dynamic>) {
      final data = response.containsKey('data') && response['data'] is Map<String, dynamic>
          ? response['data'] as Map<String, dynamic>
          : (response.containsKey('booking') && response['booking'] is Map<String, dynamic>
              ? response['booking'] as Map<String, dynamic>
              : response);
      if (data.containsKey('id')) {
        final parsed = BookingModel.fromJson(data);
        return BookingModel(
          id: parsed.id,
          test: parsed.test.name != 'Diagnostic Test' ? parsed.test : booking.test,
          lab: parsed.lab.name != 'Tripoli Central Diagnostic Lab' ? parsed.lab : booking.lab,
          date: parsed.date,
          timeSlot: parsed.timeSlot.isNotEmpty ? parsed.timeSlot : booking.timeSlot,
          patient: parsed.patient.name != 'Dani' ? parsed.patient : booking.patient,
          isHomeCollection: parsed.isHomeCollection,
          status: parsed.status,
          paymentStatus: parsed.paymentStatus,
          totalAmount: parsed.totalAmount > 0 ? parsed.totalAmount : booking.totalAmount,
        );
      }
    }
    return booking;
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    try {
      await apiClient.post('/bookings/$bookingId/cancel');
    } catch (_) {
      await apiClient.put('/bookings/$bookingId/cancel');
    }
  }
}

abstract class BookingMockDataSource {
  Future<List<DiagnosticTestModel>> getTests();
  Future<List<LabOptionModel>> getLabs();
  Future<List<BookingModel>> getBookings();
  Future<BookingModel> createBooking(BookingModel booking);
  Future<void> cancelBooking(String bookingId);
}

class BookingMockDataSourceImpl implements BookingMockDataSource {
  final MockDatabase db;
  BookingMockDataSourceImpl() : db = MockDatabase.instance;

  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 400));

  @override
  Future<List<DiagnosticTestModel>> getTests() async {
    await _delay();
    return db.allTests;
  }

  @override
  Future<List<LabOptionModel>> getLabs() async {
    await _delay();
    return db.allLabs;
  }

  @override
  Future<List<BookingModel>> getBookings() async {
    await _delay();
    return db.bookings;
  }

  @override
  Future<BookingModel> createBooking(BookingModel booking) async {
    await _delay();
    db.bookings.insert(0, booking);
    return booking;
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    await _delay();
    for (int i = 0; i < db.bookings.length; i++) {
      if (db.bookings[i].id == bookingId) {
        db.bookings[i] = db.bookings[i].copyWith(status: BookingStatus.cancelled) as BookingModel;
      }
    }
  }
}
