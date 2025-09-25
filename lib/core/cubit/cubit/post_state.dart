part of 'post_cubit.dart';

sealed class PostState {}

final class PostInitial extends PostState {}

final class LikingPost extends PostState {
  final String postId;
  LikingPost(this.postId);
}

final class PostLiked extends PostState {
  final int likesCount;
  final String postId;
  final bool isLiked;
  PostLiked(this.likesCount, this.postId, this.isLiked);
}

final class PostLikeError extends PostState {
  final String message;
  final String postId;
  PostLikeError(this.message, this.postId);
}

final class FetchingLikePost extends PostState {}

final class LikesPostFetched extends PostState {
  final List<UserData> Likes;
  LikesPostFetched(this.Likes);
}

final class LikespostFetchingError extends PostState {
  final String message;
  LikespostFetchingError(this.message);
}

final class AddingComment extends PostState {}

final class CommentAdded extends PostState {
  // final CommentModel comment;
  // CommentAdded(this.comment);
}

final class AddingCommentError extends PostState {
  final String message;
  AddingCommentError(this.message);
}

final class FetchingComments extends PostState {}

final class CommentsFetched extends PostState {
  final List<CommentModel> comments;
  CommentsFetched(this.comments);
}

final class FetchingCommentsError extends PostState {
  final String message;
  FetchingCommentsError(this.message);
}

final class DeletingComment extends PostState {
  final String commentId;
  DeletingComment(this.commentId);
}

final class CommentDeleted extends PostState {
  // final List<CommentModel> comment;
  final String commentId;
  CommentDeleted(this.commentId);
}

final class CommentDeleteError extends PostState {
  final String message;
  final String commentId;
  CommentDeleteError(this.message, this.commentId);
}
