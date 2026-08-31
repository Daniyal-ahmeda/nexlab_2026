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
    required String firebaseToken,
    String? phone,
  });
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  AuthRemoteDataSourceImpl(this.apiClient);

  Map<String, dynamic> _extractData(dynamic response) {
    if (response is Map<String, dynamic>) {
      if (response.containsKey('data') && response['data'] is Map<String, dynamic>) {
        return response['data'] as Map<String, dynamic>;
      }
      return response;
    }
    return {};
  }

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await apiClient.post('/login', body: {
      'email': email,
      'password': password,
    });
    final data = _extractData(response);
    final userJson = data.containsKey('user') ? data['user'] : data;
    final user = UserModel.fromJson(userJson as Map<String, dynamic>);
    if (data.containsKey('token') && data['token'] is String) {
      apiClient.setToken(data['token'] as String);
    }
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
    required String firebaseToken,
    String? phone,
  }) async {
    final response = await apiClient.post('/register', body: {
      'name': name,
      'email': email,
      'password': password,
      'relationship': relationship,
      'age': age,
      'gender': gender,
      'blood_group': bloodGroup,
      'phone': phone,
      'firebase_token': firebaseToken,
    });
    final data = _extractData(response);
    final userJson = data.containsKey('user') ? data['user'] : data;
    final user = UserModel.fromJson(userJson as Map<String, dynamic>);
    if (data.containsKey('token') && data['token'] is String) {
      apiClient.setToken(data['token'] as String);
    }
    return user;
  }

  @override
  Future<void> logout() async {
    try {
      await apiClient.post('/logout');
    } catch (_) {}
    apiClient.clearToken();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final response = await apiClient.get('/me');
      if (response == null) throw const AuthException('No active user session');
      final data = _extractData(response);
      final userJson = data.containsKey('user') ? data['user'] : data;
      return UserModel.fromJson(userJson as Map<String, dynamic>);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException(e.toString());
    }
  }
}

abstract class AuthMockDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register({
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
    required String password,
    required String relationship,
    required int age,
    required String gender,
    required String bloodGroup,
    required String firebaseToken,
    String? phone,
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
  FirebaseAuth get _auth {
    try {
      return FirebaseAuth.instance;
    } catch (e) {
      throw AuthException('no-app: Firebase is not initialized: $e');
    }
  }

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
    } on AuthException {
      rethrow;
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
    required String firebaseToken,
    String? phone,
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
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (_) {}
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
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
    } catch (_) {
      return null;
    }
  }
}
