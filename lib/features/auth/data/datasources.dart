import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/mock_database.dart';
import 'models.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String relationship,
    required int age,
    required String gender,
    required String bloodGroup,
  });
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await apiClient.post('/login', body: {
      'email': email,
      'password': password,
    });
    final user = UserModel.fromJson(response['user']);
    apiClient.setToken(response['token']);
    return user;
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String relationship,
    required int age,
    required String gender,
    required String bloodGroup,
  }) async {
    final response = await apiClient.post('/register', body: {
      'name': name,
      'email': email,
      'password': password,
      'relationship': relationship,
      'age': age,
      'gender': gender,
      'blood_group': bloodGroup,
    });
    final user = UserModel.fromJson(response['user']);
    apiClient.setToken(response['token']);
    return user;
  }

  @override
  Future<void> logout() async {
    await apiClient.post('/logout');
    apiClient.clearToken();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final response = await apiClient.get('/me');
      return UserModel.fromJson(response);
    } catch (_) {
      return null;
    }
  }
}

abstract class AuthMockDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register({
    required String name,
    required String email,
    required String relationship,
    required int age,
    required String gender,
    required String bloodGroup,
  });
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

class AuthMockDataSourceImpl implements AuthMockDataSource {
  final MockDatabase db;
  AuthMockDataSourceImpl() : db = MockDatabase.instance;

  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 400));

  @override
  Future<UserModel> login(String email, String password) async {
    await _delay();
    db.currentUser = UserModel(
      id: 'f_self',
      name: email.split('@')[0].toUpperCase(),
      email: email,
      relationship: 'Self',
      age: 34,
      gender: 'Male',
      bloodGroup: 'O+',
    );
    return db.currentUser!;
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String relationship,
    required int age,
    required String gender,
    required String bloodGroup,
  }) async {
    await _delay();
    db.currentUser = UserModel(
      id: 'f_self',
      name: name,
      email: email,
      relationship: relationship,
      age: age,
      gender: gender,
      bloodGroup: bloodGroup,
    );
    return db.currentUser!;
  }

  @override
  Future<void> logout() async {
    await _delay();
    db.currentUser = null;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    return db.currentUser;
  }
}

class AuthFirebaseDataSourceImpl implements AuthRemoteDataSource {
  final _auth = FirebaseAuth.instance;

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final user = credential.user;
      if (user == null) {
        throw const AuthException('Login failed: user is null');
      }
      return UserModel(
        id: user.uid,
        name: user.displayName ?? email.split('@')[0],
        email: user.email ?? email,
        relationship: 'Self',
        age: 30,
        gender: 'Male',
        bloodGroup: 'O+',
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Authentication error');
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String relationship,
    required int age,
    required String gender,
    required String bloodGroup,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final user = credential.user;
      if (user == null) {
        throw const AuthException('Registration failed: user is null');
      }
      await user.updateDisplayName(name);
      return UserModel(
        id: user.uid,
        name: name,
        email: user.email ?? email,
        relationship: relationship,
        age: age,
        gender: gender,
        bloodGroup: bloodGroup,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Registration error');
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return UserModel(
      id: user.uid,
      name: user.displayName ?? user.email?.split('@')[0] ?? 'User',
      email: user.email ?? '',
      relationship: 'Self',
      age: 30,
      gender: 'Male',
      bloodGroup: 'O+',
    );
  }
}

