import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/services/core_auth_services.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial());
  final coreauthServices = CoreAuthServices();

  Future<void> logout() async {
    emit(LogOutLooding());
    try {
      await coreauthServices.logOut();
    } catch (e) {
      emit(LogoutError(e.toString()));
    }
  }
}
