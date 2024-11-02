import 'dart:convert';

class Credentials {
  final int id;
  final String title;
  final String email;
  final String password;
  Credentials({
    required this.id,
    required this.title,
    required this.email,
    required this.password,
  });

  Credentials copyWith({
    int? id,
    String? title,
    String? email,
    String? password,
  }) {
    return Credentials(
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

  factory Credentials.fromMap(Map<String, dynamic> map) {
    return Credentials(
      id: map['id'] as int,
      title: map['title'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Credentials.fromJson(String source) =>
      Credentials.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Credentials(id: $id, title: $title, email: $email, password: $password)';
  }

  @override
  bool operator ==(covariant Credentials other) {
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
}
