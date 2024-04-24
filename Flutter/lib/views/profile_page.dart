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
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              padding: EdgeInsets.all(25),
              child: Icon(
                Icons.person,
                size: 64,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Text(user?['username'], style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),),
                ],
            ),

          ],
        ),
      ),
    );
  }

}