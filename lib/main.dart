import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsup/AuthFunctions/auth.dart';
import 'package:whatsup/Screens/Home/home.dart';
import 'package:whatsup/Screens/SplashScreen/splashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // var email = prefs.getString('email');
  // print(email);
  // runApp(MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     home: email == null ? SplashScreen() : MainScreen()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: AuthMethods().getCurrentUser(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Home();
          } else {
            return SplashScreen();
          }
        },
      ),
    );
  }
}
