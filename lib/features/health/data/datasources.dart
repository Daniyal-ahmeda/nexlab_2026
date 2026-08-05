import '../../../core/network/api_client.dart';
import '../../../core/network/mock_database.dart';
import 'models.dart';

abstract class HealthRemoteDataSource {
  Future<List<TestResultModel>> getResults();
  Future<void> uploadPrescription(String filePath);

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
  });
  Future<void> setPaymentMethodAsDefault(String id);
  Future<void> deletePaymentMethod(String id);
}

class HealthRemoteDataSourceImpl implements HealthRemoteDataSource {
  final ApiClient apiClient;
  HealthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<TestResultModel>> getResults() async {
    final List<dynamic> response = await apiClient.get('/results');
    return response.map((json) => TestResultModel.fromJson(json)).toList();
  }

  @override
  Future<void> uploadPrescription(String filePath) async {
    await apiClient.post('/prescriptions', body: {
      'file_path': filePath,
    });
  }

  @override
  Future<List<FamilyMemberModel>> getFamilyMembers() async {
    final List<dynamic> response = await apiClient.get('/family-members');
    return response.map((json) => FamilyMemberModel.fromJson(json)).toList();
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
    return FamilyMemberModel.fromJson(response);
  }

  @override
  Future<void> deleteFamilyMember(String id) async {
    await apiClient.delete('/family-members/$id');
  }

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    final List<dynamic> response = await apiClient.get('/payment-methods');
    return response.map((json) => PaymentMethodModel.fromJson(json)).toList();
  }

  @override
  Future<PaymentMethodModel> addPaymentMethod({
    required String type,
    required String number,
    required String expiry,
  }) async {
    final response = await apiClient.post('/payment-methods', body: {
      'type': type,
      'number': number,
      'expiry': expiry,
    });
    return PaymentMethodModel.fromJson(response);
  }

  @override
  Future<void> setPaymentMethodAsDefault(String id) async {
    await apiClient.put('/payment-methods/$id/default');
  }

  @override
  Future<void> deletePaymentMethod(String id) async {
    await apiClient.delete('/payment-methods/$id');
  }
}

abstract class HealthMockDataSource {
  Future<List<TestResultModel>> getResults();
  Future<void> uploadPrescription(String filePath);

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
  Future<void> uploadPrescription(String filePath) async {
    await _delay();
    db.uploadedPrescriptions.add(filePath);
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
