import 'package:flutter/material.dart';
import 'package:todo_app/MainTodoApp/theme_controls.dart';

import '../../constants.dart';

class textInput extends StatefulWidget {
  final String hint;
  final String title;
  final TextEditingController? controller;
  final Widget? widget;

  const textInput({
    Key? key, required this.hint,
    required this.title, this.controller, this.widget,
  }) : super(key: key);

  @override
  State<textInput> createState() => _textInputState();
}

class _textInputState extends State<textInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title,
            style: titleStyle(),),
          Container(
            height: 52,
            margin: EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey,
                    width: 0
                ),
                borderRadius: BorderRadius.circular(12)
            ),
            child: Row(
              children: [
                SizedBox(width: 8,),
                Expanded(
                    child: TextFormField(
                      autofocus: false,
                      readOnly: widget.widget==null?false:true,
                      cursorColor: subTitleStyle().color,
                      controller: widget.controller,
                      style: subTitleStyle(),
                      decoration: InputDecoration(
                        hintText: widget.hint,
                        hintStyle: subTitleStyle(),
                        focusedBorder:  UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: darkHeaderClr,
                                width: 0
                            )
                        ),
                        enabledBorder:  UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: darkHeaderClr,
                                width: 0
                            )
                        ),
                      ),


                    )
                ),
                Container(
                  child: widget.widget==null?Container():widget.widget,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _getDateFromUser(BuildContext context) async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2121),
    );
    if(_pickerDate!=null){
    }else{
      print("Something went wrong");
    }
  }
}
