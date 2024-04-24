
import 'dart:convert';
import 'dart:ffi';

import 'package:eindopdracht/Components/mydrawer_comp.dart';
import 'package:eindopdracht/views/add_tasks.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ToDoListPage extends StatefulWidget {
  final Map? loggedUser;
  const ToDoListPage({
    super.key,
    this.loggedUser,
  });

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  List items = [];
  int userId = 0;

  @override
  void initState(){
    Map? user = widget.loggedUser;
    print(user);
    getUser(user);
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("ToDo List"),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,

      ),
      drawer: MyDrawer(

      )
      ,
      body: ListView.builder(
          itemCount: items.length,
          padding: EdgeInsets.all(12),
          itemBuilder: (context, index) {
            final task = items[index] as Map;
            final id = task['task_id'];
            return Card(
                child:ListTile(
              leading: CircleAvatar(child: Text('${index + 1}'), backgroundColor: Theme.of(context).colorScheme.inversePrimary,),
              title: Text(task['naam'] ?? ''),
              subtitle: Text(task['beschrijving'] ?? ''),
              trailing: PopupMenuButton(
                onSelected: (value) {
                  if(value == 'edit'){
                    navigateToEditPage(task, userId);
                  }
                  else if(value == 'delete')
                    {
                        delete_task(id);
                    }
                },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                        child: Text("Edit"),
                        value: 'edit',
                    ),
                    PopupMenuItem(
                        child: Text("Delete"),
                      value: 'delete',
                    ),

                  ];
                },
              ),
            ),
            );
      }),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => navigateToAddPage(userId), label: Text("Add Task"), backgroundColor: Theme.of(context).colorScheme.inversePrimary, ),
    );
  }

  Future<void>navigateToAddPage(int id) async{
  final route = MaterialPageRoute(builder: (context) => AddTodoPage(userId: id,),

  );
  await Navigator.push(context, route);
  getTasks(userId);
  }

  Future<void> navigateToEditPage(Map item, int id) async{
    final route = MaterialPageRoute(builder: (context) => AddTodoPage(todo: item, userId: id,),

    );
    await Navigator.push(context, route);
    getTasks(userId);
  }

  Future<void> getTasks(int id) async {
    final url = "http://127.0.0.1:8000/tasks/users/$id";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    print('got heer');
    print(response.statusCode);
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      List<Map<String, dynamic>> result = [];

      for (var json in jsonList) {
        result.add(json as Map<String, dynamic>);
      }

      setState(() {
        items = result;
      });

      print(items);
    } else {
      print('error');
      print(response.body);
    }
  }
  Future<void> delete_task(int id) async{
    final url = 'http://127.0.0.1:8000/tasks/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if(response.statusCode == 200){
    showMessage("Task Deleted");
    getTasks(userId);
    }
    else{
      showMessage("Something Went wrong");
    }

  }

  void showMessage(String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  Future<void> getUser(user) async {
    final url = 'http://127.0.0.1:8000/users/getid';
    final uri = Uri.parse(url);
    final body = user;
    print(user);
    final response = await http.post(uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'});

    if(response.statusCode == 200){
      userId = int.parse(response.body);
      print(userId);
      getTasks(userId);
    }
    else{
      showMessage(response.body);
    }
  }


}
