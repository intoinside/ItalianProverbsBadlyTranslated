import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:italian_proverbs_badly_translated/screens/main_page_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var appTitle = 'Italian Proverbs Badly Translated';

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.robotoCondensedTextTheme(),
      ),
      home: MainPageScreen(appTitle),
    );
  }
}
