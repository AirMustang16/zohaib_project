import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:zohaib_project/main.dart';

import 'main_screen.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final FacebookLogin facebookSignIn = new FacebookLogin();
  void logoutFacebook() async {
    await facebookSignIn.logOut();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return Myapp();
        },
      ),
    );
    print("User Sign Out");
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: logoutFacebook,
              child: Text(
                "Log out",
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
            Divider(
              height: 20,
              thickness: 1,
            )
          ],
        ));
  }
}
