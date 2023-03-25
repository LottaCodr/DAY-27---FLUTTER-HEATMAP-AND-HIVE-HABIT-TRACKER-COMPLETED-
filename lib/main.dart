import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  //initialize hive
  await Hive.initFlutter();
  //open a box/database
  await Hive.openBox('Habit_Database');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange
      ),
      home: const HomePage(),
    );
  }
}
