import 'entities.dart';
import 'repositories.dart';

class GetResultsUseCase {
  final HealthRepository repository;
  GetResultsUseCase(this.repository);

  Future<List<TestResult>> call() {
    return repository.getResults();
  }
}

class UploadPrescriptionUseCase {
  final HealthRepository repository;
  UploadPrescriptionUseCase(this.repository);

  Future<void> call(String filePath) {
    return repository.uploadPrescription(filePath);
  }
}

class GetFamilyMembersUseCase {
  final HealthRepository repository;
  GetFamilyMembersUseCase(this.repository);

  Future<List<FamilyMember>> call() {
    return repository.getFamilyMembers();
  }
}

class AddFamilyMemberUseCase {
  final HealthRepository repository;
  AddFamilyMemberUseCase(this.repository);

  Future<FamilyMember> call({
    required String name,
    required String relationship,
    required int age,
    required String gender,
    required String bloodGroup,
  }) {
    return repository.addFamilyMember(
      name: name,
      relationship: relationship,
      age: age,
      gender: gender,
      bloodGroup: bloodGroup,
    );
  }
}

class DeleteFamilyMemberUseCase {
  final HealthRepository repository;
  DeleteFamilyMemberUseCase(this.repository);

  Future<void> call(String id) {
    return repository.deleteFamilyMember(id);
  }
}

class GetPaymentMethodsUseCase {
  final HealthRepository repository;
  GetPaymentMethodsUseCase(this.repository);

  Future<List<PaymentMethod>> call() {
    return repository.getPaymentMethods();
  }
}

class AddPaymentMethodUseCase {
  final HealthRepository repository;
  AddPaymentMethodUseCase(this.repository);

  Future<PaymentMethod> call({
    required String type,
    required String number,
    required String expiry,
    required String firebaseToken,
  }) {
    return repository.addPaymentMethod(
      type: type,
      number: number,
      expiry: expiry,
      firebaseToken: firebaseToken,
    );
  }
}

class SetPaymentMethodAsDefaultUseCase {
  final HealthRepository repository;
  SetPaymentMethodAsDefaultUseCase(this.repository);

  Future<void> call(String id) {
    return repository.setPaymentMethodAsDefault(id);
  }
}

class DeletePaymentMethodUseCase {
  final HealthRepository repository;
  DeletePaymentMethodUseCase(this.repository);

  Future<void> call(String id) {
    return repository.deletePaymentMethod(id);
  }
}
