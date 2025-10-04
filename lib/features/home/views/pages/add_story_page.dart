import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/utils/colors.dart';
import 'package:social_media_app/core/widgets/main_button.dart';
import 'package:social_media_app/features/home/cubit/home_cubit.dart';

class AddStoryPage extends StatefulWidget {
  const AddStoryPage({super.key});

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.babyBlue,
      body: BlocProvider(
        create: (context) => HomeCubit(),
        child: AddStoryBody(),
      ),
    );
  }
}

class AddStoryBody extends StatefulWidget {
  const AddStoryBody({super.key});

  @override
  State<AddStoryBody> createState() => _AddStoryBodyState();
}

class _AddStoryBodyState extends State<AddStoryBody> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.clear, color: AppColors.white),
              ),
              Spacer(),
              IconButton(
                onPressed: () async {},
                icon: Icon(Icons.camera, color: AppColors.white),
              ),
              IconButton(
                onPressed: () async {
                  await homeCubit.pickImage();
                },
                icon: Icon(Icons.image, color: AppColors.white),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * .25),
            child: TextField(
              controller: _textController,
              maxLines: 8,
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(color: AppColors.white),
              decoration: InputDecoration(
                hintText: 'Write Your Thought with others',
                hintStyle: Theme.of(
                  context,
                ).textTheme.titleLarge!.copyWith(color: AppColors.white),
                border: OutlineInputBorder(borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
          Column(
            children: [
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
                bloc: homeCubit,
                buildWhen: (prev, curr) =>
                    curr is FilePicked ||
                    curr is FilePickedError ||
                    curr is FilePicking,
                builder: (context, state) {
                  if (state is FilePicking) {
                    return Center(child: CircularProgressIndicator.adaptive());
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
          BlocConsumer<HomeCubit, HomeState>(
            bloc: homeCubit,
            listenWhen: (previous, current) =>
                current is AddingStoryFailed || current is StoryAdded,
            listener: (context, state) {
              if (state is StoryAdded) {
                Navigator.pop(context);
              } else if (state is AddingStoryFailed) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            buildWhen: (previous, current) =>
                current is AddingStory ||
                current is AddingStoryFailed ||
                current is StoryAdded,
            builder: (context, state) {
              if (state is AddingStory) {
                return Center(child: CircularProgressIndicator.adaptive());
              }
              return MainButton(
                child: Text('Share Story'),
                transparent: true,
                ontap: () async {
                  await homeCubit.addStory(_textController.text);
                },
                width: 200,
              );
            },
          ),
        ],
      ),
    );
  }
}
