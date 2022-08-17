import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo_app/MainTodoApp/home.dart';
import 'package:todo_app/MainTodoApp/home2.dart';
//import 'package:todo_app/theme.dart'; //replace this with the mainapp theme
import 'package:todo_app/MainTodoApp/theme_controls.dart';
import 'package:todo_app/todo_app/testapp.dart';
import 'package:todo_app/todo_app/todo_app.dart';
import 'package:todo_app/todo_with_model/home_screen.dart';
import 'package:todo_app/ui/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: ThemeClass.themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              themeMode: currentMode,
              theme: ThemeClass.lightTheme,
              darkTheme: ThemeClass.darkTheme,
              //home: TodoApp(),
              //home: TestStorageApp(),
              //home: HomeScreen()
              home: Home());
        });
  }
}
