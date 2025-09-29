import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/utils/colors.dart';
import 'package:social_media_app/core/widgets/main_button.dart';
import 'package:social_media_app/features/auth/models/user_data.dart';
import 'package:social_media_app/features/profile/cubit/edit_profile_cubit/cubit/edit_profile_cubit.dart';

class EditProfilePage extends StatelessWidget {
  final UserData userData;
  const EditProfilePage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, title: Center(child: Text('Edit Profile'))),

      body: BlocProvider(
        create: (context) => EditProfileCubit(),
        child: EditProfileBody(userData: userData),
      ),
    );
  }
}

class EditProfileBody extends StatefulWidget {
  final UserData userData;
  const EditProfileBody({super.key, required this.userData});

  @override
  State<EditProfileBody> createState() => _EditProfileBodyState();
}

class _EditProfileBodyState extends State<EditProfileBody> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  @override
  void initState() {
    _nameController.text = widget.userData.name;
    _titleController.text = widget.userData.title ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editProfileCubit = context.read<EditProfileCubit>();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: CachedNetworkImageProvider(
                            widget.userData.imgUrl ??
                                'https://static.vecteezy.com/system/resources/thumbnails/003/337/584/small/default-avatar-photo-placeholder-profile-icon-vector.jpg',
                          ),
                        ),
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.black54,
                          child: Icon(Icons.edit, color: AppColors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(hintText: 'Name'),
                  ),
                  SizedBox(height: 24),

                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(hintText: 'Title'),
                  ),
                ],
              ),
            ),
            BlocConsumer<EditProfileCubit, EditProfileState>(
              bloc: editProfileCubit,
              listenWhen: (previous, current) =>
                  current is EditProfileFailed || current is EditProfileSuccess,
              listener: (context, state) {
                if (state is EditProfileSuccess) {
                  Navigator.of(context).pop();
                } else if (state is EditProfileFailed) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              buildWhen: (previous, current) =>
                  current is EditProfileFailed ||
                  current is EditProfileLoading ||
                  current is EditProfileSuccess,
              builder: (context, state) {
                if (state is EditProfileLoading) {
                  return MainButton(isLooding: true);
                }
                return MainButton(
                  child: Text('Save Change'),
                  ontap: () async {
                    await editProfileCubit.editProfilePage(
                      _nameController.text,
                      _titleController.text,
                      widget.userData.imgUrl,
                    );
                  },
                  width: double.infinity,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
