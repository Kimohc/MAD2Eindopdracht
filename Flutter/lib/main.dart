import 'package:eindopdracht/themes/lightmode.dart';
import 'package:eindopdracht/views/login_page.dart';
import 'package:flutter/material.dart';
import 'views/todo_list.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,


      home: LoginPage(),

    );
  }
}
