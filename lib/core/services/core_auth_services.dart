import 'package:social_media_app/core/services/supabase_database_services.dart';
import 'package:social_media_app/features/auth/models/user_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CoreAuthServices {
  final supabaseDatabaseservices = SupabaseDatabaseServices.instance;
  final supabase = Supabase.instance.client;

  Future<UserData?> getCurrentUserData() async {
    try {
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        return null;
      }
      return await supabaseDatabaseservices.fetchRow<UserData?>(
        table: 'users',
        primaryKey: 'id',
        id: currentUserId,
        builder: (data, id) => UserData.fromMap(data),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<UserData?> getUserData(String userId) async {
    try {
      return await supabaseDatabaseservices.fetchRow<UserData?>(
        table: 'users',
        primaryKey: 'id',
        id: userId,
        builder: (data, id) => UserData.fromMap(data),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logOut() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
