import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/MainTodoApp/data_model.dart';
import 'package:todo_app/MainTodoApp/home.dart';
import 'package:todo_app/MainTodoApp/theme_controls.dart';
import 'package:todo_app/MainTodoApp/widgets/button.dart';
import 'package:todo_app/MainTodoApp/widgets/universal_text_input.dart';

import '../constants.dart';
import 'database_setup.dart';
import 'home2.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({Key? key}) : super(key: key);

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  //..........constants starts
  TextEditingController _titleController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30 PM";
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString() + "";
  int _selectedRemind = 5;
  List<int> remindList = [
    5,
    10,
    15,
    20
  ];
  String _selectedRepeat = "None";
  List<String> repeatList=[
    "None",
    "Daily",
    "Weekly",
    "Monthly",
  ];
  int _seletedColorIndex = 0;

  List <Color> colorList = [
    primaryClr,
    pinkClr,
    yellowClr
  ];

  List<Map<String, dynamic>> _journals = [];

  //..........constants starts
  Future<void> _addItem(DataModel dataModel) async {
    await SQLHelper.createItem(dataModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15
                ),
                child: Row(
                  children: [
                    Text('Add Task', style: HeadingStyle(),)
                  ],
                ),
              ),
              textInput(title: 'Title', hint: 'Enter Task here', controller: _titleController,),
              textInput(title: 'Note', hint: 'Enter note here', controller: _noteController,),
              textInput(title: 'Date', hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: (){_getDateFromUser(context);},
                  icon: Icon(Icons.calendar_today_outlined, color: Colors.grey,),
                ),),
              Row(
                children: [
                  Expanded(
                    child: textInput(title: 'Start Time', hint: _startTime,
                      widget: IconButton(
                        onPressed: (){_getTimeFromUser(context, isStartTime: true);},
                        icon: Icon(Icons.access_time_rounded, color: Colors.grey,),
                      ),),
                  ),

                  Expanded(
                    child: textInput(title: 'End Time', hint: _endTime,
                      widget: IconButton(
                        onPressed: (){_getTimeFromUser(context, isStartTime: false);},
                        icon: Icon(Icons.access_time_rounded, color: Colors.grey,),
                      ),),
                  ),

                ],
              ),
              textInput( title: "Remind", hint: "$_selectedRemind minutes early", widget: DropdownButton(
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey,),
                iconSize: 32,
                elevation: 4,
                alignment: AlignmentDirectional.center,
                underline: Container(
                  height: 5,
                ),
                onChanged: (String? newValue){
                  setState(() {
                    _selectedRemind = int.parse(newValue!);
                  });
                },
                style: subTitleStyle(),
                items: remindList.map<DropdownMenuItem<String>>((int value){
                  return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()));
                }).toList(),

              )
              ),
              textInput(title: "Repeat", hint: _selectedRepeat, widget: DropdownButton(
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey,),
                iconSize: 32,
                elevation: 4,
                alignment: AlignmentDirectional.center,
                underline: Container(
                  height: 0,
                ),
                onChanged: (String? newValue){
                  setState(() {
                    _selectedRepeat = newValue!;
                  });
                },
                style: subTitleStyle(),
                items: repeatList.map<DropdownMenuItem<String>>((String? value){
                  return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value!, style: TextStyle(color: Colors.grey),));
                }).toList(),

              )
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Color', style: titleStyle(),),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            ...List.generate(3, (index){
                              return Container(
                                margin: EdgeInsets.only(right: 10),
                                child: GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      _seletedColorIndex = index;
                                    });
                                  },
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: colorList[index],
                                    child: Icon(_seletedColorIndex==index?Icons.check:null, color: Colors.white,),
                                  ),
                                ),
                              );
                            })
                          ],
                        ),
                      ],
                    ),

                    MyButton(label: "Create Task", onTap: (){
                      _validate();
                    })
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  //.......this are here under Stateful widget to aid setState

  _getDateFromUser(BuildContext context) async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2121),
    );
    if(_pickerDate!=null){
      setState(() {
        _selectedDate = _pickerDate;
      });
    }else{
      print("Something went wrong");
    }
  }

  _getTimeFromUser(BuildContext context, {
    required bool isStartTime}) async {
    var pickedTime = await _showTimePicker(context);
    String _formatedTime = pickedTime.format(context);
    if(pickedTime==null){
      print('time canceled');
    }else if(isStartTime){
      setState(() {
        _startTime = _formatedTime;
      });
    }else if(!isStartTime){
      setState(() {
        _endTime  = _formatedTime;
      });
    }
  }

  _showTimePicker(BuildContext context){
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
          //startTime --> 10:30
          hour: int.parse(_startTime.split(":")[0]),
          minute: int.parse(_startTime.split(":")[1].split(" ")[0]),

        )
    );
  }

  _validate() {
    if(_titleController.text.isNotEmpty && _noteController.text.isNotEmpty){
      print('completed');
      final _task = DataModel(
        note: _noteController.text,
        title: _titleController.text,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
        color: _seletedColorIndex,
        isCompleted: 0
      );
      _addItem(_task);
      //this allows the return page to refresh in contrary to .pop
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()),
      ).then((value) => setState((){}));

    }else if(_titleController.text.isEmpty || _noteController.text.isEmpty){
      print('unable to complete');
    }
  }
}


