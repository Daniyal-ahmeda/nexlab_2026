import '../domain/entities.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.relationship,
    super.age,
    super.gender,
    super.bloodGroup,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      relationship: json['relationship'],
      age: json['age'] != null ? int.tryParse(json['age'].toString()) ?? json['age'] : null,
      gender: json['gender'],
      bloodGroup: json['blood_group'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'relationship': relationship,
      'age': age,
      'gender': gender,
      'blood_group': bloodGroup,
    };
  }
}
