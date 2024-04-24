import 'dart:convert';
import 'dart:math';

import 'package:eindopdracht/Components/mybutton.dart';
import 'package:eindopdracht/Components/textfield_comp.dart';
import 'package:eindopdracht/views/register_page.dart';
import 'package:eindopdracht/views/todo_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Map LoggedUser  = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                Icons.person,
              size: 80,
            ),
            SizedBox(height: 25),

          Text(
            "T O - D O",
            style: TextStyle(fontSize: 20),
          ),
            SizedBox(height: 50),

            MyTextField(hintText: "Username", obscureText: false, controller: usernameController),

            SizedBox(height: 10),

            MyTextField(hintText: "Password", obscureText: true, controller: passwordController),

            SizedBox(height: 25),

            OutlinedButton(
              onPressed: Login,
              style: OutlinedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                padding: EdgeInsets.only(left: 250, right: 250),
              ),
              child: Text('Login'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Dont have an account?"),
                GestureDetector(
                  onTap: navigateToRegisterPage,
                child: Text(" Register Here ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                )
              ],
            )
          ],
        ),
    ),
      ),
    );
  }
  Future<void>navigateToRegisterPage() async{
    final route = MaterialPageRoute(builder: (context) => RegisterPage(),

    );
    await Navigator.push(context, route);

  }
  void navigateToHomePage(Map user){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ToDoListPage(loggedUser: user,)),
    );
  }
  Future<void> Login() async{
    final username = usernameController.text;
    final password = passwordController.text;
    final body = {
      'username': username,
      'password': password,
    };
    final url = 'http://127.0.0.1:8000/users/login';
    final uri = Uri.parse(url);
    final response = await http.post(
        uri,
        body: jsonEncode(body),
        headers:{
          'Content-Type': 'application/json',
        }

    );
    if(response.statusCode == 200){
      if(response.body == 'true')
        {
          showMessage("User logged in");
          LoggedUser = body;
          print(LoggedUser);
          navigateToHomePage(LoggedUser);
        }
      else if(response.body == 'false') showMessage("Try to register first");
    }
    else{
      showMessage("Couldnt log in try to register first");
    }
  }
  void showMessage(String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}
