import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/cubit/cubit/post_cubit.dart';
import 'package:social_media_app/core/utils/colors.dart';
import 'package:social_media_app/features/home/cubit/home_cubit.dart';
import 'package:social_media_app/features/home/models/comment_model.dart';
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
  void initState() {
    super.initState();
    _commentController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _commentController.removeListener(() {});
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    final postCubit = context.read<PostCubit>();
    return Column(
      children: [
        TextField(
          controller: _commentController,
          decoration: InputDecoration(
            hintText: " Write a Comment....",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: BorderSide(color: AppColors.grey),
            ),
          ),
        ),
        BlocBuilder<HomeCubit, HomeState>(
          bloc: homeCubit,
          buildWhen: (prev, curr) =>
              curr is PickingImage ||
              curr is ImagePicked ||
              curr is ImagePickedError,
          builder: (context, state) {
            if (state is PickingImage) {
              return Center(child: CircularProgressIndicator.adaptive());
            } else if (state is ImagePicked) {
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    height: 200,
                    width: 200,
                    child: Image.file(state.image, fit: BoxFit.cover),
                  ),
                ],
              );
            } else if (state is ImagePickedError) {
              return Text(
                state.message,
                style: const TextStyle(color: AppColors.red),
              );
            }
            return SizedBox.shrink();
          },
        ),
        const SizedBox(width: 8),
        Row(
          children: [
            IconButton(
              onPressed: () async {
                await homeCubit.pickImage();
              },
              icon: Icon(Icons.image),
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.camera)),
            const Spacer(),

            BlocConsumer<PostCubit, PostState>(
              bloc: postCubit,
              listenWhen: (prev, curr) =>
                  curr is CommentAdded || curr is AddingCommentError,
              listener: (context, state) async {
                if (state is CommentAdded) {
                  _commentController.clear();
                  await postCubit.fetchComments(widget.post.id);
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
                return IconButton(
                  onPressed: () async {
                    await postCubit.addComment(
                      postId: widget.post.id,
                      text: _commentController.text,
                    );
                  },
                  icon: Icon(
                    Icons.send,
                    color: _commentController.text.isNotEmpty
                        ? AppColors.primary
                        : AppColors.grey,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
