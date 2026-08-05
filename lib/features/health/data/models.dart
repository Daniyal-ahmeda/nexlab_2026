import '../domain/entities.dart';
import '../../booking/data/models.dart';

class FamilyMemberModel extends FamilyMember {
  const FamilyMemberModel({
    required super.id,
    required super.name,
    required super.relationship,
    required super.age,
    required super.gender,
    required super.bloodGroup,
  });

  factory FamilyMemberModel.fromJson(Map<String, dynamic> json) {
    return FamilyMemberModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      relationship: json['relationship'] ?? '',
      age: json['age'] as int? ?? 30,
      gender: json['gender'] ?? 'Male',
      bloodGroup: json['blood_group'] ?? 'O+',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'relationship': relationship,
      'age': age,
      'gender': gender,
      'blood_group': bloodGroup,
    };
  }
}

class PaymentMethodModel extends PaymentMethod {
  const PaymentMethodModel({
    required super.id,
    required super.type,
    required super.number,
    required super.expiry,
    required super.isDefault,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'].toString(),
      type: json['type'] ?? '',
      number: json['number'] ?? '',
      expiry: json['expiry'] ?? '',
      isDefault: json['is_default'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'number': number,
      'expiry': expiry,
      'is_default': isDefault,
    };
  }
}

class ResultParameterModel extends ResultParameter {
  const ResultParameterModel({
    required super.name,
    required super.value,
    required super.unit,
    required super.referenceRange,
    required super.status,
  });

  factory ResultParameterModel.fromJson(Map<String, dynamic> json) {
    return ResultParameterModel(
      name: json['name'] ?? '',
      value: json['value']?.toString() ?? '',
      unit: json['unit'] ?? '',
      referenceRange: json['reference_range'] ?? '',
      status: json['status'] ?? 'Normal',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
      'unit': unit,
      'reference_range': referenceRange,
      'status': status,
    };
  }
}

class TestResultModel extends TestResult {
  const TestResultModel({
    required super.id,
    required super.test,
    required super.labName,
    required super.testDate,
    required super.reportDate,
    required super.status,
    required super.parameters,
  });

  factory TestResultModel.fromJson(Map<String, dynamic> json) {
    final paramsJson = json['parameters'] as List? ?? [];
    final params = paramsJson.map((p) => ResultParameterModel.fromJson(p)).toList();

    return TestResultModel(
      id: json['id'].toString(),
      test: DiagnosticTestModel.fromJson(json['test']),
      labName: json['lab_name'] ?? '',
      testDate: json['test_date'] != null ? DateTime.parse(json['test_date']) : DateTime.now(),
      reportDate: json['report_date'] != null ? DateTime.parse(json['report_date']) : DateTime.now(),
      status: json['status'] ?? 'Results Available',
      parameters: params,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'test': (test as DiagnosticTestModel).toJson(),
      'lab_name': labName,
      'test_date': testDate.toIso8601String().substring(0, 10),
      'report_date': reportDate.toIso8601String().substring(0, 10),
      'status': status,
      'parameters': parameters.map((p) => (p as ResultParameterModel).toJson()).toList(),
    };
  }
}
