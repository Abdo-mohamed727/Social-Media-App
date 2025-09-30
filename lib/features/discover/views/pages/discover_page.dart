import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/widgets/main_button.dart';
import 'package:social_media_app/features/discover/cubit/cubit/discover_cubit.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DiscoverCubit()..fetchUsers(),
      child: DiscoverBody(),
    );
  }
}

class DiscoverBody extends StatelessWidget {
  const DiscoverBody({super.key});

  @override
  Widget build(BuildContext context) {
    final discoverCubit = context.read<DiscoverCubit>();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Discover People',
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<DiscoverCubit, DiscoverState>(
                bloc: discoverCubit,
                buildWhen: (prev, curr) =>
                    curr is FetchUsersFailed ||
                    curr is FetchingUsers ||
                    curr is UsersFetched,
                builder: (context, state) {
                  if (state is FetchingUsers) {
                    return Center(child: CircularProgressIndicator.adaptive());
                  } else if (state is UsersFetched) {
                    final users = state.user;
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                user.imgUrl ??
                                    'https://static.vecteezy.com/system/resources/thumbnails/003/337/584/small/default-avatar-photo-placeholder-profile-icon-vector.jpg',
                              ),
                            ),
                            title: Text(
                              user.name,
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('${user.followerscount} Followers'),
                            trailing: MainButton(
                              ontap: () {},
                              child: Text('Follow'),
                              width: 100,
                              hieght: 50,
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is FetchUsersFailed) {
                    return Text(state.message);
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
