import 'package:flutter/material.dart';

const kBackgroundColor = Colors.black;
const kDarkGrey = Color(0xff1D1D1D);
const kGreen = Color(0xff00985F);

const kPrimaryColor = Color(0xff2f4858);
const kSecondaryColor = Color(0xfff4faff);
const kTertiaryColor = Color(0xff3f8efc);

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;

  static late bool isMobile;
  static late bool isTablet;
  static late bool isLaptop;
  static late bool isDesktop;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

    isMobile = screenWidth < 600;
    isTablet = screenWidth >= 600 && screenWidth < 1024;
    isLaptop = screenWidth >= 1024 && screenWidth < 1440;
    isDesktop = screenWidth >= 1440;
  }
}
