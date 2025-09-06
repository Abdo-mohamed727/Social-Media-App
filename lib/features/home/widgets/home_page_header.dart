import 'package:flutter/material.dart';
import 'package:social_media_app/core/utils/app_assets.dart';

class HomePageHeader extends StatelessWidget {
  const HomePageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(AppAssets.logo, height: 50, width: size.width * .6),
        Row(
          children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.search, size: 30)),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications, size: 30),
            ),
          ],
        ),
      ],
    );
  }
}
