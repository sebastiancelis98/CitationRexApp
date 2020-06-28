import 'package:CitationRexWebsite/utils/color.dart';
import 'package:flutter/material.dart';

class Themes {
  
  static final Color primaryColor = HexColor.fromHex('D46A6A');
  static final Color secondaryColor = HexColor.fromHex('417C81');
  static final Color tertiaryColor = HexColor.fromHex('A2C562');

  ThemeData lightTheme() {
    return ThemeData.light().copyWith(
      primaryColor: primaryColor,
      secondaryHeaderColor: secondaryColor,
      buttonColor: HexColor.fromHex('4A6B8A'),
    );
  }

  ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
      primaryColor: Colors.white,
      indicatorColor: Colors.white,
      brightness: Brightness.dark,
    );
  }
}
