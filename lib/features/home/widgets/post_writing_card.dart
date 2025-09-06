import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/utils/app_routs.dart';
import 'package:social_media_app/core/utils/colors.dart';
import 'package:social_media_app/features/home/cubit/home_cubit.dart';

class PostWritingCard extends StatelessWidget {
  const PostWritingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final homecubit = context.read<HomeCubit>();
    navigatorPost() => Navigator.of(context)
        .pushNamed(AppRouts.postroute, arguments: homecubit)
        .then((value) async => await homecubit.refrech());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.babyBlue10,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(),
                  SizedBox(width: 32),
                  InkWell(
                    onTap: navigatorPost,

                    child: Text(
                      'What is in Your Mind?',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge!.copyWith(color: AppColors.grey),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: navigatorPost,
                    child: Row(
                      children: [
                        Icon(Icons.photo, color: AppColors.babyBlue),
                        SizedBox(width: 8),
                        Text(
                          'Photo',
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(color: AppColors.babyBlue),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: VerticalDivider(
                      thickness: 2,
                      width: 20,
                      color: AppColors.grey,
                    ),
                  ),
                  InkWell(
                    onTap: navigatorPost,
                    child: Row(
                      children: [
                        Icon(Icons.video_call, color: AppColors.babyBlue),
                        SizedBox(width: 8),

                        Text(
                          'Video',
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(color: AppColors.babyBlue),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
