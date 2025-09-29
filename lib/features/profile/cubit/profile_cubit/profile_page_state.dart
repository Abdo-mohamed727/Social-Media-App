part of 'profile_page_cubit.dart';

sealed class ProfilePageState {}

final class PrivateProfilePageInitial extends ProfilePageState {}

final class ProfileLooding extends ProfilePageState {}

final class PrfileLooded extends ProfilePageState {
  final UserData user;
  PrfileLooded(this.user);
}

final class ProfileError extends ProfilePageState {
  final String message;
  ProfileError(this.message);
}

final class FetchingUserPosts extends ProfilePageState {}

final class FetchedUserPosts extends ProfilePageState {
  final List<PostModel> userPosts;
  FetchedUserPosts(this.userPosts);
}

final class FetchUserPostsError extends ProfilePageState {
  final String message;
  FetchUserPostsError(this.message);
}
