import 'package:adhiriya_ai_webapp/constansts/const_colors.dart';
import 'package:adhiriya_ai_webapp/global/app_string.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  // final VoidCallback onAddCategories;
  // final VoidCallback onUsers;

  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      color: ConstColors.primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/splash/medical-logo.jpg",
                height: 30,
              ),
              const SizedBox(
                width: 8,
              ),
               Text(
                Appstring.adhiriyaAICAPS,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Image.asset(
                "assets/splash/Ellipse 1.png",
                height: 30,
              )
            ],
          ),
        ],
      ),
    );
  }
}
