import 'dart:convert';

import 'package:eindopdracht/Components/textfield_comp.dart';
import 'package:flutter/material.dart';
import 'package:eindopdracht/Components/mybutton.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:http/http.dart' as http;



class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                onPressed: Register,
                style: OutlinedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  padding: EdgeInsets.only(left: 250, right: 250),
                ),
                child: Text('Register'),
              ),

            ],
          ),
        ),
      ),
    );
  }
  Future<void> Register() async{
    final username = usernameController.text;
    final password = passwordController.text;
    final body = {
      'username': username,
      'password': password,
    };
    final url = 'http://127.0.0.1:8000/users/';
    final uri = Uri.parse(url);
    final response = await http.post(
        uri,
        body: jsonEncode(body),
        headers:{
          'Content-Type': 'application/json',
        }

    );
    if(response.statusCode == 201){
      showMessage("User geregistreerd");
    }
    else{
      showMessage("Er is iets misgegaan");
    }
  }
  void showMessage(String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
