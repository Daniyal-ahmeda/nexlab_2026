import 'entities.dart';

abstract class BookingRepository {
  Future<List<DiagnosticTest>> getTests();
  Future<List<LabOption>> getLabs();
  Future<List<Booking>> getBookings();
  Future<Booking> createBooking(Booking booking);
  Future<void> cancelBooking(String bookingId);
}
