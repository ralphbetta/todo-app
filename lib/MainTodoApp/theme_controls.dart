import 'package:flutter/material.dart';

const Color bluishClr = Color(0xFF4e5ae8);
const Color pinkClr = Color(0xFFff4667);
const Color yellowClr= Color(0xFFFFB746);
const Color white = Colors.white;
const primaryClr = bluishClr;
const darkGreyClr = Color(0xFF121212);
Color darkHeaderClr = Color(0xFF424342);



class ThemeClass{

  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);

  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      scaffoldBackgroundColor: white,
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
              color: Colors.black
          )

      )
  );
  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: darkGreyClr,
      brightness: Brightness.dark,
      backgroundColor: darkGreyClr,
      appBarTheme: AppBarTheme(
          backgroundColor: darkGreyClr
      )

  );

}