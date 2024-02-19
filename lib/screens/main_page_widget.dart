import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:italian_proverbs_badly_translated/widgets/proverb_widget.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class MainPageScreen extends StatefulWidget {
  final String title;

  const MainPageScreen(this.title, {super.key});

  @override
  State<StatefulWidget> createState() => _MainPageScreenState();
}

class _MainPageScreenState extends State<MainPageScreen> {
  String? englishProverb;
  String? italianProverb;
  bool showItalian = false;
  Color? colorShade1;
  Color? colorShade2;
  Color? colorTranslation;
  File? pathOfImage;

  ScreenshotController screenshotController = ScreenshotController();

  _MainPageScreenState() {
    var hour = DateTime.now().hour;
    var x = sin(hour * pi / 24) * 56;

    colorShade1 = Color.fromARGB(255, 30, 30, 60 + x.ceil());
    colorShade2 = colorShade1!.withBlue(colorShade1!.blue + 50);
    colorTranslation = colorShade2!.withRed(20);
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

  void _setupFolder() async {
    var directory = await getApplicationDocumentsDirectory();
    pathOfImage = await File('${directory.path}/legendary.png').create();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    _setupFolder();
  }

  @override
  Widget build(BuildContext context) {
    var proverbWidget = ProverbWidget(widget.title, englishProverb ?? "");

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            screenshotController
                .captureFromWidget(Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          colorShade1!,
                          colorShade2!,
                        ],
                      ),
                    ),
                    child: proverbWidget))
                .then((capturedImage) {
              final Uint8List bytes = capturedImage.buffer.asUint8List();
              pathOfImage!.writeAsBytes(bytes).whenComplete(
                  () => Share.shareXFiles([XFile(pathOfImage!.path)]));
            });
          },
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          backgroundColor: colorShade1,
          child: const Icon(Icons.share),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colorShade1!,
                colorShade2!,
              ],
            ),
          ),
          child: Column(
            children: [
              proverbWidget,
              Container(height: 80),
              IconButton(
                tooltip: "What does it means?",
                onPressed: () {
                  setState(() {
                    showItalian = !showItalian;
                  });
                },
                icon: Icon(
                  (!showItalian
                      ? Icons.arrow_circle_down_rounded
                      : Icons.arrow_circle_up_rounded),
                  size: 32,
                  color: Colors.white38,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 700),
                curve: Curves.fastOutSlowIn,
                padding: const EdgeInsets.all(4),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: colorTranslation,
                ),
                height: showItalian ? 150.0 : 0.0,
                child: Text(
                  italianProverb ?? "empty",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 19),
                ),
              ),
              Container(height: 100),
            ],
          ),
        ));
  }
}
