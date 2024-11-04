import 'dart:convert';

class Credential {
  final int id;
  final String title;
  final String email;
  final String password;
  Credential({
    required this.id,
    required this.title,
    required this.email,
    required this.password,
  });

  Credential copyWith({
    int? id,
    String? title,
    String? email,
    String? password,
  }) {
    return Credential(
      id: id ?? this.id,
      title: title ?? this.title,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'email': email,
      'password': password,
    };
  }

  factory Credential.fromMap(Map<String, dynamic> map) {
    return Credential(
      id: map['id'] as int,
      title: map['title'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Credential.fromJson(String source) =>
      Credential.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Credential(id: $id, title: $title, email: $email, password: $password)';
  }

  @override
  bool operator ==(covariant Credential other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ email.hashCode ^ password.hashCode;
  }

  factory Credential.fromSqfliteDatabase(Map<String, dynamic> map) =>
      Credential(
          id: map['id']?.toInt() ?? 0,
          title: map['title'] ?? '',
          email: map['email'] ?? '',
          password: map['password'] ?? '');
}
