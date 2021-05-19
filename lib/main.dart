/*
План:
+Сделать initState
+Сделать GET-запрос к ledaks.ru
+Отдебажить полученный текст, вывести
+сохранить данные
+запустить по циклу обновление каждые 5 мин
+определить изменение данных
+прислать push-уведомление со звуковым сигналом
+MVP1!

Распарсить данные
Отобразить расписание в таблице с датами и днями недели
MVP2!
При обновлении красить удаленные сеансы (из прошлых или на которых есть расписание) красным,
добавленные зеленым

Сделать ячейки таблицы кликабельными
Выводить по клику список учеников
Выбирать 1/несколько учеников (multiselect) и сохранять в расписании
Сделать сохранение в Firebase для доступа с телефона и с веб-страницы
Добавить необязательный выбор места (по справочнику мест)
MVP3

Сделать добавление (актуализацию) событий в Google Calendar с напоминаниями
MVP4
 */
import 'dart:async';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //flutter alarm manager
  await AndroidAlarmManager.initialize(); //flutter alarm manager

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ice Dream Planner',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: MyHomePage(title: 'Welcome to Ice Dream Planner!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String label="";
  String message="";
  String previousSchedule="";
  String currentSchedule="";
  Notifications myNotifications = Notifications();
  String monitoringUrl="https://www.ledaks.ru/"; //("http://192.168.1.71/!fs_planner_test/"));

  void initState(){
    super.initState();
    myNotifications.initNotifications();
    int x=5*1;
    setState(() {
      message="Привет, Мышь!\nНачинаю следить за расписанием\n" +monitoringUrl+"\nв "+DateTime.now().toString()+"\nкаждые "+x.toString()+" секунд.";
      label=message;
    });
    loadLoop();
    /* Timer.periodic(Duration(seconds: x), (timer) async{
      load();
    }); */
  }

  void loadLoop() async{

  }

  void load() async{
/*    Timer(Duration(seconds: 3), () {
      print("Yeah, this line is printed after 3 seconds");
    }); */
      previousSchedule=currentSchedule;
      currentSchedule= await loadSchedule();
      setState(() {
        if (currentSchedule=="") {
        } else
        if (currentSchedule==previousSchedule) {
          //message="Расписание не изменилось!";
        } else
        {
          message="Расписание ИЗМЕНИЛОСЬ\n"+DateTime.now().toString()+"!\n"+message;
        }
        label=message;//+currentSchedule;

        //Пока во всех случаях!
        //showprint();
        AndroidAlarmManager.oneShot(Duration(seconds: 5), 0, showprint);//myNotifications.pushNotification);
      });
      //print(message + " " + DateTime.now().toString());
  }

  showprint() {
    print('alarm done');
  }

  Future<String> loadSchedule() async{
    var response = await http.get(Uri.parse(monitoringUrl));

    if(response.statusCode==200) {
      return response.body;
      } else return response.statusCode.toString();
  }

  void pressButton(){
    setState(() {
      label+="Мррр!\n";
      //loadLoop();
    });
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(label,
                style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pressButton,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}