import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:zohaib_project/screens/main_screen.dart';

final FacebookLogin facebookSignIn = new FacebookLogin();

class SignIn {
  final context;
  SignIn(this.context);
  login() async {
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
        print('''
           Logged in!
           
           Token: ${accessToken.token}
           User id: ${accessToken.userId}
           Expires: ${accessToken.expires}
           Permissions: ${accessToken.permissions}
           Declined permissions: ${accessToken.declinedPermissions}
           ''');
        break;
      case FacebookLoginStatus.cancelledByUser:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
        print('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }
}
