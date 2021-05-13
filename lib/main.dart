/*
План:
+Сделать initState
+Сделать GET-запрос к ledaks.ru
+Отдебажить полученный текст, вывести
+сохранить данные
+запустить по циклу обновление каждые 5 мин
+определить изменение данных
прислать push-уведомление со звуковым сигналом
MVP1!

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

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notification.dart';

void main() {
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
  String previousSchedule="";
  String currentSchedule="";

  void initState(){
    super.initState();
    setState(() {
      label="ПЫЩ!";
    });
  }

  void load() async{
    String message="";
/*    Timer(Duration(seconds: 3), () {
      print("Yeah, this line is printed after 3 seconds");
    });
 */
    Timer.periodic(Duration(seconds: 5*1), (timer) async{
      previousSchedule=currentSchedule;
      currentSchedule= await loadSchedule();
      setState(() {
        if (currentSchedule==previousSchedule) {
          message="_Расписание не изменилось!";
        } else
        {
          message="Расписание ИЗМЕНИЛОСЬ!";
        }
        label=message+"\n"+currentSchedule;
        MyNotification MyNotification1 = new MyNotification();
        MyNotification1.notify();

      });
      print(message + " " + DateTime.now().toString());
    });

  }

  Future<String> loadSchedule() async{
    var response = await http.get(Uri.parse("https://www.ledaks.ru/"));

    //List<Person> results = [];

    if(response.statusCode==200) {
      return response.body;
/*      List<dynamic> resultsList = convert.jsonDecode(response.body)["results"];
      for (var result in resultsList) {
        Person person = Person ();
        person.id= result["id"];
        results.add(person);
 */
      } else return response.statusCode.toString();
  }

  void pressButton(){
    setState(() {
      label+="+";
    });
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
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