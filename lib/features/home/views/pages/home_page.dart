import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/home/cubit/home_cubit.dart';
import 'package:social_media_app/features/home/widgets/post_section.dart';
import 'package:social_media_app/features/home/widgets/post_writing_card.dart';
import 'package:social_media_app/features/home/widgets/story_section.dart';

import '../../widgets/home_page_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final homecubit = HomeCubit();
        homecubit.fetchSories();
        homecubit.fetchposts();
        return homecubit;
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 16),
                HomePageHeader(),
                SizedBox(height: 32),
                PostWritingCard(),
                SizedBox(height: 32),
                StorySection(),

                PostSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
