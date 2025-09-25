import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/cubit/cubit/post_cubit.dart';
import 'package:social_media_app/core/utils/colors.dart';
import 'package:social_media_app/features/auth/models/user_data.dart';
import 'package:social_media_app/features/home/cubit/home_cubit.dart';
import 'package:social_media_app/features/home/models/comment_model.dart';
import 'package:social_media_app/features/home/models/post_model.dart';

class CommentsSection extends StatelessWidget {
  final PostModel post;

  const CommentsSection({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final postCubit = context.read<PostCubit>();
    return BlocBuilder<PostCubit, PostState>(
      bloc: postCubit,
      buildWhen: (prev, curr) =>
          curr is CommentsFetched ||
          curr is FetchingComments ||
          curr is FetchingCommentsError,
      builder: (context, state) {
        if (state is FetchingComments) {
          return Center(child: CircularProgressIndicator.adaptive());
        } else if (state is FetchingCommentsError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is CommentsFetched) {
          final comments = state.comments;
          if (comments.isEmpty) {
            return Text('no comments added');
          }
          return ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return CommentWidget(comment: comment, postId: post.id);
            },
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}

class CommentWidget extends StatelessWidget {
  final CommentModel comment;
  final String postId;

  const CommentWidget({super.key, required this.comment, required this.postId});

  @override
  Widget build(BuildContext context) {
    final postCubit = context.read<PostCubit>();
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: comment.authorImageUrl != null
                  ? NetworkImage(comment.authorImageUrl!)
                  : null,
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.babyBlue10,
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          comment.authorName ?? '',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      comment.text,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),

                    if (comment.image != null) ...[
                      const SizedBox(height: 8),
                      CachedNetworkImage(imageUrl: comment.image!),
                    ],
                  ],
                ),
              ),
            ),

            IconButton(
              icon: const Icon(Icons.reply),
              onPressed: () {
                // Handle reply action
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 32.0),
          child: Align(
            alignment: Alignment.topRight,
            child: BlocConsumer<PostCubit, PostState>(
              bloc: postCubit,
              listenWhen: (prev, curr) =>
                  curr is CommentDeleted || curr is CommentDeleteError,
              listener: (context, state) async {
                if (state is CommentDeleted) {
                  await postCubit.fetchComments(postId);
                } else if (state is CommentDeleteError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error')));
                }
              },
              buildWhen: (prev, curr) =>
                  (curr is CommentDeleteError &&
                      curr.commentId == comment.id) ||
                  (curr is CommentDeleted && curr.commentId == comment.id) ||
                  (curr is DeletingComment && curr.commentId == comment.id),
              builder: (context, state) {
                if (state is DeletingComment) {
                  return Center(child: CircularProgressIndicator.adaptive());
                }
                return TextButton(
                  onPressed: () async {
                    await postCubit.deleteComment(postId, comment.id);
                  },
                  child: Text(
                    'Delete',
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall!.copyWith(color: AppColors.primary),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
