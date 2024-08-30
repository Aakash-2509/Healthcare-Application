import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constansts/const_colors.dart';

class CustomTextFormField extends StatelessWidget {
  // final double width;
  // final double height;
  final String customText;
  final TextEditingController controller;
  final TextInputType? keyoardType;
  final String? Function(String?)? validator;
  final Function(String) onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final bool enabled;
  final bool obsercureText;
  final int minline;
  final int maxline;
  final double? errorsize;
  final Widget iconss;
  const CustomTextFormField({
    super.key,

    // required this.width,

    required this.customText,
    required this.controller,
    required this.validator,
    required this.inputFormatters,
    this.readOnly = false,
      this.enabled = true,
    this.obsercureText = false,
    this.minline = 1,
    this.maxline = 1,
    this.errorsize = 12,
    this.iconss = const SizedBox(),
    required this.onChanged,
    this.keyoardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      obscureText: obsercureText,
      inputFormatters: inputFormatters,
      keyboardType: keyoardType ?? TextInputType.emailAddress,
      readOnly: readOnly,
      enabled: enabled,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 15,color: ConstColors.black),
      cursorColor: ConstColors.darkGrey,
      maxLines: maxline,
      minLines: minline,
      decoration: InputDecoration(
        // errorMaxLines: 2,
        hintText: customText,
        suffixIcon: iconss,
        hintStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFFC5C5C5)),
        errorStyle: TextStyle(fontSize: errorsize, color: ConstColors.red),
        filled: true,
        fillColor: Theme.of(context).colorScheme.onSecondary,
        // contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: .6, color: ConstColors.primaryColor),
        ),
        disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: .6, color: ConstColors.darkGrey),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: .6, color: ConstColors.darkGrey),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: .6),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: .6, color: ConstColors.red),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: .6, color: ConstColors.red),
        ),
      ),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
