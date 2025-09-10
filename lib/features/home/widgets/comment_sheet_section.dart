import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/home/cubit/home_cubit.dart';
import 'package:social_media_app/features/home/models/post_model.dart';
import 'package:social_media_app/features/home/widgets/comments_section.dart';
import 'package:social_media_app/features/home/widgets/likes_section.dart';
import 'package:social_media_app/features/home/widgets/send_comment_section.dart';

class CommentSheetSection extends StatefulWidget {
  const CommentSheetSection({super.key, required this.post});
  final PostModel post;

  @override
  State<CommentSheetSection> createState() => _CommentSheetSectionState();
}

class _CommentSheetSectionState extends State<CommentSheetSection> {
  late HomeCubit _homeCubit;
  @override
  void initState() {
    _homeCubit = context.read<HomeCubit>();
    _homeCubit.fetchLikesPostDetails(widget.post.id);
    _homeCubit.fetchComments(widget.post.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 10,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Likes'),
                  SizedBox(height: 16),
                  LikesSection(post: widget.post),

                  Text('Comments'),
                  SizedBox(height: 16),
                  CommentsSection(post: widget.post),
                ],
              ),
            ),
          ),

          SendCommentSection(post: widget.post),
        ],
      ),
    );
  }
}
