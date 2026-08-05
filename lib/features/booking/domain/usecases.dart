import 'entities.dart';
import 'repositories.dart';

class GetTestsUseCase {
  final BookingRepository repository;
  GetTestsUseCase(this.repository);

  Future<List<DiagnosticTest>> call() {
    return repository.getTests();
  }
}

class GetLabsUseCase {
  final BookingRepository repository;
  GetLabsUseCase(this.repository);

  Future<List<LabOption>> call() {
    return repository.getLabs();
  }
}

class GetBookingsUseCase {
  final BookingRepository repository;
  GetBookingsUseCase(this.repository);

  Future<List<Booking>> call() {
    return repository.getBookings();
  }
}

class CreateBookingUseCase {
  final BookingRepository repository;
  CreateBookingUseCase(this.repository);

  Future<Booking> call(Booking booking) {
    return repository.createBooking(booking);
  }
}

class CancelBookingUseCase {
  final BookingRepository repository;
  CancelBookingUseCase(this.repository);

  Future<void> call(String bookingId) {
    return repository.cancelBooking(bookingId);
  }
}
