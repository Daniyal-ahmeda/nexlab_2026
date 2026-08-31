import '../../booking/domain/entities.dart'; // To reference DiagnosticTest

class FamilyMember {
  final String id;
  final String name;
  final String relationship;
  final int age;
  final String gender;
  final String bloodGroup;

  const FamilyMember({
    required this.id,
    required this.name,
    required this.relationship,
    required this.age,
    required this.gender,
    required this.bloodGroup,
  });
}

class PaymentMethod {
  final String id;
  final String type;
  final String number;
  final String expiry;
  final bool isDefault;

  const PaymentMethod({
    required this.id,
    required this.type,
    required this.number,
    required this.expiry,
    required this.isDefault,
  });
}

class ResultParameter {
  final String name;
  final String value;
  final String unit;
  final String referenceRange;
  final String status; // Normal, Low, High, Borderline

  const ResultParameter({
    required this.name,
    required this.value,
    required this.unit,
    required this.referenceRange,
    required this.status,
  });
}

class TestResult {
  final String id;
  final DiagnosticTest test;
  final String labName;
  final DateTime testDate;
  final DateTime reportDate;
  final String status;
  final List<ResultParameter> parameters;
  final String? pdfUrl;

  const TestResult({
    required this.id,
    required this.test,
    required this.labName,
    required this.testDate,
    required this.reportDate,
    required this.status,
    required this.parameters,
    this.pdfUrl,
  });
}
