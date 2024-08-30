import 'package:adhiriya_ai_webapp/constansts/text_styles.dart';
import 'package:flutter/material.dart';

Widget buildInfoCard(
    String title, int count, IconData icon, Color color, Color? styleColor) {
  return Container(
    height: 150,
    width: 300,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: color,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          spreadRadius: 0,
          blurRadius: 15,
          offset: const Offset(5, 5),
        ),
      ],
    ),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: getTextTheme().headlineLarge!.copyWith(
                        fontSize: 20,
                        color: styleColor,
                      ),
                ),
                Icon(
                  icon,
                  size: 26,
                  color: styleColor,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                "$count",
                style: getTextTheme().headlineLarge!.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: styleColor,
                    ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
