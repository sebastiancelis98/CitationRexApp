import 'package:CitationRexWebsite/utils/color.dart';
import 'package:flutter/material.dart';

class Themes {
  ThemeData lightTheme() {
    return ThemeData.light().copyWith(
      primaryColor: HexColor.fromHex('B0403D'),

      secondaryHeaderColor: HexColor.fromHex('417E80'),
      
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