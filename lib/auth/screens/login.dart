import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yellow_movies/auth/screens/loginBackground.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yellow_movies/auth/services/user_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    UserProvider authProvider = Provider.of<UserProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Welcome to Yello Movies",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height*0.1),
              SvgPicture.asset(
                  "assets/icons/login.svg",
                  height: size.height * 0.45
              ),
              SizedBox(height: size.height * 0.05),
              FlatButton(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                color: Colors.deepPurple,
                onPressed: (){
                  authProvider.googleAuth();
                },
                child: Text(
                  "Sign In with Google",
                  style: TextStyle(color: Colors.black),
                ),
              ),

            ],
          ),
        ),

      ),
    );
  }
}
