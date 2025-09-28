import 'package:flutter/material.dart';
import 'package:social_media_app/core/utils/colors.dart';

class MainButton extends StatelessWidget {
  final VoidCallback? ontap;
  final Widget? child;
  final double hieght;
  final double width;

  final bool isLooding;
  const MainButton({
    super.key,
    this.isLooding = false,
    this.ontap,
    this.child,
    this.hieght = 50,
    this.width = 200,
  }) : assert(isLooding == false || child == null);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: hieght,
      child: ElevatedButton(
        onPressed: ontap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.grey, width: 2),

            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          elevation: 0,
        ),
        child: isLooding ? const CircularProgressIndicator.adaptive() : child,
      ),
    );
  }
}
