import 'package:flutter/material.dart';

import '../../constansts/const_colors.dart';
import '../../constansts/text_styles.dart';

class CustomOutlinedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final bool? center;
  final Size? buttonSize;
  final TextStyle? style;
  final double width;
  final double height;
  const CustomOutlinedButton({
    required this.onPressed,
    required this.buttonText,
    required this.buttonSize,
    this.center = true,
    this.style,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return center == true
        ? SizedBox(
            width: width,
            height: height,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: ConstColors.backgroundColor,
                side: const BorderSide(color: ConstColors.primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
              ),
              child: FittedBox(
                child: Text(
                  buttonText,
                  style: getTextTheme().displaySmall,
                ),
              ),
            ),
          )
        : OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              fixedSize: buttonSize,
              side: const BorderSide(color: ConstColors.primaryColor, width: 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: FittedBox(
              child: Text(
                buttonText,
                style: style ?? getTextTheme().displaySmall,
              ),
            ),
          );
  }
}
