import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/utils/colors.dart';
import 'package:social_media_app/features/home/cubit/home_cubit.dart';
import 'package:social_media_app/features/home/models/stories_model.dart';

class StorySection extends StatelessWidget {
  const StorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final homeCubit = BlocProvider.of<HomeCubit>(context);
    return SizedBox(
      height: size.height * .15,
      child: BlocConsumer<HomeCubit, HomeState>(
        bloc: homeCubit,
        listenWhen: (prev, curr) => curr is StoriesError,
        listener: (context, state) {
          if (state is StoriesError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        buildWhen: (prev, curr) =>
            curr is StoriesError ||
            curr is StoriesLoading ||
            curr is StoriesLooded,
        builder: (context, state) {
          if (state is StoriesLoading) {
            return Center(child: CircularProgressIndicator.adaptive());
          } else if (state is StoriesLooded) {
            final stories = state.stories;
            return ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              scrollDirection: Axis.horizontal,
              itemCount: stories.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return StoryItem();
                }
                return StoryItem(story: stories[index - 1]);
              },
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}

class StoryItem extends StatelessWidget {
  final StoriesModel? story;
  const StoryItem({super.key, this.story});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: CircleAvatar(
              radius: 36,
              backgroundColor: story == null ? AppColors.babyBlue : null,
              backgroundImage: story == null
                  ? null
                  : NetworkImage(story!.imgUrl),
              child: story == null
                  ? Icon(Icons.add, size: 30, color: AppColors.white)
                  : null,
            ),
          ),
          if (story == null)
            Text('Share Story', style: Theme.of(context).textTheme.titleMedium)
          else
            Text(
              story!.autherName,
              style: Theme.of(context).textTheme.titleMedium,
            ),
        ],
      ),
    );
  }
}
