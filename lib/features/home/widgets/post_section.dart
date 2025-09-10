import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_media_app/core/utils/colors.dart';
import 'package:social_media_app/features/home/cubit/home_cubit.dart';
import 'package:social_media_app/features/home/models/post_model.dart';
import 'package:social_media_app/features/home/widgets/comment_sheet_section.dart';

class PostSection extends StatelessWidget {
  const PostSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<HomeCubit>(context);
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: cubit,
      buildWhen: (prev, curr) =>
          curr is PostError || curr is PostLoaded || curr is PostLoading,
      builder: (context, state) {
        if (state is PostLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (state is PostLoaded) {
          final Posts = state.post;
          if (Posts.isEmpty) {
            return Text('no posts found');
          }
          return ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 16),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),

            itemCount: Posts.length,
            itemBuilder: (context, index) {
              final post = Posts[index];
              return PostItemWidget(post: post);
            },
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}

class PostItemWidget extends StatelessWidget {
  final PostModel post;
  const PostItemWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final homecubit = BlocProvider.of<HomeCubit>(context);
    return Card(
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: post.authorImageUrl != null
                      ? CachedNetworkImageProvider(post.authorImageUrl!)
                      : null,
                  radius: 20,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName ?? "Unknown",
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        DateFormat(
                          'h:mm a',
                        ).format(DateTime.parse(post.createdAt)),
                        style: Theme.of(context).textTheme.labelMedium!
                            .copyWith(color: AppColors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        post.text ?? "",
                        style: Theme.of(context).textTheme.bodyLarge,
                        softWrap: true,
                      ),
                      SizedBox(height: 16),
                      if (post.image != null)
                        CachedNetworkImage(imageUrl: post.image!),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          BlocBuilder<HomeCubit, HomeState>(
                            bloc: homecubit,
                            buildWhen: (prev, curr) =>
                                (curr is LikingPost &&
                                    curr.postId == post.id) ||
                                (curr is PostLiked && curr.postId == post.id) ||
                                (curr is PostLikeError &&
                                    curr.postId == post.id),
                            builder: (context, state) {
                              if (state is LikingPost) {
                                return Center(
                                  child: CircularProgressIndicator.adaptive(),
                                );
                              }
                              return Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      await homecubit.likePost(post.id);
                                    },
                                    icon: Icon(
                                      (state is PostLiked
                                              ? state.isLiked
                                              : post.isLiked)
                                          ? Icons.thumb_up_alt
                                          : Icons.thumb_up_alt_outlined,
                                      size: 30,
                                      color:
                                          (state is PostLiked
                                              ? state.isLiked
                                              : post.isLiked)
                                          ? AppColors.primary
                                          : AppColors.black,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    state is PostLiked
                                        ? state.likesCount.toString()
                                        : post.likes?.length.toString() ?? '0',
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(width: 16),
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                useRootNavigator: true,
                                isScrollControlled: true,
                                backgroundColor: AppColors.white,

                                builder: (context) => SizedBox(
                                  height: size.height * .9,
                                  width: size.width,

                                  child: SafeArea(
                                    child: BlocProvider.value(
                                      value: HomeCubit(),

                                      child: CommentSheetSection(post: post),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Icon(Icons.comment_bank_outlined, size: 20),
                                SizedBox(width: 4),
                                Text(post.commentsCount.toString() ?? '0'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
