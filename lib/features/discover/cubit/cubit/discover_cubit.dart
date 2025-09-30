import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/services/core_auth_services.dart';
import 'package:social_media_app/features/auth/models/user_data.dart';
import 'package:social_media_app/features/discover/srvices/discover_services.dart';
part 'discover_state.dart';

class DiscoverCubit extends Cubit<DiscoverState> {
  DiscoverCubit() : super(DiscoverInitial());
  final discoverPeople = Discoverpeople();
  final coreAuthServices = CoreAuthServices();

  Future<void> fetchUsers() async {
    emit(FetchingUsers());
    try {
      final users = await discoverPeople.discoverAllUSers();
      emit(UsersFetched(users));
    } catch (e) {
      emit(FetchUsersFailed(e.toString()));
    }
  }
}
