import 'package:flutter/material.dart';
import 'package:social_media_app/core/utils/app_assets.dart';
import 'package:social_media_app/core/utils/colors.dart';
import 'package:social_media_app/features/auth/widgets/login_view.dart';
import 'package:social_media_app/features/auth/widgets/signup_view.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Tab> tabs = [
      const Tab(text: 'Log in'),
      const Tab(text: 'Sign Up'),
    ];

    final List<Widget> tabViews = [LoginView(), SignupView()];

    return DefaultTabController(
      length: tabs.length,
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 56.0,
                  vertical: 46,
                ),
                child: Column(
                  children: [
                    Image.asset(AppAssets.logo),
                    SizedBox(height: 32),
                    TabBar(
                      tabs: tabs,
                      isScrollable: true,
                      controller: DefaultTabController.of(context),
                      tabAlignment: TabAlignment.start,
                      indicatorColor: AppColors.selectedIndecator,
                      labelColor: AppColors.black,
                      labelStyle: Theme.of(context).textTheme.titleLarge!
                          .copyWith(fontWeight: FontWeight.w500),
                      dividerColor: AppColors.mainindecator,
                    ),
                    SizedBox(height: 46),
                    Expanded(
                      child: TabBarView(
                        controller: DefaultTabController.of(context),
                        children: tabViews,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
