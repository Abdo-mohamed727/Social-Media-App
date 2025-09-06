import 'package:flutter/material.dart';
import 'package:social_media_app/core/utils/colors.dart';

class MainButton extends StatelessWidget {
  final VoidCallback? ontap;
  final Widget? child;
  final double hieght;
  final bool isLooding;
  const MainButton({
    super.key,
    this.isLooding = false,
    this.ontap,
    this.child,
    this.hieght = 50,
  }) : assert(isLooding == false || child == null);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: hieght,
      child: ElevatedButton(
        onPressed: ontap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
        ),
        child: isLooding ? const CircularProgressIndicator.adaptive() : child,
      ),
    );
  }
}
