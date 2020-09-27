import 'register.dart';
import 'login.dart';
import 'package:flutter/material.dart';

class FirebaseA extends StatefulWidget {
  @override
  _FirebaseA createState() => _FirebaseA();
}
class _FirebaseA extends State<FirebaseA> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Neoteric thoughts"),

      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Text("Welcome TO Neoteric Thought"),
          ),
          SizedBox(height: 100.0,),
        Container(
            child: Text("If You have a account please click login button"),
        ),
          Container(
            child: OutlineButton(
              child: Text("login"),
              color: Colors.orange,
              onPressed: () => _pushPage(context, login()),
            ),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
          ),
          Container(
            child: Text("If You Don`t have a account please click Register button"),
          ),
          Container(
            child: OutlineButton(
              child: Text("Register"),
              color: Colors.orange,
              onPressed: () => _pushPage(context, Register()),
            ),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }
  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
}