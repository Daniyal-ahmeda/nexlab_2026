import 'entities.dart';
import 'repositories.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<User> call(String email, String password) {
    return repository.login(email, password);
  }
}

class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  Future<User> call({
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
    return repository.register(
      name: name,
      email: email,
      password: password,
      relationship: relationship,
      age: age,
      gender: gender,
      bloodGroup: bloodGroup,
      firebaseToken: firebaseToken,
      phone: phone,
    );
  }
}

class LogoutUseCase {
  final AuthRepository repository;
  LogoutUseCase(this.repository);

  Future<void> call() {
    return repository.logout();
  }
}

class GetCurrentUserUseCase {
  final AuthRepository repository;
  GetCurrentUserUseCase(this.repository);

  Future<User?> call() {
    return repository.getCurrentUser();
  }
}
