import 'package:flutter/material.dart';
//import 'package:todo_app/theme.dart';
import 'package:todo_app/MainTodoApp/theme_controls.dart';
TextStyle subHeadingStyle(){
  return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: ThemeClass.themeNotifier.value==ThemeMode.dark
          ?Colors.grey[400]
          :Colors.grey

  );
}
TextStyle HeadingStyle(){
  return TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: ThemeClass.themeNotifier.value==ThemeMode.dark
          ?Colors.white
          :Colors.black
  );
}
TextStyle ContainerStyle(){
  return TextStyle(
    color: Colors.white,
    fontSize: 18,
  );
}

TextStyle titleStyle(){
  return TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
}

TextStyle subTitleStyle(){
  return TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: ThemeClass.themeNotifier == ThemeMode.dark
       ?Colors.grey[100]
       :Colors.grey[400]
  );
}

List <Color> colorList = [
  primaryClr,
  pinkClr,
  yellowClr
];
