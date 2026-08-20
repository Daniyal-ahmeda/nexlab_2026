import '../../../core/errors/failures.dart';
import '../domain/entities.dart';
import '../domain/repositories.dart';
import 'datasources.dart';
import 'models.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;
  final BookingMockDataSource mockDataSource;
  final bool useRemote;

  BookingRepositoryImpl({
    required this.remoteDataSource,
    required this.mockDataSource,
    required this.useRemote,
  });

  Future<T> _execute<T>(Future<T> Function() remoteCall, Future<T> Function() mockCall) async {
    if (useRemote) {
      try {
        return await remoteCall();
      } catch (e) {
        throw ServerFailure(e.toString());
      }
    } else {
      try {
        return await mockCall();
      } catch (e) {
        throw ServerFailure(e.toString());
      }
    }
  }

  @override
  Future<List<DiagnosticTest>> getTests() {
    return _execute(
      () => remoteDataSource.getTests().then((list) => list.map((e) => e as DiagnosticTest).toList()),
      () => mockDataSource.getTests().then((list) => list.map((e) => e as DiagnosticTest).toList()),
    );
  }

  @override
  Future<List<LabOption>> getLabs() {
    return _execute(
      () => remoteDataSource.getLabs().then((list) => list.map((e) => e as LabOption).toList()),
      () => mockDataSource.getLabs().then((list) => list.map((e) => e as LabOption).toList()),
    );
  }

  @override
  Future<List<Booking>> getBookings() {
    return _execute(
      () => remoteDataSource.getBookings().then((list) => list.map((e) => e as Booking).toList()),
      () => mockDataSource.getBookings().then((list) => list.map((e) => e as Booking).toList()),
    );
  }

  @override
  Future<Booking> createBooking(Booking booking) {
    final bookingModel = BookingModel(
      id: booking.id,
      test: booking.test,
      lab: booking.lab,
      date: booking.date,
      timeSlot: booking.timeSlot,
      patient: booking.patient,
      isHomeCollection: booking.isHomeCollection,
      status: booking.status,
      paymentStatus: booking.paymentStatus,
      totalAmount: booking.totalAmount,
    );

    return _execute(
      () => remoteDataSource.createBooking(bookingModel).then((e) => e as Booking),
      () => mockDataSource.createBooking(bookingModel).then((e) => e as Booking),
    );
  }

  @override
  Future<void> cancelBooking(String bookingId) {
    return _execute(
      () => remoteDataSource.cancelBooking(bookingId),
      () => mockDataSource.cancelBooking(bookingId),
    );
  }
}
