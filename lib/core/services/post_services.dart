import 'dart:io';

import 'package:social_media_app/core/services/supabase_database_services.dart';
import 'package:social_media_app/core/utils/app_constants.dart';
import 'package:social_media_app/core/utils/app_tables.dart';
import 'package:social_media_app/features/home/models/comment_model.dart';
import 'package:social_media_app/features/home/models/comment_request_body.dart';
import 'package:social_media_app/features/home/models/post_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostServices {
  final subabaseservices = SupabaseDatabaseServices.instance;
  final supabaseStorageClient = Supabase.instance.client;

  Future<PostModel> likePost(String postId, String userID) async {
    try {
      var post = await subabaseservices.fetchRow(
        table: AppTables.posts,
        primaryKey: 'id',
        id: postId,
        builder: (data, id) => PostModel.fromMap(data),
      );
      if (post.likes != null && post.likes!.contains(userID)) {
        post.likes!.remove(userID);
        post.copyWith(isLiked: false);
      } else {
        post = post.copyWith(likes: post.likes ?? []);
        post = post.copyWith(isLiked: true);
        post.likes!.add(userID);
      }
      await subabaseservices.updateRow(
        table: AppTables.posts,
        values: post.toMap(),
        column: 'id',
        value: postId,
      );
      return post;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addComment({
    required String postID,
    required String autherId,
    required String text,
    File? image,
  }) async {
    try {
      String? imgurl;
      if (image != null) {
        imgurl = await supabaseStorageClient.storage
            .from(AppTables.comments)
            .upload(
              'private/${DateTime.now().toIso8601String()}',
              image,
              fileOptions: FileOptions(cacheControl: '3600', upsert: true),
            );
      }
      var comment = CommentRequestBody(
        text: text,
        authorId: autherId,
        postId: postID,
        image: imgurl,
      );
      if (imgurl != null) {
        comment = comment.copyWith(
          image: '${AppConstants.baseMediaUrl}$imgurl',
        );
      }
      await subabaseservices.insertRow(
        table: AppTables.comments,
        values: comment.toMap(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CommentModel>> fetchComments(String postId) async {
    try {
      return await subabaseservices.fetchRows(
        table: AppTables.comments,
        builder: (data, id) => CommentModel.fromMap(data),
        filter: (query) => query.eq('post_id', postId),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<PostModel?> fetchPostById(String postId) async {
    try {
      return await subabaseservices.fetchRow(
        table: AppTables.posts,
        primaryKey: 'id',
        id: postId,
        builder: (data, id) => PostModel.fromMap(data),
      );
    } catch (e) {
      rethrow;
    }
  }
}
