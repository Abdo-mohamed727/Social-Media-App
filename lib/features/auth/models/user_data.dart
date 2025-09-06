// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserData {
  final String name;

  final String? imgUrl;
  final String email;
  final String? title;
  final String id;

  const UserData({
    required this.name,

    this.imgUrl,
    required this.email,
    this.title,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,

      'img_Url': imgUrl,
      'email': email,
      'title': title,
      'id': id,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      name: map['name'] as String,

      imgUrl: map['img_Url'] != null ? map['img_Url'] as String : null,
      email: map['email'] as String,
      title: map['title'] != null ? map['title'] as String : null,
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserData.fromJson(String source) =>
      UserData.fromMap(json.decode(source) as Map<String, dynamic>);

  UserData copyWith({
    String? name,

    String? imgUrl,
    String? email,
    String? title,
    String? id,
  }) {
    return UserData(
      name: name ?? this.name,

      imgUrl: imgUrl ?? this.imgUrl,
      email: email ?? this.email,
      title: title ?? this.title,
      id: id ?? this.id,
    );
  }
}
