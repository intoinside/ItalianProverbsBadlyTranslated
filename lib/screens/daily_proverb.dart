import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:italian_proverbs_badly_translated/components/drawer_widget.dart';
import 'package:italian_proverbs_badly_translated/config.dart';
import 'package:italian_proverbs_badly_translated/components/italian_translation_widget.dart';
import 'package:italian_proverbs_badly_translated/components/proverb_widget.dart';
import 'package:overlay_toast_message/overlay_toast_message.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyProverbScreen extends StatefulWidget {
  const DailyProverbScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DailyProverbWidgetState();
}

class _DailyProverbWidgetState extends State<DailyProverbScreen>
    with RouteAware {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  String? englishProverb;
  String? italianProverb;
  bool showItalian = false;
  bool alreadyFaved = false;
  File? pathOfImage;

  ScreenshotController screenshotController = ScreenshotController();

  _DailyProverbWidgetState();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      routeObserver.subscribe(this, ModalRoute.of(context)!);
    });
    super.initState();
    _loadData();
    _setupFolder();
  }

  @override
  void didPop() {
    _setInitialFavStatus();
    super.didPop();
  }

  @override
  void didPopNext() {
    _setInitialFavStatus();
    super.didPopNext();
  }

  void _setInitialFavStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      var fullProverb = "$englishProverb-$italianProverb";

      alreadyFaved = prefs.getBool(fullProverb) ?? false;
    });
  }

  void _loadData() async {
    final loadedData = await rootBundle.loadString('assets/proverbs.txt');
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      var splittedData = LineSplitter.split(loadedData);

      var dayOfYear = int.parse(DateFormat('D').format(DateTime.now()));
      var randNum = Random(dayOfYear).nextInt(splittedData.length);

      var proverb = splittedData.elementAt(randNum);

      englishProverb = proverb.split('-').first;
      italianProverb = proverb.split('-').last;

      alreadyFaved = prefs.getBool(proverb) ?? false;
    });
  }

  void _setupFolder() async {
    var directory = await getApplicationDocumentsDirectory();
    pathOfImage = await File('${directory.path}/proverb.png').create();
  }

  Future<void> _favoritePressed() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      var fullProverb = "$englishProverb-$italianProverb";

      alreadyFaved = prefs.getBool(fullProverb) ?? false;
      if (alreadyFaved) {
        prefs.setBool(fullProverb, false);
      } else {
        prefs.setBool(fullProverb, true);
      }
      alreadyFaved = !alreadyFaved;

      OverlayToastMessage.show(
        context,
        dismissAll: true,
        textMessage:
            alreadyFaved ? "Added to favorite" : "Removed from favorite",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var proverbWidget = ProverbWidget(englishProverb ?? "");
    var translationWidget = ItalianTranslationWidget(italianProverb ?? "");

    return Scaffold(
        drawer: const DrawerWidget(selectedIndex: 0),
        key: scaffoldKey,
        floatingActionButton: Wrap(
          direction: Axis.vertical,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.all(6),
                child: FloatingActionButton(
                  heroTag: "FavBtn",
                  onPressed: _favoritePressed,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  backgroundColor: Config.colorShade2,
                  tooltip:
                      alreadyFaved ? "Remove from favorite" : "Add to favorite",
                  child: Icon(
                      alreadyFaved ? Icons.favorite : Icons.favorite_border),
                )),
            Container(
                margin: const EdgeInsets.all(6),
                child: FloatingActionButton(
                  heroTag: "Share",
                  onPressed: () {
                    screenshotController
                        // TODO: extract sharing image generation
                        .captureFromWidget(Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Config.colorShade1,
                                  Config.colorShade2,
                                ],
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(height: 100),
                                proverbWidget,
                                Container(height: 70),
                                translationWidget,
                                Container(height: 160),
                                Text(
                                  "Check on Play Store®",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          fontSize: 16),
                                ),
                              ],
                            )))
                        .then((capturedImage) {
                      final Uint8List bytes =
                          capturedImage.buffer.asUint8List();
                      pathOfImage!.writeAsBytes(bytes).whenComplete(() =>
                          Share.shareXFiles([XFile(pathOfImage!.path)],
                              subject: "Share your proverb!",
                              text: "Share your proverb!"));
                    });
                  },
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  backgroundColor: Config.colorShade2,
                  child: const Icon(Icons.share),
                )),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Config.colorShade1,
                Config.colorShade2,
              ],
            ),
          ),
          child: Column(
            children: [
              Container(height: 18),
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  color: Theme.of(context).colorScheme.onPrimary,
                  onPressed: () => scaffoldKey.currentState!.openDrawer(),
                  icon: const Icon(Icons.arrow_right_alt),
                ),
              ),
              Container(height: 16),
              proverbWidget,
              Container(height: 30),
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
                  color: Config.colorTranslation,
                ),
                height: showItalian ? 120.0 : 0.0,
                child: translationWidget,
              ),
            ],
          ),
        ));
  }
}
