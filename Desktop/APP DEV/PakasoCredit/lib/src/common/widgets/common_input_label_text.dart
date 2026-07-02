import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CommonInputLabelText extends StatelessWidget {
  final String labelText;

  const CommonInputLabelText({super.key, required this.labelText});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("$labelText "),
        Text(
          "*", // Asterisk
          style: TextStyle(color: AppColors.error),
        ),
      ],
    );
  }
}
