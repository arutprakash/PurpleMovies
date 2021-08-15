import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:yellow_movies/auth/models/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:yellow_movies/auth/screens/boarding_page.dart';
import 'package:yellow_movies/auth/screens/login.dart';

import 'auth/services/user_provider.dart';
import 'movies/model/movie_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();

  Hive.registerAdapter(MovieAdapter());
  await Hive.openBox<Movie>('movie');

  runApp(
    MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static final String title = 'Purple Movies';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>(
              create: (context) => UserProvider()
          )
        ],
      child: MaterialApp(
        title: title,
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: BoardingPage(),
      ),
    );
  }
}
