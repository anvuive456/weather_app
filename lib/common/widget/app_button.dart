import 'package:flutter/material.dart';
import 'package:weather_app/resources/color.dart';

class AppButton extends StatelessWidget {
  final Widget child;
  final void Function() onTap;
  final Color buttonColor;

  const AppButton({
    super.key,
    required this.child,
    required this.onTap,
    this.buttonColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: ShapeDecoration(
            color: buttonColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        child: child,
      ),
    );
  }
}
