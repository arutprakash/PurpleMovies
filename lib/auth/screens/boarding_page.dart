import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yellow_movies/auth/auth_status_constants.dart';
import 'package:yellow_movies/auth/screens/login.dart';
import 'package:yellow_movies/auth/services/user_provider.dart';
import 'package:yellow_movies/screens/home.dart';

class BoardingPage extends StatelessWidget {
  const BoardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider auth = Provider.of<UserProvider>(context);

    switch(auth.authStatus){
      case Status.authenticated : return HomePage(); break ;
      case Status.unauthenticated : return LoginPage(); break;
      case Status.newUser : return HomePage(); break;
      case Status.autoLogin : return HomePage(); break;
      default : return LoginPage();
    }
    return Container();
  }
}
