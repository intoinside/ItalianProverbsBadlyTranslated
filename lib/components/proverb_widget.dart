import 'package:flutter/material.dart';
import 'package:italian_proverbs_badly_translated/config.dart';
import 'package:italian_proverbs_badly_translated/utils.dart';

class ProverbWidget extends StatefulWidget {
  final String englishProverb;

  const ProverbWidget(this.englishProverb, {super.key});

  @override
  State<StatefulWidget> createState() => _ProverbWidgetState();
}

class _ProverbWidgetState extends State<ProverbWidget> {
  String? englishProverb;
  String? italianProverb;
  bool showItalian = false;
  Color colorShade1 = const Color.fromARGB(255, 30, 30, 60);
  Color colorShade2 = const Color.fromARGB(255, 30, 30, 110);

  @override
  Widget build(BuildContext context) {
    var title = Utils.customReplace(Config.appTitle, ' ', 2, "\n");

    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary, fontSize: 40),
        ),
        Container(height: 50),
        Text(
          widget.englishProverb,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary, fontSize: 27),
        ),
      ],
    );
  }
}
