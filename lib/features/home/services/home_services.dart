import 'package:social_media_app/core/services/supabase_database_services.dart';
import 'package:social_media_app/core/utils/app_tables.dart';
import 'package:social_media_app/features/home/models/post_model.dart';
import 'package:social_media_app/features/home/models/post_request_model.dart';
import 'package:social_media_app/features/home/models/stories_model.dart';

class HomeServices {
  final subabaseservices = SupabaseDatabaseServices.instance;

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

  Future<void> addPost(PostRequestBody post) async {
    try {
      await subabaseservices.insertRow(
        table: AppTables.posts,
        values: post.toMap(),
      );
    } catch (e) {
      rethrow;
    }
  }
}
