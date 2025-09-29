import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/utils/app_routs.dart';
import 'package:social_media_app/core/views/pages/Custom_buttom_navbar.dart';
import 'package:social_media_app/core/views/pages/no_pages.dart';
import 'package:social_media_app/features/auth/models/user_data.dart';
import 'package:social_media_app/features/home/cubit/home_cubit.dart';
import 'package:social_media_app/features/home/views/pages/create_post_page.dart';
import 'package:social_media_app/features/profile/models/edit_profile_arg.dart';
import 'package:social_media_app/features/profile/views/pages/edit_profile_page.dart';

import '../../features/auth/views/pages/auth_page.dart';

class AppRouter {
  static Route<dynamic> OngenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouts.authroute:
        return CupertinoPageRoute(
          builder: (_) => AuthPage(),
          settings: settings,
        );
      case AppRouts.homeroute:
        return CupertinoPageRoute(
          builder: (_) => CustomButtomNavbar(),
          settings: settings,
        );
      case AppRouts.editProfileRoute:
        final args = settings.arguments as EditProfileArg;
        return CupertinoPageRoute(
          builder: (_) => EditProfilePage(userData: args.userData),
          settings: settings,
        );
      case AppRouts.postroute:
        final homecubit = settings.arguments as HomeCubit;
        return CupertinoPageRoute(
          builder: (_) =>
              BlocProvider.value(value: homecubit, child: CreatePostPage()),
          settings: settings,
        );

      default:
        return CupertinoPageRoute(
          builder: (_) => NoPages(),
          settings: settings,
        );
    }
  }
}
