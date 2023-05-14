import 'package:flutter/material.dart';

String uri = 'https://piggery-management-nodejs-ts-backend.onrender.com';

class GlobalVariables {
  // COLORS
  static const appBarGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 29, 201, 192),
      Color.fromARGB(255, 197, 221, 125),
    ],
    stops: [0.5, 1.0],
  );

  static const secondaryColor = Color.fromRGBO(255, 153, 0, 1);
  static const backgroundColor = Color.fromRGBO(241, 236, 136, 1);
  static const Color greyBackgroundCOlor = Color(0xffebecee);
  static var selectedNavBarColor = Colors.cyan[800]!;
  static const unselectedNavBarColor = Colors.black87;

  static Color? linkTextColor = Colors.cyan[800];

  static const btnBackgroundColor = Color.fromRGBO(223, 157, 66, 1);
}
