import 'package:flutter/material.dart';
import 'package:survey/gen/colors.gen.dart';
import 'package:survey/gen/fonts.gen.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get defaultTheme => ThemeData(
        fontFamily: FontFamily.neuzeit,
        textTheme: const TextTheme(
          bodyText1: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
          bodyText2: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          subtitle1: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
          headline6: TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.w800,
          ),
          headline5: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
          button: TextStyle(
            color: ColorName.chineseBlack,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
      );
}
