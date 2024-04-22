import 'dart:convert';

import 'package:eindopdracht/Components/mybutton.dart';
import 'package:eindopdracht/Components/textfield_comp.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({
    super.key,
    this.todo,
  });

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController naamController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  void initState(){
    super.initState();
    final todo = widget.todo;
    if(todo != null){
      isEdit = true;
      final title = todo['naam'];
      final description = todo['beschrijving'];
      naamController.text = title;
      descriptionController.text = description;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,

      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
           isEdit? "Edit task": 'Add todo',
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          MyTextField(hintText: "Wat moet je nog doen?", obscureText: false, controller: naamController),
          SizedBox(height: 25,),
          MyTextField(hintText: "Wil je nog iets toevoegen?", obscureText: false, controller: descriptionController),

          SizedBox(height: 20,),
          OutlinedButton(
            onPressed: isEdit ? updateData : submitData,
            style: OutlinedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary, // Set the background color here
            ),
            child: Text(isEdit ? 'Update task' : 'Add Task'),

          ),

        ],
      ),

    );
  }
  Future <void> submitData() async{
  final naam = naamController.text;
  final description = descriptionController.text;
  final body = {
    'naam': naam,
    'beschrijving': description,
    'user_id': 2
  };
  final url = 'http://127.0.0.1:8000/tasks/';
  final uri = Uri.parse(url);
  final response = await http.post(
    uri,
    body: jsonEncode(body),
    headers:{
      'Content-Type': 'application/json',
    }
  );
  if(response.statusCode == 201){
    naamController.text = '';
    descriptionController.text = '';
    print("Gelukt");
    showMessage('Het is gelukt');
  }
  else{
    print(response.statusCode);
    print(response.body);
    showMessage("Error");
  }

  }
  Future<void> updateData() async {
    final todo = widget.todo;
    if(todo == null){
      showMessage('Something went wrong try again');
      return;
    }
    final id = todo['task_id'];
    final naam = naamController.text;
    final description = descriptionController.text;
    final body = {
      'naam': naam,
      'beschrijving': description,
      'user_id': 2
    };
    final url = 'http://127.0.0.1:8000/tasks/$id';
    final uri = Uri.parse(url);
    final response = await http.patch(
        uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
   if(response.statusCode == 200){
     showMessage('Task updated');
   }
}

  void showMessage(String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}
