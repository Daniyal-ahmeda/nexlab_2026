import 'entities.dart';

abstract class HealthRepository {
  // Results & Reports
  Future<List<TestResult>> getResults();
  Future<void> uploadPrescription(String filePath);

  // Family Management
  Future<List<FamilyMember>> getFamilyMembers();
  Future<FamilyMember> addFamilyMember({
    required String name,
    required String relationship,
    required int age,
    required String gender,
    required String bloodGroup,
  });
  Future<void> deleteFamilyMember(String id);

  // Payment Configuration
  Future<List<PaymentMethod>> getPaymentMethods();
  Future<PaymentMethod> addPaymentMethod({
    required String type,
    required String number,
    required String expiry,
    required String firebaseToken,
  });
  Future<void> setPaymentMethodAsDefault(String id);
  Future<void> deletePaymentMethod(String id);
}
