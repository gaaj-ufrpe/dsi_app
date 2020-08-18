import 'package:dsi_app/constants.dart';
import 'package:dsi_app/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(DSIApp());
}

class DSIApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appName,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: Colors.green,
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 22.0, fontStyle: FontStyle.italic),
          caption: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
          bodyText1: TextStyle(fontSize: 18.0),
          bodyText2: TextStyle(fontSize: 16.0),
//          button: TextStyle(fontSize: 18.0, decorationColor: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          contentPadding: Constants.paddingMedium,
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
          ),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.green,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
      home: LoginPage(),
    );
  }
}
