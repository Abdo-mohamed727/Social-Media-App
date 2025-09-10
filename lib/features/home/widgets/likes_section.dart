import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/home/cubit/home_cubit.dart';
import 'package:social_media_app/features/home/models/post_model.dart';

class LikesSection extends StatelessWidget {
  const LikesSection({super.key, required this.post});
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    final homecubit = context.read<HomeCubit>();
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: homecubit,
      buildWhen: (prev, curr) =>
          curr is FetchingLikePost ||
          curr is LikesPostFetched ||
          curr is LikespostFetchingError,
      builder: (context, state) {
        if (state is FetchingLikePost) {
          return Center(child: CircularProgressIndicator.adaptive());
        } else if (state is LikesPostFetched) {
          final likes = state.Likes;
          if (likes.isEmpty) {
            return Center(child: Text('no likes'));
          }
          return Row(
            children: likes
                .map(
                  (userData) => CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      userData.imgUrl ?? '',
                    ),
                    onBackgroundImageError: (_, __) => const Icon(Icons.error),
                    radius: 20,
                  ),
                )
                .toList(),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
