import '../../../core/network/api_client.dart';
import '../../../core/network/mock_database.dart';
import 'models.dart';

abstract class HealthRemoteDataSource {
  Future<List<TestResultModel>> getResults();

  Future<List<FamilyMemberModel>> getFamilyMembers();
  Future<FamilyMemberModel> addFamilyMember({
    required String name,
    required String relationship,
    required int age,
    required String gender,
    required String bloodGroup,
  });
  Future<void> deleteFamilyMember(String id);

  Future<List<PaymentMethodModel>> getPaymentMethods();
  Future<PaymentMethodModel> addPaymentMethod({
    required String type,
    required String number,
    required String expiry,
    required String firebaseToken,
  });
  Future<void> setPaymentMethodAsDefault(String id);
  Future<void> deletePaymentMethod(String id);
}

class HealthRemoteDataSourceImpl implements HealthRemoteDataSource {
  final ApiClient apiClient;
  HealthRemoteDataSourceImpl(this.apiClient);

  List<dynamic> _extractList(dynamic response) {
    if (response is List) {
      return response;
    }
    if (response is Map<String, dynamic>) {
      if (response.containsKey('data')) {
        final d = response['data'];
        if (d is List) return d;
        if (d is Map<String, dynamic>) {
          if (d.containsKey('data') && d['data'] is List) return d['data'] as List<dynamic>;
          if (d.containsKey('results') && d['results'] is List) return d['results'] as List<dynamic>;
          if (d.containsKey('family_members') && d['family_members'] is List) return d['family_members'] as List<dynamic>;
          if (d.containsKey('payment_methods') && d['payment_methods'] is List) return d['payment_methods'] as List<dynamic>;
        }
      }
      if (response.containsKey('results') && response['results'] is List) {
        return response['results'] as List<dynamic>;
      }
      if (response.containsKey('family_members') && response['family_members'] is List) {
        return response['family_members'] as List<dynamic>;
      }
      if (response.containsKey('payment_methods') && response['payment_methods'] is List) {
        return response['payment_methods'] as List<dynamic>;
      }
      if (response.containsKey('items') && response['items'] is List) {
        return response['items'] as List<dynamic>;
      }
    }
    return [];
  }

  @override
  Future<List<TestResultModel>> getResults() async {
    final response = await apiClient.get('/results');
    final list = _extractList(response);
    return list.map((json) => TestResultModel.fromJson(json)).toList();
  }

  @override
  Future<List<FamilyMemberModel>> getFamilyMembers() async {
    final response = await apiClient.get('/family-members');
    final list = _extractList(response);
    return list.map((json) => FamilyMemberModel.fromJson(json)).toList();
  }

  @override
  Future<FamilyMemberModel> addFamilyMember({
    required String name,
    required String relationship,
    required int age,
    required String gender,
    required String bloodGroup,
  }) async {
    final response = await apiClient.post('/family-members', body: {
      'name': name,
      'relationship': relationship,
      'age': age,
      'gender': gender,
      'blood_group': bloodGroup,
    });
    final data = (response is Map<String, dynamic> && response.containsKey('data')) ? response['data'] : response;
    return FamilyMemberModel.fromJson(data);
  }

  @override
  Future<void> deleteFamilyMember(String id) async {
    await apiClient.delete('/family-members/$id');
  }

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    final response = await apiClient.get('/payment-methods');
    final list = _extractList(response);
    return list.map((json) => PaymentMethodModel.fromJson(json)).toList();
  }

  @override
  Future<PaymentMethodModel> addPaymentMethod({
    required String type,
    required String number,
    required String expiry,
    required String firebaseToken,
  }) async {
    final response = await apiClient.post('/payment-methods', body: {
      'type': type,
      'number': number,
      'expiry': expiry,
      'is_default': true,
      'firebase_token': firebaseToken,
    });
    final data = (response is Map<String, dynamic> && response.containsKey('data')) ? response['data'] : response;
    return PaymentMethodModel.fromJson(data);
  }

  @override
  Future<void> setPaymentMethodAsDefault(String id) async {
    try {
      await apiClient.post('/payment-methods/$id/default');
    } catch (_) {
      await apiClient.put('/payment-methods/$id/default');
    }
  }

  @override
  Future<void> deletePaymentMethod(String id) async {
    await apiClient.delete('/payment-methods/$id');
  }
}

abstract class HealthMockDataSource {
  Future<List<TestResultModel>> getResults();

  Future<List<FamilyMemberModel>> getFamilyMembers();
  Future<FamilyMemberModel> addFamilyMember({
    required String name,
    required String relationship,
    required int age,
    required String gender,
    required String bloodGroup,
  });
  Future<void> deleteFamilyMember(String id);

  Future<List<PaymentMethodModel>> getPaymentMethods();
  Future<PaymentMethodModel> addPaymentMethod({
    required String type,
    required String number,
    required String expiry,
    required String firebaseToken,
  });
  Future<void> setPaymentMethodAsDefault(String id);
  Future<void> deletePaymentMethod(String id);
}

class HealthMockDataSourceImpl implements HealthMockDataSource {
  final MockDatabase db;
  HealthMockDataSourceImpl() : db = MockDatabase.instance;

  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 400));

  @override
  Future<List<TestResultModel>> getResults() async {
    await _delay();
    return db.results;
  }

  @override
  Future<List<FamilyMemberModel>> getFamilyMembers() async {
    await _delay();
    return db.familyMembers;
  }

  @override
  Future<FamilyMemberModel> addFamilyMember({
    required String name,
    required String relationship,
    required int age,
    required String gender,
    required String bloodGroup,
  }) async {
    await _delay();
    final newMember = FamilyMemberModel(
      id: 'f_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      relationship: relationship,
      age: age,
      gender: gender,
      bloodGroup: bloodGroup,
    );
    db.familyMembers.add(newMember);
    return newMember;
  }

  @override
  Future<void> deleteFamilyMember(String id) async {
    await _delay();
    db.familyMembers.removeWhere((m) => m.id == id);
  }

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    await _delay();
    return db.paymentMethods;
  }

  @override
  Future<PaymentMethodModel> addPaymentMethod({
    required String type,
    required String number,
    required String expiry,
    required String firebaseToken,
  }) async {
    await _delay();
    final newMethod = PaymentMethodModel(
      id: 'pm_${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      number: number,
      expiry: expiry,
      isDefault: db.paymentMethods.isEmpty,
    );
    db.paymentMethods.add(newMethod);
    return newMethod;
  }

  @override
  Future<void> setPaymentMethodAsDefault(String id) async {
    await _delay();
    for (int i = 0; i < db.paymentMethods.length; i++) {
      final pm = db.paymentMethods[i];
      db.paymentMethods[i] = PaymentMethodModel(
        id: pm.id,
        type: pm.type,
        number: pm.number,
        expiry: pm.expiry,
        isDefault: pm.id == id,
      );
    }
  }

  @override
  Future<void> deletePaymentMethod(String id) async {
    await _delay();
    db.paymentMethods.removeWhere((pm) => pm.id == id);
    if (db.paymentMethods.isNotEmpty && !db.paymentMethods.any((pm) => pm.isDefault)) {
      await setPaymentMethodAsDefault(db.paymentMethods[0].id);
    }
  }
}
