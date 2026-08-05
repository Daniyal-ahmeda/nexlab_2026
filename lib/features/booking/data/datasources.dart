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

  @override
  Future<List<DiagnosticTestModel>> getTests() async {
    final List<dynamic> response = await apiClient.get('/tests');
    return response.map((json) => DiagnosticTestModel.fromJson(json)).toList();
  }

  @override
  Future<List<LabOptionModel>> getLabs() async {
    final List<dynamic> response = await apiClient.get('/labs');
    return response.map((json) => LabOptionModel.fromJson(json)).toList();
  }

  @override
  Future<List<BookingModel>> getBookings() async {
    final List<dynamic> response = await apiClient.get('/bookings');
    return response.map((json) => BookingModel.fromJson(json)).toList();
  }

  @override
  Future<BookingModel> createBooking(BookingModel booking) async {
    final response = await apiClient.post('/bookings', body: booking.toJson());
    return BookingModel.fromJson(response);
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    await apiClient.put('/bookings/$bookingId/cancel');
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
