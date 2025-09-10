import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/utils/colors.dart';
import 'package:social_media_app/features/home/cubit/home_cubit.dart';
import 'package:social_media_app/features/home/models/post_model.dart';

class SendCommentSection extends StatefulWidget {
  final PostModel post;
  const SendCommentSection({super.key, required this.post});

  @override
  State<SendCommentSection> createState() => _SendCommentSectionState();
}

class _SendCommentSectionState extends State<SendCommentSection> {
  final _commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _commentController,
            decoration: InputDecoration(
              hintText: " Write Your Comment....",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: BorderSide(color: AppColors.grey),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        BlocConsumer<HomeCubit, HomeState>(
          bloc: homeCubit,
          listenWhen: (prev, curr) =>
              curr is CommentAdded || curr is AddingCommentError,
          listener: (context, state) async {
            if (state is CommentAdded) {
              _commentController.clear();
              await homeCubit.fetchComments(widget.post.id);
              await homeCubit.fetchposts();
            } else if (state is AddingCommentError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error adding comment: ${state.message}'),
                ),
              );
            }
          },
          buildWhen: (previous, current) =>
              current is CommentAdded ||
              current is AddingComment ||
              current is AddingCommentError,
          builder: (context, state) {
            if (state is AddingComment) {
              return Center(child: CircularProgressIndicator.adaptive());
            }
            return ElevatedButton(
              onPressed: () async {
                await homeCubit.addComment(
                  postId: widget.post.id,
                  text: _commentController.text,
                );
              },
              child: Text(
                'Send',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(color: AppColors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.babyBlue,
                foregroundColor: AppColors.white,
              ),
            );
          },
        ),
      ],
    );
  }
}
