import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/core/services/core_auth_services.dart';
import 'package:social_media_app/features/auth/models/user_data.dart';
import 'package:social_media_app/features/home/models/post_model.dart';
import 'package:social_media_app/features/home/models/post_request_model.dart';

import 'package:social_media_app/features/home/models/stories_model.dart';
import 'package:social_media_app/features/home/services/file_picker_services.dart';
import 'package:social_media_app/features/home/services/home_services.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final homeservices = HomeServices();
  final coreAuthServices = CoreAuthServices();
  final filepickerservices = FilePickerServices();
  File? currentImage;
  File? currentFile;

  Future<void> fetchSories() async {
    emit(StoriesLoading());
    try {
      final rawStories = await homeservices.fetchStories();
      List<StoriesModel> stories = [];
      for (var story in rawStories) {
        final userData = await coreAuthServices.getUserData(story.autherId);
        if (userData != null) {
          story = story.copyWith(autherName: userData.name);
        }
        stories.add(story);
      }

      emit(StoriesLooded(stories));
    } catch (e) {
      emit(StoriesError(e.toString()));
    }
  }

  Future<void> fetchposts() async {
    emit(PostLoading());
    try {
      final rawPosts = await homeservices.fetchPosts();
      List<PostModel> posts = [];
      for (var post in rawPosts) {
        final userData = await coreAuthServices.getUserData(post.authorId);
        if (userData != null) {
          post = post.copyWith(authorName: userData.name);
        }
        posts.add(post);
      }

      emit(PostLoaded(posts));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> createPost({required String text}) async {
    emit(PostAdding());
    try {
      final currentUser = await coreAuthServices.getCurrentUserData();
      if (currentUser == null) {
        emit(PostAddError('user not authenticated'));
        return;
      }
      final post = PostRequestBody(text: text, authorId: currentUser.id);
      await homeservices.addPost(post, currentImage, currentFile);
      emit(PostAdded(post));
    } catch (e) {
      emit(PostAddError(e.toString()));
    }
  }

  Future<void> refrech() async {
    await fetchSories();
    await fetchposts();
  }

  Future<void> fetchInitialUserData() async {
    emit(POstcreatingInitialLoading());
    try {
      final userData = await coreAuthServices.getCurrentUserData();
      if (userData == null) {
        emit(PostAddError('user not authenticated'));
        return;
      }
      emit(PostInitialCreated(userData));
    } catch (e) {
      emit(PostAddError(e.toString()));
    }
  }

  Future<void> pickImage() async {
    emit(PickingImage());
    try {
      final image = await filepickerservices.pickImage();
      if (image != null) {
        currentImage = File(image.path);
        emit(ImagePicked(currentImage!));
      } else {
        emit(ImagePickedError('no image seleted'));
      }
    } catch (e) {
      emit(ImagePickedError(e.toString()));
    }
  }

  Future<void> takephoto() async {
    emit(PickingImage());
    try {
      final photo = await filepickerservices.takePhoto();
      if (photo != null) {
        currentImage = File(photo.path);
        emit(ImagePicked(currentImage!));
      }
      emit(ImagePickedError('no photo taked'));
    } catch (e) {
      emit(ImagePickedError(e.toString()));
    }
  }

  Future<void> pickFile() async {
    emit(FilePicking());
    try {
      final file = await filepickerservices.pickFile();
      if (file != null) {
        currentFile = File(file.path);
        emit(FilePicked(File(file.path)));
      }
      emit(FilePickedError('no file selected'));
    } catch (e) {
      emit(FilePickedError(e.toString()));
    }
  }
}
