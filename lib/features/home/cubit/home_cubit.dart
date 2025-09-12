import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/services/core_auth_services.dart';
import 'package:social_media_app/core/services/supabase_database_services.dart';
import 'package:social_media_app/features/auth/models/user_data.dart';
import 'package:social_media_app/features/home/models/comment_model.dart';
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
        final postComments = await homeservices.fetchComments(post.id);
        post = post.copyWith(commentsCount: postComments.length);
        if (userData != null) {
          post = post.copyWith(
            authorName: userData.name,
            isLiked: post.likes?.contains(userData.id) ?? false,
          );
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

  Future<void> likePost(String postId) async {
    emit(LikingPost(postId));
    try {
      final currnetUser = await coreAuthServices.getCurrentUserData();
      if (currnetUser == null) {
        emit(PostLikeError('User not authenticated', postId));
        return;
      }
      final newPost = await homeservices.likePost(postId, currnetUser.id);
      emit(PostLiked(newPost.likes?.length ?? 0, postId, newPost.isLiked));
    } catch (e) {
      emit(PostLikeError(e.toString(), postId));
    }
  }

  Future<void> fetchLikesPostDetails(String postId) async {
    emit(FetchingLikePost());
    try {
      final post = await homeservices.fetchPostById(postId);
      if (post == null) {
        emit(LikespostFetchingError('no post found'));
        return;
      }
      final Likes = <UserData>[];
      for (var likeId in post.likes ?? []) {
        final userData = await coreAuthServices.getUserData(likeId);
        if (userData != null) {
          Likes.add(userData);
        }
      }
      emit(LikesPostFetched(Likes));
    } catch (e) {
      emit(LikespostFetchingError(e.toString()));
    }
  }

  Future<void> addComment({
    required String postId,
    required String text,
    File? image,
  }) async {
    emit(AddingComment());
    try {
      final currentuser = await coreAuthServices.getCurrentUserData();
      if (currentuser == null) {
        emit(AddingCommentError('no comment added'));
        return;
      }
      await homeservices.addComment(
        postID: postId,
        autherId: currentuser.id,
        text: text,
        image: currentImage,
      );
      emit(CommentAdded());
    } catch (e) {
      emit(AddingCommentError(e.toString()));
    }
  }

  Future<void> fetchComments(String postId) async {
    emit(FetchingComments());
    try {
      final comments = await homeservices.fetchComments(postId);
      List<CommentModel> commentList = [];
      for (var comment in comments) {
        final userData = await coreAuthServices.getUserData(comment.authorId);

        if (userData != null) {
          comment = comment.copyWith(
            authorImageUrl: userData.imgUrl,
            authorName: userData.name,
          );
        }
        commentList.add(comment);
      }
      emit(CommentsFetched(commentList));
    } catch (e) {
      FetchingCommentsError(e.toString());
    }
  }

  Future<void> refrechComments(CommentModel comment) async {
    await fetchComments(comment.id);
  }

  Future<void> deleteComment(String postId, String commentId) async {
    emit(DeletingComment(commentId));
    try {
      // final userData= await coreAuthServices.getUserData(user.id);
      // final comment= await homeservices.fetchCommentById(commentId);
      // if(comment!.authorId == userData){

      // }

      await homeservices.deleteComment(postId, commentId);

      emit(CommentDeleted(commentId));
    } catch (e) {
      emit(CommentDeleteError(e.toString(), commentId));
    }
  }
}
