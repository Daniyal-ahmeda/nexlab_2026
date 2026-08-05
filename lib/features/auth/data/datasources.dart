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
