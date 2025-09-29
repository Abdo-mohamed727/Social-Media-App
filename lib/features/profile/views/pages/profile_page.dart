import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/profile/cubit/profile_cubit/profile_page_cubit.dart';
import 'package:social_media_app/features/profile/views/widgets/profile_details_and_posts.dart';
import 'package:social_media_app/features/profile/views/widgets/profile_header.dart';
import 'package:social_media_app/features/profile/views/widgets/profile_stats.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = ProfilePageCubit();
        cubit.fetchUserProfile();
        cubit.fetchUserPosts();

        return cubit;
      },
      child: Builder(
        builder: (context) {
          final profileCubit = context.read<ProfilePageCubit>();
          return BlocBuilder<ProfilePageCubit, ProfilePageState>(
            bloc: profileCubit,
            buildWhen: (prev, curr) =>
                curr is PrfileLooded ||
                curr is ProfileError ||
                curr is ProfileLooding,

            builder: (context, state) {
              if (state is ProfileLooding) {
                return Center(child: CircularProgressIndicator.adaptive());
              } else if (state is PrfileLooded) {
                final userData = state.user;
                return DefaultTabController(
                  length: 2,
                  child: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            ProfileHeader(userData: userData),
                            SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 16,
                              ),
                              child: ProfileStats(userdata: userData),
                            ),
                          ],
                        ),
                      ),
                      SliverPersistentHeader(
                        delegate: _TabBarDelegate(
                          TabBar(
                            tabs: [
                              Tab(text: 'Details'),
                              Tab(text: 'Posts'),
                            ],
                          ),
                        ),
                      ),
                    ],
                    body: TabBarView(
                      children: [
                        ProfileDetails(userData: userData),
                        ProfilePosts(userData: userData),
                      ],
                    ),
                  ),
                );
              } else if (state is ProfileError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              return SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _TabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) {
    return false;
  }
}
