// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StoriesModel {
  final String id;
  final String imgUrl;
  final String autherId;
  final String createdAt;
  final String autherName;

  StoriesModel({
    this.autherName = '',
    required this.id,
    required this.imgUrl,
    required this.autherId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'imgUrl': imgUrl,
      'auther_id': autherId,
      'created_at': createdAt,
    };
  }

  factory StoriesModel.fromMap(Map<String, dynamic> map) {
    return StoriesModel(
      id: map['id'] as String,
      imgUrl: map['imgUrl'] as String,
      autherId: map['auther_id'] as String,
      createdAt: map['created_at'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory StoriesModel.fromJson(String source) =>
      StoriesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  StoriesModel copyWith({
    String? id,
    String? imgUrl,
    String? autherId,
    String? createdAt,
    String? autherName,
  }) {
    return StoriesModel(
      id: id ?? this.id,
      imgUrl: imgUrl ?? this.imgUrl,
      autherId: autherId ?? this.autherId,
      createdAt: createdAt ?? this.createdAt,
      autherName: autherName ?? this.autherName,
    );
  }
}
