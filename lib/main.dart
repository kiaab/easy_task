import 'package:easy_task/ui/home/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const fontFamily = 'Yekan';
  static final primaryTextColor = Color(0xff273067).withOpacity(0.3);
  static const secondaryTextColor = Color(0xff273067);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          textTheme: TextTheme(
            bodyText2:
                TextStyle(fontFamily: fontFamily, color: primaryTextColor),
            headline6: TextStyle(
                fontFamily: fontFamily,
                fontSize: 18,
                color: secondaryTextColor,
                fontWeight: FontWeight.bold),
            headline4: TextStyle(
                fontFamily: fontFamily,
                fontSize: 16,
                color: secondaryTextColor),
            bodyText1: TextStyle(
                fontFamily: fontFamily,
                color: secondaryTextColor,
                fontSize: 12),
            caption: TextStyle(
                fontFamily: fontFamily, color: Colors.white, fontSize: 10),
          ),
          colorScheme: const ColorScheme.light(
              primary: Color(0xFF0d12d7),
              onSurface: Color(0xFFECEEEC),
              secondary: Color(0xffffa200))),
      home: const Directionality(
          textDirection: TextDirection.rtl, child: HomeScreen()),
    );
  }
}
