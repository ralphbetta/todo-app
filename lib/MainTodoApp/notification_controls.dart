import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
class NotificationApi{
  static final _notification = FlutterLocalNotificationsPlugin();
  static final onNotifications  = BehaviorSubject<String?>();

  static Future _notificationDetails() async{
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        // 'channel description',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: IOSNotificationDetails(),
    );
  }
  static Future init({bool initSchedule = false}) async {

    final android = AndroidInitializationSettings('app_icon');
    final iOS = IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: iOS);

    if(initSchedule){
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }

    await _notification.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotifications.add(payload);
      },
    );
  }
  static Future ShowNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async => _notification.show(
    id,
    title,
    body,
    await _notificationDetails(),
    payload: payload,
  );

  static Future ShowScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    Time? scheduledTime,
    required DateTime scheduledDate,
  }) async => _notification.zonedSchedule(
    id,
    title,
    body,
    //this takes in seconds
    tz.TZDateTime.from(scheduledDate, tz.local),
    //to set your time notification to daily, activate the line below
     //_scheduleDaily(const Time(0, 0, 10)),
    await _notificationDetails(),
    payload: payload,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    //to set your time notification to daily, activate the line below
    matchDateTimeComponents: DateTimeComponents.time,
  );

  //this is created to set time notification to daily. you can comment it out
  static tz.TZDateTime _scheduleDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        time.hour, time.minute, time.second);

    return scheduledDate.isBefore(now)
        ?scheduledDate.add(Duration(days: 1))
        :scheduledDate;


  }

}