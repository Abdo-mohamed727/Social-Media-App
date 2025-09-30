import 'package:social_media_app/core/services/supabase_database_services.dart';
import 'package:social_media_app/core/utils/app_tables.dart';
import 'package:social_media_app/features/auth/models/user_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Discoverpeople {
  final supabasedatabaseServices = SupabaseDatabaseServices.instance;

  Future<List<UserData>> discoverAllUSers() async {
    try {
      return await supabasedatabaseServices.fetchRows(
        table: AppTables.users,
        builder: (data, id) => UserData.fromMap(data),
        primaryKey: 'id',
      );
    } catch (e) {
      rethrow;
    }
  }
}
