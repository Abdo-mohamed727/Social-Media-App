import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/widgets/post%20_item_widget.dart';
import 'package:social_media_app/features/auth/models/user_data.dart';
import 'package:social_media_app/features/profile/cubit/profile_cubit/profile_page_cubit.dart';

class ProfileDetails extends StatelessWidget {
  final UserData userData;
  const ProfileDetails({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Card(child: Center(child: Text("Details will appear here")));
  }
}

class ProfilePosts extends StatelessWidget {
  final UserData userData;
  const ProfilePosts({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    final profileCubit = context.read<ProfilePageCubit>();
    return BlocBuilder<ProfilePageCubit, ProfilePageState>(
      bloc: profileCubit,
      buildWhen: (prev, curr) =>
          curr is FetchedUserPosts ||
          curr is FetchUserPostsError ||
          curr is FetchingUserPosts,
      builder: (context, state) {
        if (state is FetchingUserPosts) {
          return Center(child: CircularProgressIndicator.adaptive());
        }
        if (state is FetchedUserPosts) {
          final posts = state.userPosts;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];

              return PostItemWidget(post: post);
            },
          );
        } else if (state is FetchUserPostsError) {
          return Text(state.message);
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
