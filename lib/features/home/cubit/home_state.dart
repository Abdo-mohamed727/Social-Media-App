part of 'home_cubit.dart';

sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class StoriesLoading extends HomeState {}

final class StoriesLooded extends HomeState {
  final List<StoriesModel> stories;
  StoriesLooded(this.stories);
}

final class StoriesError extends HomeState {
  final String message;
  StoriesError(this.message);
}

final class PostLoading extends HomeState {}

final class PostLoaded extends HomeState {
  final List<PostModel> post;
  PostLoaded(this.post);
}

final class PostError extends HomeState {
  final String message;
  PostError(this.message);
}

final class PostAdding extends HomeState {}

final class PostAdded extends HomeState {
  final PostRequestBody post;
  PostAdded(this.post);
}

final class PostAddError extends HomeState {
  final String message;
  PostAddError(this.message);
}

final class POstcreatingInitialLoading extends HomeState {}

final class PostInitialCreated extends HomeState {
  final UserData userData;
  PostInitialCreated(this.userData);
}

final class PickingImage extends HomeState {}

final class ImagePicked extends HomeState {
  final File image;
  ImagePicked(this.image);
}

final class ImagePickedError extends HomeState {
  final String message;
  ImagePickedError(this.message);
}

final class FilePicking extends HomeState {}

final class FilePicked extends HomeState {
  final File file;

  FilePicked(this.file);
}

final class FilePickedError extends HomeState {
  final String message;

  FilePickedError(this.message);
}

final class LikingPost extends HomeState {
  final String postId;
  LikingPost(this.postId);
}

final class PostLiked extends HomeState {
  final int likesCount;
  final String postId;
  final bool isLiked;
  PostLiked(this.likesCount, this.postId, this.isLiked);
}

final class PostLikeError extends HomeState {
  final String message;
  final String postId;
  PostLikeError(this.message, this.postId);
}

final class FetchingLikePost extends HomeState {}

final class LikesPostFetched extends HomeState {
  final List<UserData> Likes;
  LikesPostFetched(this.Likes);
}

final class LikespostFetchingError extends HomeState {
  final String message;
  LikespostFetchingError(this.message);
}

final class AddingComment extends HomeState {}

final class CommentAdded extends HomeState {
  // final CommentModel comment;
  // CommentAdded(this.comment);
}

final class AddingCommentError extends HomeState {
  final String message;
  AddingCommentError(this.message);
}

final class FetchingComments extends HomeState {}

final class CommentsFetched extends HomeState {
  final List<CommentModel> comments;
  CommentsFetched(this.comments);
}

final class FetchingCommentsError extends HomeState {
  final String message;
  FetchingCommentsError(this.message);
}

final class DeletingComment extends HomeState {
  final String commentId;
  DeletingComment(this.commentId);
}

final class CommentDeleted extends HomeState {
  // final List<CommentModel> comment;
  final String commentId;
  CommentDeleted(this.commentId);
}

final class CommentDeleteError extends HomeState {
  final String message;
  final String commentId;
  CommentDeleteError(this.message, this.commentId);
}
