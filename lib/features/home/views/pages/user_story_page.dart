import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_media_app/core/utils/colors.dart';
import 'package:social_media_app/features/home/models/stories_model.dart';

class UserStoryPage extends StatelessWidget {
  final StoriesModel story;
  const UserStoryPage({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.babyBlue,
      body: Column(
        children: [
          /// Header
          Padding(
            padding: const EdgeInsets.only(top: 54.0, left: 16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    story.authorimage ?? '',
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      story.autherName,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium!.copyWith(color: AppColors.white),
                    ),
                    Text(
                      DateFormat(
                        'h:mm a',
                      ).format(DateTime.parse(story.createdAt)),
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium!.copyWith(color: AppColors.grey),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.clear, color: AppColors.white, size: 30),
                ),
              ],
            ),
          ),

          /// Body
          Expanded(
            child: story.imgUrl == null
                ? Center(
                    child: Text(
                      story.text ?? '',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium!.copyWith(color: AppColors.white),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (story.text != null && story.text.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            story.text!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(color: AppColors.white),
                          ),
                        ),
                      CachedNetworkImage(imageUrl: story.imgUrl!),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
