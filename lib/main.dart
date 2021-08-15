import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yellow_movies/auth/models/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:yellow_movies/auth/screens/boarding_page.dart';
import 'package:yellow_movies/auth/screens/login.dart';

import 'auth/services/user_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>(
              create: (context) => UserProvider()
          )
        ],
      child: MaterialApp(
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: BoardingPage(),
      ),
    );
  }
}
