import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/services/core_auth_services.dart';
import 'package:social_media_app/core/services/post_services.dart';
import 'package:social_media_app/features/auth/models/user_data.dart';
import 'package:social_media_app/features/home/models/comment_model.dart';
import 'package:social_media_app/features/home/services/file_picker_services.dart';
import 'package:social_media_app/features/home/services/home_services.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostInitial());
  final homeservices = HomeServices();
  final coreAuthServices = CoreAuthServices();
  final filepickerservices = FilePickerServices();
  final postServices = PostServices();
  File? currentImage;
  File? currentFile;
  Future<void> likePost(String postId) async {
    emit(LikingPost(postId));
    try {
      final currnetUser = await coreAuthServices.getCurrentUserData();
      if (currnetUser == null) {
        emit(PostLikeError('User not authenticated', postId));
        return;
      }
      final newPost = await postServices.likePost(postId, currnetUser.id);
      emit(PostLiked(newPost.likes?.length ?? 0, postId, newPost.isLiked));
    } catch (e) {
      emit(PostLikeError(e.toString(), postId));
    }
  }

  Future<void> fetchLikesPostDetails(String postId) async {
    emit(FetchingLikePost());
    try {
      final post = await postServices.fetchPostById(postId);
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
      await postServices.addComment(
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
      final comments = await postServices.fetchComments(postId);
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

  Future<void> deleteComment(String postId, String commentId) async {
    emit(DeletingComment(commentId));
    try {
      final userData = await coreAuthServices.getCurrentUserData();
      final comment = await homeservices.fetchCommentById(commentId);
      if (comment!.authorId == userData!.id) {
        await homeservices.deleteComment(postId, commentId);
      }

      emit(CommentDeleted(commentId));
    } catch (e) {
      emit(CommentDeleteError(e.toString(), commentId));
    }
  }
}
