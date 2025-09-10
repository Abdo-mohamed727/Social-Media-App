import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/utils/colors.dart';
import 'package:social_media_app/features/home/cubit/home_cubit.dart';
import 'package:social_media_app/features/home/models/comment_model.dart';
import 'package:social_media_app/features/home/models/post_model.dart';

class CommentsSection extends StatelessWidget {
  final PostModel post;
  const CommentsSection({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: homeCubit,
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
    return Row(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: CircleAvatar(
            backgroundImage: comment.authorImageUrl != null
                ? NetworkImage(comment.authorImageUrl!)
                : null,
          ),
        ),
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.babyBlue10,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.authorName ?? '',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    comment.text,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
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
    );
  }
}
