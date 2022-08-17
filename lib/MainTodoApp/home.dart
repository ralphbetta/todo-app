import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/MainTodoApp/form_page.dart';
import 'package:todo_app/MainTodoApp/notification_controls.dart';
import 'package:todo_app/MainTodoApp/theme_controls.dart';
import 'package:todo_app/MainTodoApp/widgets/button.dart';
import 'package:todo_app/api/second_screen.dart';


import '../constants.dart';
import 'data_model.dart';
import 'database_setup.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final themeVal = ThemeClass.themeNotifier.value;
  late DateTime _selectedDate = DateTime.now();
  List<Map<String, dynamic>> _journals = [];
  bool _isLoading = true;

  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

//.................. initialisation for notification packages start
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationApi.init(initSchedule: true);
    listenNotification();
    _refreshJournals(); // Loading the diary when the app starts
  }
  void listenNotification()=>
      NotificationApi.onNotifications.stream.listen(onClickedNoification);
  // this is to tell the app what to do when the stuff is clicked
  void onClickedNoification(String? payload)=>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context)=> SecondPage(payload:payload) //change the second screen import later
      ));
  //.................. initialisation for notification packages ends


  // Update an existing journal
  Future<void> _updateItem(int id, DataModel updatedDataModel) async {
    await SQLHelper.updateItem(id, updatedDataModel);
    _refreshJournals();
  }



  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
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
               setState(() {
                 _selectedDate = date;
               });

              },

            ),
          ),
          //how to format date 
          //Text(_journals[3]['startTime'].toString()),
          // initialTime: TimeOfDay(
          //   //startTime --> 10:30
          //   hour: int.parse(_startTime.split(":")[0]),
          //   minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
          //
          // )

          Expanded(
              child: ListView.builder(
                  itemCount: _journals.length,
                  itemBuilder: (_, index){
                    var task = _journals[index];
                    //best way to extract time of day in 12 and 24 hrs
                      var currentTime12hrs = TimeOfDay.fromDateTime(DateTime.now()).hourOfPeriod *60;
                    if(_journals[index]['repeat']=='Daily'){
                      //start time was given in string with AM/PM
                      //this converts it to datetime format
                      DateTime date = DateFormat.jm().parse(task['startTime']);
                      //this will return the date time in 24hrs formart
                      var myTime24 = DateFormat("HH:mm").format(date);
                      //this will return the time in 12hrs format which is what we want
                      var myTime12hr  = TimeOfDay.fromDateTime(date).hourOfPeriod;
                      var myTime12min  = TimeOfDay.fromDateTime(date).minute;
                      var scheduledTime = (myTime12hr*60 + myTime12min);
                      var timeDifference = (scheduledTime - currentTime12hrs);

                      print(DateTime.now());
                      print(date);
                      print(currentTime12hrs);
                      print(myTime12min);
                      print(timeDifference);

                      NotificationApi.ShowScheduledNotification(
                        title: "Dinner",
                        body:
                        "Today at "+task['startTime'].toString(),
                        payload: 'dinner_6pm',
                        scheduledDate: DateTime.now().add(Duration(minutes: timeDifference)),
                      );

                      return staggardList(index, context);
                      //show every day
                    }else if(_journals[index]['date']==DateFormat.yMd().format(_selectedDate)){
                      //show when the inputted date matched the selected date

                      return staggardList(index, context);

                    }
                    //show all on default
                    return Container();
                  })
          )
        ],
      ),
    );
  }

  AnimationConfiguration staggardList(int index, BuildContext context) {
    return AnimationConfiguration.staggeredList(
                        position: index,
                        child: SlideAnimation(
                          child: FadeInAnimation(
                            child: Row(
                              children: [
                                GestureDetector(
                                    onTap: (
                                        ){
                                      // _showButtomSheet(context, _journals[index]);
                                      //_deleteItem(_journals[index]['id']);
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext bc){
                                            return Container(
                                                height: _journals[index]['isCompleted']==0
                                                    ?230
                                                    :190,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 20,
                                                      left: 15,
                                                      right: 15
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [

                                                      GestureDetector(
                                                        onTap: (){
                                                          final _task = DataModel(
                                                              note: _journals[index]['note'],
                                                              title: _journals[index]['title'],
                                                              date: _journals[index]['date'],
                                                              startTime: _journals[index]['startTime'],
                                                              endTime: _journals[index]['endTime'],
                                                              remind: _journals[index]['renind'],
                                                              repeat: _journals[index]['repear'],
                                                              color: _journals[index]['color'],
                                                              id: _journals[index]['id'],
                                                              isCompleted: 1
                                                          );
                                                          _updateItem( _journals[index]['id'], _task);
                                                          Navigator.pop(context);
                                                        },
                                                        child:
                                                        _journals[index]['isCompleted']==0?
                                                        Container(
                                                          width: MediaQuery.of(context).size.width-30,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors.grey.withOpacity(0.7),
                                                                offset: Offset(2,0),
                                                                blurRadius: 5,
                                                              )
                                                            ],
                                                            color: primaryClr,
                                                          ),
                                                          child: Center(
                                                            child: Text('Task Complete', style: TextStyle(color: white),),
                                                          ),
                                                        ):Container(),
                                                      ),

                                                      GestureDetector(
                                                        onTap: (){
                                                          _deleteItem(_journals[index]['id']);
                                                          Navigator.pop(context);
                                                        },
                                                        child: Container(
                                                          width: MediaQuery.of(context).size.width-30,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors.grey.withOpacity(0.7),
                                                                offset: Offset(2,0),
                                                                blurRadius: 5,
                                                              )
                                                            ],
                                                            color: pinkClr,
                                                          ),
                                                          child: Center(
                                                            child: Text('Delete Task', style: TextStyle(color: white),),
                                                          ),
                                                        ),
                                                      ),

                                                      GestureDetector(
                                                        onTap: (){
                                                          Navigator.pop(context);
                                                        },
                                                        child: Container(
                                                          width: MediaQuery.of(context).size.width-30,
                                                          height: 40,
                                                          child: Center(
                                                              child: Text('Close')
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ));
                                          });
                                    },
                                    child: TaskList(journals: _journals, index: index,)
                                )
                              ],
                            ),
                          ),
                        ));
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
              // NotificationApi.ShowNotification(
              //     title: "Sarah Abs",
              //     body:
              //     "Hey! do we have everything we meed for lumch",
              //     payload: 'sarah.abs'
              // );
              //code for scheduled notification
              NotificationApi.ShowScheduledNotification(
                title: "Dinner",
                body:
                "Today at 6 pm",
                payload: 'dinner_6pm',
                //this is for when we are not using _scheduleDaily
                scheduledDate: DateTime.now().add(Duration(minutes: 1)),
                //scheduledTime: const Time(0,0,1),
              );
            },
            child: Icon(Icons.person)),
        SizedBox(width: 10,),
      ],
    );
  }
}

class TaskList extends StatelessWidget {
  const TaskList({
    Key? key,
    required List<Map<String, dynamic>> journals, required this.index,
  }) : _journals = journals, super(key: key);

  final List<Map<String, dynamic>> _journals;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15, top: 10),
      height: 110,
      width: MediaQuery.of(context).size.width-30,
      padding: EdgeInsets.only(left: 12, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: colorList[_journals[index]['color']],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(

        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             Text(_journals[index]['title'], style: titleStyle().copyWith(color: Colors.white), ),
              Wrap(
                children: [
                  Icon(Icons.timer, color: white,),
                  Text('${_journals[index]['startTime']} - ${_journals[index]['endTime']}', style: titleStyle().copyWith(color: white),),
                ],
              ),
              Text('${_journals[index]['note']}', style: titleStyle().copyWith(color: white),),
              Text(_journals[index]['date']),
            ],
          ),
          Expanded(child: Container()),
          Container(height: 70, width: 1.5, color:white,),
          SizedBox(width: 5,),
          RotatedBox(
              quarterTurns: 3,
              child: Text(
                _journals[index]['isCompleted']!=0
                ?'COMPLETED'
                :'TODO',
                style: TextStyle(color: white),)),
          SizedBox(width: 10,),
        ],
      ),

    );
  }
}

//
// _showButtomSheet(context, task){
//   showModalBottomSheet(
//       context: context,
//       builder: (BuildContext bc){
//         return Container(
//             height: task['isCompleted']==0
//             ?230
//             :190,
//             child: Padding(
//               padding: EdgeInsets.only(
//                 top: 20,
//                 left: 15,
//                 right: 15
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   task['isCompleted']==0?
//                   GestureDetector(
//                     onTap: (){
//                       print('upadated');
//                     },
//                     child: Container(
//                       width: MediaQuery.of(context).size.width-30,
//                       height: 40,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.7),
//                             offset: Offset(2,0),
//                             blurRadius: 5,
//                           )
//                         ],
//                         color: primaryClr,
//                       ),
//                       child: Center(
//                         child: Text('Task Complete', style: TextStyle(color: white),),
//                       ),
//                     ),
//                   ):Container(),
//
//
//                   GestureDetector(
//                     onTap: (){
//                       context._deleteItem(task['id']);
//                     },
//                     child: Container(
//                       width: MediaQuery.of(context).size.width-30,
//                       height: 40,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.7),
//                             offset: Offset(2,0),
//                             blurRadius: 5,
//                           )
//                         ],
//                         color: pinkClr,
//                       ),
//                       child: Center(
//                         child: Text('Delete Task', style: TextStyle(color: white),),
//                       ),
//                     ),
//                   ),
//
//                   GestureDetector(
//                     onTap: (){
//                       Navigator.pop(context);
//                     },
//                     child: Container(
//                       width: MediaQuery.of(context).size.width-30,
//                       height: 40,
//                       child: Center(
//                         child: Text('Close')
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ));
//       });
// }