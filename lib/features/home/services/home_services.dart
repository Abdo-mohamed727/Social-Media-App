import 'dart:collection';
import 'dart:io';

import 'package:social_media_app/core/services/supabase_database_services.dart';
import 'package:social_media_app/core/utils/app_constants.dart';
import 'package:social_media_app/core/utils/app_tables.dart';
import 'package:social_media_app/features/home/models/comment_model.dart';
import 'package:social_media_app/features/home/models/comment_request_body.dart';
import 'package:social_media_app/features/home/models/post_model.dart';
import 'package:social_media_app/features/home/models/post_request_model.dart';
import 'package:social_media_app/features/home/models/stories_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeServices {
  final subabaseservices = SupabaseDatabaseServices.instance;
  final supabaseStorageClient = Supabase.instance.client;

  Future<List<StoriesModel>> fetchStories() async {
    try {
      return await subabaseservices.fetchRows(
        table: AppTables.stories,
        builder: (data, id) => StoriesModel.fromMap(data),
        primaryKey: 'id',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PostModel>> fetchPosts() async {
    try {
      return await subabaseservices.fetchRows(
        table: AppTables.posts,
        builder: (data, id) => PostModel.fromMap(data),
        primaryKey: 'id',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<CommentModel?> fetchCommentById(String commentId) async {
    try {
      return await subabaseservices.fetchRow(
        table: AppTables.comments,
        primaryKey: 'id',
        id: commentId,
        builder: (data, id) => CommentModel.fromMap(data),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addPost(PostRequestBody post, [File? image, File? file]) async {
    try {
      String? imageUrl;
      String? fileUrl;
      if (image != null) {
        imageUrl = await supabaseStorageClient.storage
            .from(AppTables.posts)
            .upload('private/${DateTime.now().toIso8601String()}', image);
      }
      if (file != null) {
        fileUrl = await supabaseStorageClient.storage
            .from(AppTables.posts)
            .upload('private/${DateTime.now().toIso8601String()}', file);
      }
      if (imageUrl != null || fileUrl != null) {
        post = post.copyWith(
          image: '${AppConstants.baseMediaUrl}$imageUrl',
          file: fileUrl,
        );
      }

      await subabaseservices.insertRow(
        table: AppTables.posts,
        values: post.toMap(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await subabaseservices.deleteRow(
        table: AppTables.comments,
        column: 'id',
        value: commentId,
      );
    } catch (e) {
      rethrow;
    }
  }
}
