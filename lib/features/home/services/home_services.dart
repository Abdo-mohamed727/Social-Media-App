import 'dart:io';

import 'package:social_media_app/core/services/supabase_database_services.dart';
import 'package:social_media_app/core/utils/app_tables.dart';
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
          image:
              'https://mxeceaudtldkyolieayz.supabase.co/storage/v1/object/public/$imageUrl',
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
}
