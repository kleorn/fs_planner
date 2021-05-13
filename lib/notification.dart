import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MyNotification{
  void notify(){
    print("notification\n");
    showNotification();
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future onSelectNotification(String payload) {
/*    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return NewScreen(
        payload: payload,
      );
    }));

 */
  }

/*      class NewScreen extends StatelessWidget {
      String payload;

      NewScreen({
      @required this.payload,
      });

      @override
      Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
      title: Text(payload),
      ),
      );
      }
      }

 */

  showNotification() async {
    var android = AndroidNotificationDetails(
        'id', 'channel ', 'description',
        priority: Priority.high, importance: Importance.max);
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
        0, 'Flutter devs', 'Flutter Local Notification Demo', platform,
        payload: 'Welcome to the Local Notification demo');
  }
}