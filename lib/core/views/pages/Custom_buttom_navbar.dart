import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:social_media_app/features/discover/views/pages/discover_page.dart';
import 'package:social_media_app/features/home/views/pages/home_page.dart';
import 'package:social_media_app/features/profile/views/pages/profile_page.dart';

class CustomButtomNavbar extends StatelessWidget {
  const CustomButtomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: [
        PersistentTabConfig(
          screen: HomePage(),
          item: ItemConfig(icon: Icon(Icons.home), title: "Home"),
        ),
        PersistentTabConfig(
          screen: DiscoverPage(),
          item: ItemConfig(icon: Icon(Icons.group_rounded), title: "Discover"),
        ),
        PersistentTabConfig(
          screen: ProfilePage(),
          item: ItemConfig(icon: Icon(Icons.person), title: "Profile"),
        ),
      ],
      navBarBuilder: (navBarConfig) =>
          Style5BottomNavBar(navBarConfig: navBarConfig),
    );
  }
}
