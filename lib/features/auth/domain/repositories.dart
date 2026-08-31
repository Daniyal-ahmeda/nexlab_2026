import 'entities.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
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
  });
  Future<void> logout();
  Future<User?> getCurrentUser();
}
