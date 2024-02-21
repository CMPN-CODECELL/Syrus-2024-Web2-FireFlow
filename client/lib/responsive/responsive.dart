import 'package:flutter/material.dart';

bool responsiveVisibility({
  required BuildContext context,
}) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;

  // Check if it's a phone, tablet portrait, or tablet landscape based on the screen width and height
  if (screenWidth < 600) {
    return false; // Hide the widget on phones
  } else if (screenWidth >= 600 && screenWidth < 960) {
    return false; // Hide the widget on tablets (portrait)
  } else if (screenWidth >= 960 && screenHeight >= 600) {
    return true; // Show the widget on tablets (landscape)
  } else {
    return true; // Show the widget for other screen sizes
  }
}
