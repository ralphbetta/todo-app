import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/api/notification_api.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/todo_app/database/todo_database.dart';
import 'package:todo_app/todo_app/model.dart';
import 'package:todo_app/todo_app/todo_app.dart';

import '../theme.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  //constants
  TextEditingController _titleController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30 PM";
  String _startTime = DateFormat('hh:mm').format(DateTime.now()).toString();
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

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  // Insert a new journal to the database
  Future<void> _addItem() async {
    await SQLHelper.createItem(
      0,
      _seletedColorIndex,
      _selectedRemind,
      _titleController.text,
      _noteController.text,
      DateFormat.yMd().format(_selectedDate),
      _startTime,
      _endTime,
      _selectedRepeat,
        );
    //_refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
       // backgroundColor: appBarClr,
        actions: [
          Icon(Icons.person, ),
          IconButton(
            onPressed: () => NotificationApi.ShowNotification(
                title: "Sarah Abs",
                body:
                "Hey! do we have everything we meed for lumch",
                payload: 'sarah.abs'
            ), icon: Icon(Icons.notifications,),
          ),
          SizedBox(width: 10,),

        ],
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
                  height: 0,
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
                      _validateDate();
                    })
                  ],
                ),
              )
            ],
          ),
        ),
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
      setState(() {
        _selectedDate = _pickerDate;
      });
    }else{
      print("Something went wrong");
    }
  }

  _getTimeFromUser(BuildContext context, {required bool isStartTime}) async {
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

  _validateDate(){
    if(_titleController.text.isNotEmpty &&_noteController.text.isNotEmpty){
      //add to database
      _addItem();
      print('saved');
      //print(_journals);
      Navigator.pop(context);
    }else if(_titleController.text.isEmpty || _noteController.text.isEmpty){
      print('empty fields');
      print(_noteController.text);
      print(_titleController.text);
      final snackbar = SnackBar(
        content: Text(
          'Required, All fields are required',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        backgroundColor: Colors.white,


      );
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(snackbar);
    }
  }
  //
  // _addTastToDb(){
  //   TaskModel(
  //     note: _noteController.text,
  //     title: _titleController.text,
  //     date: DateFormat.yMd().format(_selectedDate),
  //     startTime: _startTime,
  //     endTime: _endTime,
  //     remind: _selectedRemind,
  //     repeat: _selectedRepeat,
  //     color: _seletedColorIndex,
  //     isCompleted: 0
  //
  // );
  //   print(TaskModel().title);
  // }
}



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


