// view/widgets/custom_dropdown.dart
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constansts/const_colors.dart'; // Adjust path as per your project structure

class CustomDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;
  final List<String> items;
  final double? radius;

  const CustomDropdown({
    required this.value,
    this.radius,
    required this.onChanged,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 343.w, // Adjust width as needed
      height: 70.h, // Adjust height as needed
      decoration: BoxDecoration(
        // color: ConstColors.backgroundColor,
        border: Border.all(color: ConstColors.darkGrey),
        borderRadius: BorderRadius.circular(radius ?? 50),
      ),
      padding:
          EdgeInsets.symmetric(horizontal: 12.w), // Adjust padding as needed
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          onChanged: onChanged,

          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              // backgroundColor: ConstColors.black,

              value: value,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16),
                child: Text(
                  value,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontSize: 15,),
                ),
              ),
            );
          }).toList(),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: ConstColors.black,
            size: 25, // Adjust icon size as needed
          ),
          dropdownColor: Theme.of(context)
              .colorScheme
              .primaryContainer, // Customize dropdown background color
          isExpanded: true,
          borderRadius: BorderRadius.circular(10), // Add border radius here
        ),
      ),
    );
  }
}
