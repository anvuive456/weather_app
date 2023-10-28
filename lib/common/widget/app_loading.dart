import 'package:flutter/material.dart';
import 'package:weather_app/resources/color.dart';

class CircleLoadingWidget extends StatelessWidget {
  final Color valueColor;
  final double? value;
  final String message;

  const CircleLoadingWidget(
      {Key? key,
        this.message = '',
        this.valueColor = AppColors.primary,
        this.value})
      : super(key: key);

  static Widget centered({String? message}) {
    return Center(
        child: CircleLoadingWidget(
          message: message ?? '',
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox.square(
          dimension: 20,
          child: CircularProgressIndicator(
            value: value,
            backgroundColor: AppColors.white,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            strokeWidth: 3,
          ),
        ),
        Text(
          message,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.darkGrey),
        )
      ],
    );
  }
}
