import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:italian_proverbs_badly_translated/config.dart';
import 'package:italian_proverbs_badly_translated/screens/main_page_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key}) {
    _detectColors();
  }

  void _detectColors() {
    var hour = DateTime.now().hour;
    var x = sin(hour * pi / 24) * 80;

    Config.colorShade1 = Color.fromARGB(255, 30, 30, 70 + x.ceil());
    Config.colorShade2 =
        Config.colorShade1.withBlue(Config.colorShade1.blue - 60);
    Config.colorTranslation = Config.colorShade2.withRed(20);
  }

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  _MyAppState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Config.appTitle,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.robotoCondensedTextTheme(),
      ),
      home: const MainPageScreen(),
    );
  }
}
