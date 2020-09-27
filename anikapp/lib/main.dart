import 'firebase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // use just because if your do not have internet connection the whole app didnt work , just beacuse all pages require internet connection.
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.orange, //this line comand used for giving header as orange in all the pages !!
      ),
      home: FirebaseA(), //this comand take to firebase based authentication page
    );
  }
}