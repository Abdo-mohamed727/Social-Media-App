// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserData {
  final String name;

  final String? imgUrl;
  final String email;
  final String? title;
  final String id;
  final num? followerscount;
  final num? followingCount;
  final num? postscount;
  final List<String>? following;
  final List<String>? followers;

  const UserData({
    required this.name,
    this.postscount,

    this.imgUrl,
    required this.email,
    this.title,
    required this.id,
    this.followerscount,
    this.followingCount,
    this.following,
    this.followers,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,

      'img_Url': imgUrl,
      'email': email,
      'title': title,
      'id': id,
      if (followerscount != null) 'followers_conut': followerscount,
      if (followingCount != null) 'following_count': followingCount,
      'following': following,
      'followers': followers,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      name: map['name'] as String,

      imgUrl: map['img_Url'] != null ? map['img_Url'] as String : null,
      email: map['email'] as String,
      title: map['title'] != null ? map['title'] as String : null,
      id: map['id'] as String,
      followerscount: map['followers_conut'],
      followingCount: map['following_count'],
      following: map['following'] != null
          ? List<String>.from(map['following'] ?? [])
          : null,
      followers: map['followers'] != null
          ? List<String>.from(map['followers'] ?? [])
          : null,
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
    num? followerscount,
    num? followingcount,
    num? postscount,
  }) {
    return UserData(
      name: name ?? this.name,

      imgUrl: imgUrl ?? this.imgUrl,
      email: email ?? this.email,
      title: title ?? this.title,
      id: id ?? this.id,
      followerscount: followerscount ?? this.followerscount,
      followingCount: followingcount ?? this.followingCount,
      following: following ?? this.following,
      followers: followers ?? this.followers,
      postscount: postscount ?? this.postscount,
    );
  }
}
