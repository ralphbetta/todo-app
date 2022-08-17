import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/MainTodoApp/theme_controls.dart';
import 'package:todo_app/MainTodoApp/widgets/button.dart';

import '../constants.dart';
import 'database_setup.dart';
import 'form_page.dart';
import 'notification_controls.dart';

class Home2 extends StatefulWidget {
  const Home2({Key? key}) : super(key: key);

  @override
  _Home2State createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  final themeVal = ThemeClass.themeNotifier.value;
  late DateTime _selectedDate = DateTime.now();
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

  @override
  void initState() {
    super.initState();
    _refreshJournals(); // Loading the diary when the app starts
    print(_journals);
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(1);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('hello'),
    ));
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 12.0
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DateFormat.yMMMMd().format(DateTime.now()),
                      style: HeadingStyle(),),
                    Text('Today',style: subHeadingStyle(),)
                  ],
                ),
                MyButton(label: '+Add Task', onTap:() async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context)=>TaskForm()));
                },)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 12, top: 20),
            child: DatePicker(
              DateTime.now(),
              height: 100,
              width:80,
              initialSelectedDate: DateTime.now(),
              selectionColor: primaryClr,
              selectedTextColor: Colors.white,
              dateTextStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey
              ),
              dayTextStyle: TextStyle(
                fontWeight: FontWeight.w600,
              ),
              monthTextStyle: TextStyle(
                fontWeight: FontWeight.w600,
              ),
              onDateChange: (date){
                _selectedDate = date;
              },

            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: _journals.length,
                  itemBuilder: (_, index){
                    return AnimationConfiguration.staggeredList(
                        position: index,
                        child: SlideAnimation(
                          child: FadeInAnimation(
                            child: Row(
                              children: [
                                GestureDetector(
                                    onTap: (
                                        ){
                                      //_showButtomSheet(context, _journals[index]);
                                      _deleteItem(index);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      height: 40,
                                      width: 300,
                                      color: Colors.red,
                                    )
                                )
                              ],
                            ),
                          ),
                        ));
                  })
          )
        ],
      ),
    );
  }
  //app bar refactored method
  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        onPressed: (){
          ThemeClass.themeNotifier.value =
          ThemeClass.themeNotifier.value == ThemeMode.light
              ?ThemeMode.dark:ThemeMode.light;
        }, icon: Icon(themeVal == ThemeMode.light?Icons.dark_mode:Icons.light_mode),),
      title: Text("Todo App"),
      actions: [
        GestureDetector(
            onTap: (){
              NotificationApi.ShowNotification(
                  title: "Sarah Abs",
                  body:
                  "Hey! do we have everything we meed for lumch",
                  payload: 'sarah.abs'
              );
            },
            child: Icon(Icons.person)),
        SizedBox(width: 10,),
      ],
    );
  }
}
