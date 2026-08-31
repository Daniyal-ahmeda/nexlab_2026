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
      id: (json['id'] ?? 'user_1').toString(),
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      relationship: json['relationship']?.toString() ?? 'Self',
      age: json['age'] != null ? int.tryParse(json['age'].toString()) : null,
      gender: json['gender']?.toString(),
      bloodGroup: (json['blood_group'] ?? json['bloodGroup'])?.toString(),
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
