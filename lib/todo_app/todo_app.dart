import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/theme.dart';
import 'package:todo_app/todo_app/add_task_form.dart';
import '../api/notification_api.dart';
import '../constants.dart';
import 'add_task_form.dart';
import 'database/todo_database.dart';
class TodoApp extends StatefulWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  DateTime _selectedDate = DateTime.now();

  late List<Map<String, dynamic>> _journals = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshJournals() {
    setState(() async {
      _journals = await SQLHelper.getItems();
    });
  }
 //
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            ThemeClass.themeNotifier.value =
            ThemeClass.themeNotifier.value == ThemeMode.light
                ?ThemeMode.dark:ThemeMode.light;
          }, icon: Icon(ThemeClass.themeNotifier == ThemeMode.light?Icons.dark_mode:Icons.light_mode)),
        actions: [
          Icon(Icons.person),
          IconButton(
            onPressed: () => NotificationApi.ShowNotification(
              title: "Sarah Abs",
              body:
                "Hey! do we have everything we meed for lumch",
              payload: 'sarah.abs'
            ), icon: Icon(Icons.notifications),
            ),
          SizedBox(width: 10,),

        ],
      ),
      body: SafeArea(
        child: Column(
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
                    await Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTaskPage()));
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
            _showTask()


            //this is where the read edit and delete will be
          ],
        ),
      ),
    );
  }
  _showTask(){
    return Expanded(
        child: ListView.builder(
            itemCount: _journals.length,
            itemBuilder: (_, index){
              return Container(
                width: 200,
                height: 30,
                color: Colors.orange,
                child: Text(_journals[index].toString()),
                margin: const EdgeInsets.only(bottom: 10),
              );
            })
    );
  }

}

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
