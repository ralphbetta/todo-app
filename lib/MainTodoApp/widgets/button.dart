import 'package:flutter/material.dart';
import 'package:todo_app/MainTodoApp/theme_controls.dart';

import '../../constants.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;

  const MyButton({
    Key? key, required this.label, required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        decoration: BoxDecoration(
            borderRadius:  BorderRadius.circular(10),
            color: primaryClr
        ),
        child: Center(
          child: Text(label, style: ContainerStyle()),
        ),
      ),
    );
  }
}
