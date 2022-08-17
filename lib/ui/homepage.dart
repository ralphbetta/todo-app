import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/api/notification_api.dart';
import 'package:todo_app/theme.dart';
import 'package:todo_app/api/second_screen.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationApi.init(initSchedule: true);
    listenNotification();
  }
  void listenNotification()=>
      NotificationApi.onNotifications.stream.listen(onClickedNoification);
  // this is to tell the app what to do when the stuff is clicked
  void onClickedNoification(String? payload)=>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context)=> SecondPage(payload:payload)
      ));
  @override
  Widget build(BuildContext context) {
    var themeVal = ThemeClass.themeNotifier.value;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
        onPressed: (){
          ThemeClass.themeNotifier.value =
              ThemeClass.themeNotifier.value == ThemeMode.light
              ?ThemeMode.dark:ThemeMode.light;
        }, icon: Icon(themeVal == ThemeMode.light?Icons.dark_mode:Icons.light_mode),),
        title: Text("Todo App"),
        actions: const [
          Icon(Icons.person),
          SizedBox(width: 10,),
        ],
      ),
      body: Center(
        child: ListView(
          children: <Widget>[

            // IconButton(
            //   onPressed: () => NotificationApi.ShowNotification(
            //     title: "Sarah Abs",
            //     body:
            //       "Hey! do we have everything we meed for lumch",
            //     payload: 'sarah.abs'
            //   ), icon: Icon(Icons.notifications),
            //   ),



            TextButton(onPressed: (){
              NotificationApi.ShowScheduledNotification(
                title: "Dinner",
                body:
                "Today at 6 pm",
                payload: 'dinner_6pm',
                scheduledDate: DateTime.now().add(Duration(seconds: 10)),
              );
              final snackBar = SnackBar(
                content: Text(
                  'Scheduled in 12 Seconds!',
                  style: TextStyle(fontSize: 24),
                ),
                backgroundColor: Colors.green,
              );
              ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(snackBar);
            },
              child: Container(
                child: Wrap(
                  children: [
                    Icon(Icons.notifications),
                    Text('Scheduled Notification'),
                  ],
                ),
              ),

              ),
            // the same thing
            TextButton(onPressed: () => NotificationApi.ShowNotification(
                title: "Sarah Abs",
                body:
                "Hey! do we have everything we meed for lumch",
                payload: 'sarah.abs'
            ),
                child: Container(
                  color: Colors.grey,
                  padding: EdgeInsets.all(10),
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.notifications),
                      Text('Simple Notification'),
                    ],
                  ),
                ),
            )
          ],
        )
      ),
    );
  }
}
