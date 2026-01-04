// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserData {
  String? name;
  String? email;
  String? password;
  String? userId;
  String? profileImage; 
  UserData({
    this.name,
    this.email,
    this.password,
    this.userId,
    this.profileImage,
  });

  UserData copyWith({
    String? name,
    String? email,
    String? password,
    String? userId,
    String? profileImage,
  }) {
    return UserData(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      userId: userId ?? this.userId,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
      'userId': userId,
      'profileImage': profileImage,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      profileImage: map['profileImage'] != null ? map['profileImage'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserData.fromJson(String source) => UserData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserData(name: $name, email: $email, password: $password, userId: $userId, profileImage: $profileImage)';
  }

  @override
  bool operator ==(covariant UserData other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.email == email &&
      other.password == password &&
      other.userId == userId &&
      other.profileImage == profileImage;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      email.hashCode ^
      password.hashCode ^
      userId.hashCode ^
      profileImage.hashCode;
  }
}
