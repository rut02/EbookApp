import 'package:ebookapp/chkLogin/check_login.dart';
import 'package:ebookapp/detailBook/DetailBookPage.dart';
import 'package:ebookapp/register/register.dart';
import 'package:flutter/material.dart';
import 'package:ebookapp/login/login.dart';
import 'package:ebookapp/homepage/homepage.dart';
import 'package:ebookapp/detailBook/DetailBookPage.dart';
import 'package:ebookapp/myfavorite/myfavorite.dart';

void main() {
  runApp(const MyApp());
}

String ip = "192.168.197.149";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'login': (context) => login(),
        'register': (context) => register(),
        'homepage': (context) => homepage(),
        'favoritepage': (context) => myfavorite(),
        // Add more routes as needed.
      },
      home: check_login(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
    );
  }
}
