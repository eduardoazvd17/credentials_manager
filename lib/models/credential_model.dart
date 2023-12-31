import 'dart:convert';

import 'package:equatable/equatable.dart';

class CredentialModel extends Equatable {
  final String id;
  final String loginOrEmail;
  final String password;
  final String? name;
  final String? imageUrl;

  const CredentialModel({
    required this.id,
    required this.loginOrEmail,
    required this.password,
    this.name,
    this.imageUrl,
  });

  factory CredentialModel.fromMap(Map<String, dynamic> map) {
    return CredentialModel(
      id: map['id']!,
      loginOrEmail: map['loginOrEmail']!,
      password: map['password']!,
      name: map['name'],
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, String?> toMap() {
    return {
      'id': id,
      'loginOrEmail': loginOrEmail,
      'password': password,
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  factory CredentialModel.fromJson(String json) {
    final map = Map<String, dynamic>.from(jsonDecode(json));
    return CredentialModel.fromMap(map);
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory CredentialModel.fromString(String json) {
    return CredentialModel.fromJson(json);
  }

  @override
  String toString() => toJson();

  @override
  List<Object?> get props => [id];
}
