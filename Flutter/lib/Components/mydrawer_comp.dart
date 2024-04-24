import 'package:eindopdracht/views/login_page.dart';
import 'package:eindopdracht/views/profile_page.dart';
import 'package:eindopdracht/views/todo_list.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  final Map? loggedUser;
  const MyDrawer({
    super.key,
    this.loggedUser,
  });

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  Map? user;
  @override
  void initState(){
    user = widget.loggedUser;
    print(user);
    super.initState();
  }
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .background,
      child: Column(
        children: [
          DrawerHeader(
            child: Icon(Icons.favorite, color: Theme
                .of(context)
                .colorScheme
                .inversePrimary,),
          ),
          SizedBox(height: 25.0,),
          Padding(
              padding: EdgeInsets.only(left: 25),
              child: ListTile(
                leading: Icon(Icons.home),
                title: Text("H O M E"),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ToDoListPage(loggedUser: user,)),
                  );
                },
              )
          ),

          SizedBox(height: 25.0,),

          Padding(
              padding: EdgeInsets.only(left: 25),
              child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text("P R O F I L E "),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage(loggedUser: user,)),
                    );
                  }
              )
          ),

          SizedBox(height: 25.0,),

          Padding(
              padding: EdgeInsets.only(left: 25),
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text("L O G O U T"),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              )
          ),
        ],
      ),
    );
  }
}


