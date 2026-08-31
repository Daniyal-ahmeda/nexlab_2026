import '../domain/entities.dart';
import '../../booking/data/models.dart';

double _parseDouble(dynamic val, [double defaultVal = 0.0]) {
  if (val == null) return defaultVal;
  if (val is num) return val.toDouble();
  return double.tryParse(val.toString()) ?? defaultVal;
}

int _parseInt(dynamic val, [int defaultVal = 0]) {
  if (val == null) return defaultVal;
  if (val is num) return val.toInt();
  return int.tryParse(val.toString()) ?? defaultVal;
}

bool _parseBool(dynamic val, [bool defaultVal = false]) {
  if (val == null) return defaultVal;
  if (val is bool) return val;
  if (val is num) return val != 0;
  final str = val.toString().trim().toLowerCase();
  if (str == 'true' || str == '1' || str == 'yes') return true;
  if (str == 'false' || str == '0' || str == 'no') return false;
  return defaultVal;
}

String _parseString(dynamic val, [String defaultVal = '']) {
  if (val == null) return defaultVal;
  return val.toString().trim();
}

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
      id: _parseString(json['id'] ?? json['member_id'], 'f_${DateTime.now().millisecondsSinceEpoch}'),
      name: _parseString(json['name'] ?? json['full_name'], 'Family Member'),
      relationship: _parseString(json['relationship'] ?? json['relation'], 'Family'),
      age: _parseInt(json['age'], 30),
      gender: _parseString(json['gender'], 'Male'),
      bloodGroup: _parseString(json['blood_group'] ?? json['blood_type'], 'O+'),
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
      id: _parseString(json['id'] ?? json['method_id'], 'pm_${DateTime.now().millisecondsSinceEpoch}'),
      type: _parseString(json['type'] ?? json['gateway'] ?? json['network'], 'Edfaaly'),
      number: _parseString(json['number'] ?? json['account_number'] ?? json['phone'], '0910000000'),
      expiry: _parseString(json['expiry'] ?? json['expiry_date'], '12/28'),
      isDefault: _parseBool(json['is_default'] ?? json['default']),
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
      name: _parseString(json['name'] ?? json['parameter_name'], 'Parameter'),
      value: _parseString(json['value']),
      unit: _parseString(json['unit']),
      referenceRange: _parseString(json['reference_range'] ?? json['normal_range']),
      status: _parseString(json['status'] ?? json['flag'], 'Normal'),
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
    super.pdfUrl,
  });

  factory TestResultModel.fromJson(Map<String, dynamic> json) {
    DiagnosticTestModel testObj;
    if (json.containsKey('test') && json['test'] is Map<String, dynamic>) {
      testObj = DiagnosticTestModel.fromJson(json['test'] as Map<String, dynamic>);
    } else {
      final testId = _parseString(json['test_id'] ?? json['diagnostic_test_id'], 't1');
      testObj = DiagnosticTestModel(
        id: testId,
        name: _parseString(json['test_name'], 'Diagnostic Report Panel'),
        category: _parseString(json['category'], 'General'),
        subtitle: 'Official Diagnostic Laboratory Panel',
        description: 'Comprehensive Clinical Diagnostic Report',
        price: _parseDouble(json['price'], 140.0),
        sampleType: 'Blood',
        reportsInHours: 24,
        fastingRequired: false,
        isPopular: true,
        isPackage: false,
        icon: DiagnosticTestModel.fromJson({}).icon,
      );
    }

    List<ResultParameterModel> paramList = [];
    if (json.containsKey('parameters') && json['parameters'] is List) {
      paramList = (json['parameters'] as List)
          .map((p) => ResultParameterModel.fromJson(p as Map<String, dynamic>))
          .toList();
    }

    DateTime testDt;
    try {
      testDt = json['test_date'] != null ? DateTime.parse(json['test_date'].toString()) : DateTime.now();
    } catch (_) {
      testDt = DateTime.now();
    }

    DateTime reportDt;
    try {
      reportDt = json['report_date'] != null ? DateTime.parse(json['report_date'].toString()) : DateTime.now();
    } catch (_) {
      reportDt = DateTime.now();
    }

    return TestResultModel(
      id: _parseString(json['id'], 'RES${DateTime.now().millisecondsSinceEpoch}'),
      test: testObj,
      labName: _parseString(json['lab_name'] ?? json['laboratory'], 'Tripoli Central Diagnostic Lab'),
      testDate: testDt,
      reportDate: reportDt,
      status: _parseString(json['status'], 'NORMAL'),
      parameters: paramList,
      pdfUrl: json['pdf_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'test_id': test.id,
      'lab_name': labName,
      'test_date': testDate.toIso8601String().substring(0, 10),
      'report_date': reportDate.toIso8601String().substring(0, 10),
      'status': status,
      'parameters': parameters.map((p) {
        if (p is ResultParameterModel) return p.toJson();
        return {
          'name': p.name,
          'value': p.value,
          'unit': p.unit,
          'reference_range': p.referenceRange,
          'status': p.status,
        };
      }).toList(),
      'pdf_url': pdfUrl,
    };
  }
}
