import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/services/core_auth_services.dart';
import 'package:social_media_app/features/profile/services/profile_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitial());
  final profileServices = ProfileServices();
  final coreAuthServices = CoreAuthServices();
  final supabaseStorageClient = Supabase.instance.client;

File? Currentimage;
  Future<void> editProfilePage(
    String? name,
    String? title,
    String? imageurl,
    String? education,
    String? workExperiences,
    String? aboutMe,
    String? relationShip,
  ) async {
    emit(EditProfileLoading());
    try {
      
      final user = await coreAuthServices.getCurrentUserData();
      if (user == null) {
        emit(EditProfileFailed('Editing Failed'));
        return;
      }
      await profileServices.editProfilePage(
        
        userId: user.id,
        name: name,
        title: title,
        imageUrl: Currentimage,
        education: education,
        workExperiences: workExperiences,
        relationShip: relationShip,
        aboutMe: aboutMe,
      );
      emit(EditProfileSuccess());
    } catch (e) {
      emit(EditProfileFailed(e.toString()));
    }
  }
}
