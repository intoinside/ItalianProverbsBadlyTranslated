import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Italian Proverbs Badly Translated',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  } 
}  

class _MainPageState extends State<MainPage> {
  String? englishProverb;
  String? italianProverb;
  bool showItalian = false;
  Color colorShade1 = Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  Color colorShade2 = Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  Color colorTranslation = Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  
  _MainPageState() {
    colorShade2 = Color(colorShade1.value + 20);
    colorTranslation = Color(colorShade1.value - 10);
  }

  void _loadData() async {
    final loadedData = await rootBundle.loadString('assets/proverbs.txt');

    setState(() {
      var splittedData = LineSplitter.split(loadedData);

      var dayOfYear = int.parse(DateFormat('D').format(DateTime.now()));
      var randNum = dayOfYear % splittedData.length;

      var data = splittedData.elementAt(randNum);

      englishProverb = data.split('-').first;
      italianProverb = data.split('-').last;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorShade1,
            colorShade2,
          ],
        ),),
        child: Column(
          children: [
            Container(height: 125),
            Text(
              englishProverb ?? "empty",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimary, fontSize: 26),
            ),
            Container(height: 50,),
            IconButton(
              tooltip: "What does it means?",
              onPressed: () {
                setState(() {
                  showItalian = !showItalian;
                });
              }, icon: Icon((!showItalian ? Icons.arrow_circle_down_rounded : Icons.arrow_circle_up_rounded), size: 32, color: Colors.white38,),),
            AnimatedContainer(
              duration: const Duration(milliseconds: 700),
              curve: Curves.fastOutSlowIn,
              padding: const EdgeInsets.all(4),
              width: double.infinity,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),color: colorTranslation,),                
              height: showItalian ? 120.0 : 0.0,
              child:  Text(
                  italianProverb ?? "empty",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimary, fontSize: 18),
                ),
            ),     
            Container(height: 100),
          ],
        ),
      ),
    );
  }
}
