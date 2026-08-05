import '../../health/domain/entities.dart'; // To reference FamilyMember

class User {
  final String id;
  final String name;
  final String email;
  final String? relationship;
  final int? age;
  final String? gender;
  final String? bloodGroup;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.relationship,
    this.age,
    this.gender,
    this.bloodGroup,
  });

  FamilyMember toFamilyMember() {
    return FamilyMember(
      id: id,
      name: name,
      relationship: relationship ?? 'Self',
      age: age ?? 30,
      gender: gender ?? 'Male',
      bloodGroup: bloodGroup ?? 'O+',
    );
  }
}
