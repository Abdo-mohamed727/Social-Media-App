import 'dart:io';

import 'package:social_media_app/core/services/supabase_database_services.dart';
import 'package:social_media_app/core/utils/app_tables.dart';
import 'package:social_media_app/features/home/models/post_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileServices {
  final subabaseservices = SupabaseDatabaseServices.instance;
  final supabaseStorageClient = Supabase.instance.client.storage;

  Future<List<PostModel>> fetchUserPosts(String userId) async {
    try {
      return await subabaseservices.fetchRows(
        table: AppTables.posts,
        builder: (data, id) => PostModel.fromMap(data),
        primaryKey: 'id',
        filter: (query) => query.eq('author_id', userId),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editProfilePage({
    required String userId,
    String? name,
    String? title,
    String? imageUrl,
  }) async {
    try {
      final values = {'name': name, 'title': title, 'img_Url': imageUrl};
      await subabaseservices.updateRow(
        table: AppTables.users,
        values: values,
        column: 'id',
        value: userId,
      );
    } catch (e) {
      rethrow;
    }
  }
}
