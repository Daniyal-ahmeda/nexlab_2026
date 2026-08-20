import '../../../core/errors/failures.dart';
import '../domain/entities.dart';
import '../domain/repositories.dart';
import 'datasources.dart';

class HealthRepositoryImpl implements HealthRepository {
  final HealthRemoteDataSource remoteDataSource;
  final HealthMockDataSource mockDataSource;
  final bool useRemote;

  HealthRepositoryImpl({
    required this.remoteDataSource,
    required this.mockDataSource,
    required this.useRemote,
  });

  Future<T> _execute<T>(Future<T> Function() remoteCall, Future<T> Function() mockCall) async {
    if (useRemote) {
      try {
        return await remoteCall();
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
  Future<List<TestResult>> getResults() {
    return _execute(
      () => remoteDataSource.getResults().then((list) => list.map((e) => e as TestResult).toList()),
      () => mockDataSource.getResults().then((list) => list.map((e) => e as TestResult).toList()),
    );
  }

  @override
  Future<void> uploadPrescription(String filePath) {
    return _execute(
      () => remoteDataSource.uploadPrescription(filePath),
      () => mockDataSource.uploadPrescription(filePath),
    );
  }

  @override
  Future<List<FamilyMember>> getFamilyMembers() {
    return _execute(
      () => remoteDataSource.getFamilyMembers().then((list) => list.map((e) => e as FamilyMember).toList()),
      () => mockDataSource.getFamilyMembers().then((list) => list.map((e) => e as FamilyMember).toList()),
    );
  }

  @override
  Future<FamilyMember> addFamilyMember({
    required String name,
    required String relationship,
    required int age,
    required String gender,
    required String bloodGroup,
  }) {
    return _execute(
      () => remoteDataSource.addFamilyMember(
        name: name,
        relationship: relationship,
        age: age,
        gender: gender,
        bloodGroup: bloodGroup,
      ).then((e) => e as FamilyMember),
      () => mockDataSource.addFamilyMember(
        name: name,
        relationship: relationship,
        age: age,
        gender: gender,
        bloodGroup: bloodGroup,
      ).then((e) => e as FamilyMember),
    );
  }

  @override
  Future<void> deleteFamilyMember(String id) {
    return _execute(
      () => remoteDataSource.deleteFamilyMember(id),
      () => mockDataSource.deleteFamilyMember(id),
    );
  }

  @override
  Future<List<PaymentMethod>> getPaymentMethods() {
    return _execute(
      () => remoteDataSource.getPaymentMethods().then((list) => list.map((e) => e as PaymentMethod).toList()),
      () => mockDataSource.getPaymentMethods().then((list) => list.map((e) => e as PaymentMethod).toList()),
    );
  }

  @override
  Future<PaymentMethod> addPaymentMethod({
    required String type,
    required String number,
    required String expiry,
  }) {
    return _execute(
      () => remoteDataSource.addPaymentMethod(
        type: type,
        number: number,
        expiry: expiry,
      ).then((e) => e as PaymentMethod),
      () => mockDataSource.addPaymentMethod(
        type: type,
        number: number,
        expiry: expiry,
      ).then((e) => e as PaymentMethod),
    );
  }

  @override
  Future<void> setPaymentMethodAsDefault(String id) {
    return _execute(
      () => remoteDataSource.setPaymentMethodAsDefault(id),
      () => mockDataSource.setPaymentMethodAsDefault(id),
    );
  }

  @override
  Future<void> deletePaymentMethod(String id) {
    return _execute(
      () => remoteDataSource.deletePaymentMethod(id),
      () => mockDataSource.deletePaymentMethod(id),
    );
  }
}
