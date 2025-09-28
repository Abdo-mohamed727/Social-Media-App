import 'package:flutter/material.dart';

import '../../../core/utils/colors.dart';

class SocialMediaButton extends StatelessWidget {
  final String imgurl;
  final String label;
  final VoidCallback? ontap;
  const SocialMediaButton({
    super.key,
    required this.imgurl,
    required this.label,
    this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.mainindecator),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imgurl),
            SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
