import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:italian_proverbs_badly_translated/config.dart';
import 'package:italian_proverbs_badly_translated/screens/daily_proverb.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key}) {
    _detectColors();
  }

  void _detectColors() {
    var hour = DateTime.now().hour;
    var x = sin(hour * pi / 24) * 80;

    Config.colorShade1 = Color.fromARGB(255, 30, 30, 70 + x.ceil());
    Config.colorShade2 = Config.colorShade1.withBlue(Config.colorShade1.blue - 60);
    Config.colorTranslation = Config.colorShade2.withRed(20);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return MaterialApp(
      title: Config.appTitle,
      navigatorObservers: [routeObserver],
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.robotoCondensedTextTheme(),
      ),
      home: const DailyProverbScreen(),
    );
  }
}
