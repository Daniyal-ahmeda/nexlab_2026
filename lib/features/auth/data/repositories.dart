import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../domain/entities.dart';
import '../domain/repositories.dart';
import 'datasources.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthMockDataSource mockDataSource;
  final bool useRemote;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.mockDataSource,
    required this.useRemote,
  });

  Future<T> _execute<T>(Future<T> Function() remoteCall, Future<T> Function() mockCall) async {
    if (useRemote) {
      try {
        return await remoteCall();
      } on AuthException catch (e) {
        throw AuthFailure(e.message);
      } on ValidationException catch (e) {
        throw ValidationFailure(message: e.message, errors: e.errors);
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
  Future<User> login(String email, String password) {
    return _execute(
      () => remoteDataSource.login(email, password),
      () => mockDataSource.login(email, password),
    );
  }

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
    required String relationship,
    required int age,
    required String gender,
    required String bloodGroup,
    required String firebaseToken,
    String? phone,
  }) {
    return _execute(
      () => remoteDataSource.register(
        name: name,
        email: email,
        password: password,
        relationship: relationship,
        age: age,
        gender: gender,
        bloodGroup: bloodGroup,
        firebaseToken: firebaseToken,
        phone: phone,
      ),
      () => mockDataSource.register(
        name: name,
        email: email,
        password: password,
        relationship: relationship,
        age: age,
        gender: gender,
        bloodGroup: bloodGroup,
        firebaseToken: firebaseToken,
        phone: phone,
      ),
    );
  }

  @override
  Future<void> logout() {
    return _execute(
      () => remoteDataSource.logout(),
      () => mockDataSource.logout(),
    );
  }

  @override
  Future<User?> getCurrentUser() {
    return _execute(
      () => remoteDataSource.getCurrentUser(),
      () => mockDataSource.getCurrentUser(),
    );
  }
}
