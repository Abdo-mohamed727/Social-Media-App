import 'package:flutter/material.dart';
import 'package:social_media_app/core/utils/colors.dart';

class MainButton extends StatelessWidget {
  final VoidCallback? ontap;
  final Widget? child;
  final double hieght;
  final double width;
  final bool transparent;

  final bool isLooding;
  const MainButton({
    super.key,
    this.isLooding = false,
    this.ontap,
    this.child,
    this.hieght = 50,
    this.width = 50,
    this.transparent = false,
  }) : assert(isLooding == false || child == null);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: hieght,
      child: ElevatedButton(
        onPressed: ontap,
        style: ElevatedButton.styleFrom(
          backgroundColor: transparent ? AppColors.white : AppColors.primary,
          foregroundColor: transparent ? AppColors.black : AppColors.white,
          shape: RoundedRectangleBorder(
            side: transparent
                ? BorderSide(color: AppColors.grey, width: 2)
                : BorderSide.none,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          elevation: 0,
        ),
        child: isLooding ? const CircularProgressIndicator.adaptive() : child,
      ),
    );
  }
}
