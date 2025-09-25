import 'package:flutter/material.dart';
import 'package:social_media_app/core/utils/colors.dart';
import 'package:social_media_app/features/auth/models/user_data.dart';

class ProfileStats extends StatelessWidget {
  final UserData userdata;
  const ProfileStats({super.key, required this.userdata});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.mainindecator),
      ),
      child: Row(
        children: [
          BuildProfileStats(
            label: 'posts',
            value: userdata.postscount.toString(),
          ),
          SizedBox(
            height: 30,
            child: VerticalDivider(color: AppColors.grey, thickness: 0.5),
          ),
          BuildProfileStats(
            label: 'Followers',
            value: userdata.followerscount.toString(),
          ),
          SizedBox(
            height: 30,
            child: VerticalDivider(color: AppColors.grey, thickness: 0.5),
          ),
          BuildProfileStats(
            label: 'Following',
            value: userdata.followingCount.toString(),
          ),
        ],
      ),
    );
  }
}

class BuildProfileStats extends StatelessWidget {
  final String label;
  final String value;

  const BuildProfileStats({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: Theme.of(context).textTheme.titleMedium),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}
