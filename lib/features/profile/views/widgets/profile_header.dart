import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/utils/app_routs.dart';
import 'package:social_media_app/core/utils/colors.dart';
import 'package:social_media_app/core/widgets/main_button.dart';
import 'package:social_media_app/features/auth/models/user_data.dart';
import 'package:social_media_app/features/profile/cubit/profile_cubit/profile_page_cubit.dart';
import 'package:social_media_app/features/profile/models/edit_profile_arg.dart';

class ProfileHeader extends StatelessWidget {
  final UserData userData;
  const ProfileHeader({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final profilecubit = context.read<ProfilePageCubit>();
    return Column(
      children: [
        SizedBox(
          height: size.height * .3 + 40,
          child: Stack(
            children: [
              Container(
                height: size.height * .3,
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      'https://images.pexels.com/photos/268941/pexels-photo-268941.jpeg?cs=srgb&dl=pexels-pixabay-268941.jpg&fm=jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: size.width * .5 - 50,
                right: size.width * .5 - 50,
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary, width: 2),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          userData.imgUrl ?? "",
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Text(
          userData.name,
          style: Theme.of(
            context,
          ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          userData.title ?? 'not provided',
          style: Theme.of(
            context,
          ).textTheme.bodySmall!.copyWith(color: AppColors.grey),
        ),
        SizedBox(height: 8),
        MainButton(
          width: size.width * .4,
          child: Text('Edit Profile'),
          ontap: () {
            Navigator.of(context, rootNavigator: true)
                .pushNamed(
                  AppRouts.editProfileRoute,
                  arguments: EditProfileArg(userData: userData),
                )
                .then((_) async {
                  await profilecubit.fetchUserPosts();
                  await profilecubit.fetchUserProfile();
                });
          },
        ),
      ],
    );
  }
}
