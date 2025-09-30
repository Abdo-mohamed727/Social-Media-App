part of 'discover_cubit.dart';

sealed class DiscoverState {}

final class DiscoverInitial extends DiscoverState {}

final class FetchingUsers extends DiscoverState {}

final class UsersFetched extends DiscoverState {
  final List<UserData> user;
  UsersFetched(this.user);
}

final class FetchUsersFailed extends DiscoverState {
  final String message;
  FetchUsersFailed(this.message);
}
