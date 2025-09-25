import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_media_app/core/utils/colors.dart';
import 'package:social_media_app/core/widgets/post%20_item_widget.dart'
    show PostItemWidget;
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
