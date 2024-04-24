import 'package:eindopdracht/Components/mydrawer_comp.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final Map? loggedUser;
  const ProfilePage({
    super.key,
    this.loggedUser,
  });
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map? user;
  @override
  void initState(){
    user = widget.loggedUser;
    print(user);
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("P r o f i l e  P a g e"),
      ),
      drawer: MyDrawer(loggedUser: user,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Text("Username: ",),
                  Text(user?['username']),
                ],
            ),

          ],
        ),
      ),
    );
  }

}