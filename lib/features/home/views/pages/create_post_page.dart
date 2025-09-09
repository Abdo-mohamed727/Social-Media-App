
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/utils/colors.dart';
import 'package:social_media_app/features/home/cubit/home_cubit.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _textController = TextEditingController();
  late final HomeCubit homecubit;

  @override
  void initState() {
    homecubit = context.read<HomeCubit>();
    homecubit.fetchInitialUserData();
    super.initState();
    _textController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _textController.removeListener(() {});
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homecubit = context.read<HomeCubit>();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backGround,
        elevation: 0,
        title: Center(child: Text('Create Post')),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close),
        ),
        actions: [
          BlocConsumer<HomeCubit, HomeState>(
            bloc: homecubit,
            listenWhen: (prev, curr) =>
                curr is PostAdded || curr is PostAddError,
            listener: (context, state) {
              if (state is PostAdded) {
                Navigator.of(context).pop();
              } else if (state is PostAddError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('post error')));
              }
            },
            buildWhen: (prev, curr) =>
                curr is PostAddError || curr is PostAdded || curr is PostAdding,
            builder: (context, state) {
              if (state is PostAdding) {
                return Center(child: CircularProgressIndicator.adaptive());
              }
              return TextButton(
                onPressed: () async =>
                    await homecubit.createPost(text: _textController.text),
                child: Text(
                  'post',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: _textController.text.isNotEmpty
                        ? AppColors.babyBlue
                        : AppColors.grey,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24.0, top: 24),
                child: Column(
                  children: [
                    BlocBuilder<HomeCubit, HomeState>(
                      bloc: homecubit,
                      buildWhen: (prev, curr) =>
                          curr is POstcreatingInitialLoading ||
                          curr is PostInitialCreated,
                      builder: (context, state) {
                        if (state is POstcreatingInitialLoading) {
                          return Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        } else if (state is PostInitialCreated) {
                          final userata = state.userData;
                          return Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: userata.imgUrl != null
                                    ? CachedNetworkImageProvider(
                                        userata.imgUrl!,
                                      )
                                    : null,
                                backgroundColor: AppColors.babyBlue,
                                foregroundColor: AppColors.white,
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  userata.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
              TextField(
                controller: _textController,
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: 'What is in your mind..?',
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Column(
                children: [
                  BlocBuilder<HomeCubit, HomeState>(
                    bloc: homecubit,
                    buildWhen: (prev, curr) =>
                        curr is PickingImage ||
                        curr is ImagePicked ||
                        curr is ImagePickedError,
                    builder: (context, state) {
                      if (state is PickingImage) {
                        return Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      } else if (state is ImagePicked) {
                        return Column(
                          children: [
                            Image.file(
                              state.image,
                              height: 350,
                              width: double.infinity,
                              fit: BoxFit.cover,
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
                  BlocBuilder<HomeCubit, HomeState>(
                    bloc: homecubit,
                    buildWhen: (prev, curr) =>
                        curr is FilePicked ||
                        curr is FilePickedError ||
                        curr is FilePicking,
                    builder: (context, state) {
                      if (state is FilePicking) {
                        return Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      } else if (state is FilePickedError) {
                        return ListTile(
                          leading: const Icon(
                            Icons.file_present,
                            color: AppColors.primary,
                          ),
                        );
                      } else if (state is FilePickedError) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.message)));
                      }
                      return SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ],
          ),

          // Divider(color: AppColors.grey, indent: 24, endIndent: 24),
          SizedBox(height: size.height * .3),
          Expanded(
            child: Container(
              height: size.height * .5,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.grey2,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.camera,
                          size: 30,
                          color: AppColors.primary,
                        ),
                        title: Text(
                          'Camera',
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        onTap: () async {
                          await homecubit.takephoto();
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.image,
                          size: 30,
                          color: AppColors.primary,
                        ),
                        title: Text(
                          'Add A Photo',
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        onTap: () async {
                          await homecubit.pickImage();
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.file_copy,
                          size: 30,
                          color: AppColors.primary,
                        ),
                        title: Text(
                          'Add A File',
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        onTap: () async {
                          await homecubit.pickFile();
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.video_collection_outlined,
                          size: 30,
                          color: AppColors.primary,
                        ),
                        title: Text(
                          'Add Video',
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          // Handle add location logic here
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.gif,
                          size: 40,
                          color: AppColors.primary,
                        ),
                        title: Text(
                          'Gif',
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          // Handle add location logic here
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
