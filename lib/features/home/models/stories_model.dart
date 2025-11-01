// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StoriesModel {
  // final String? id;
  final String? imgUrl;
  final String autherId;
  final String createdAt;
  final String autherName;
  final String? authorimage;

  final String text;

  StoriesModel({
    this.autherName = '',
    // required this.id,
    this.imgUrl,
    required this.autherId,
    required this.createdAt,
    required this.text,
    this.authorimage,
  });

  StoriesModel copyWith({
    String? id,
    String? imgUrl,
    String? autherId,
    String? createdAt,
    String? autherName,
    String? text,
    String? authorimage,
  }) {
    return StoriesModel(
      // id: id ?? this.id,
      imgUrl: imgUrl ?? this.imgUrl,
      autherId: autherId ?? this.autherId,
      createdAt: createdAt ?? this.createdAt,
      autherName: autherName ?? this.autherName,
      text: text ?? this.text,
      authorimage: authorimage ?? this.authorimage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'imgUrl': imgUrl,
      'author_id': autherId,
      'created_at': createdAt,
      'text': text,
    };
  }

  factory StoriesModel.fromMap(Map<String, dynamic> map) {
    return StoriesModel(
      imgUrl: map['imgUrl'] != null ? map['imgUrl'] as String : null,
      autherId: map['author_id'] ?? '',
      createdAt: map['created_at'] ?? '',
      text: map['text'] != null ? map['text'] ?? '' : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StoriesModel.fromJson(String source) =>
      StoriesModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
