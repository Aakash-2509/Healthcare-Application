import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constansts/const_colors.dart';
import '../../constansts/text_styles.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton(
      {super.key,
      required this.press,
      required this.text,
      this.width,
      this.style,
      this.color,
      this.height = 50,
      this.radius = 50});
  final VoidCallback? press;
  final Widget text;
  final color;
  final width;
  final TextStyle? style;
  final double height;
  final double radius;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width ?? 360.w,
      child: ElevatedButton(
          onPressed: press,
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? ConstColors.primaryColor,
            //side: const BorderSide(color: ConstColors.purple),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5.h, vertical: 0),
          ),
          child: text),
    );
  }
}
