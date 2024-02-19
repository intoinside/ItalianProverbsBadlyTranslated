import 'package:flutter/material.dart';

class ProverbWidget extends StatefulWidget {
  final String title;
  final String englishProverb;

  const ProverbWidget(this.title, this.englishProverb, {super.key});

  @override
  State<StatefulWidget> createState() => _ProverbWidgetState();
}

class _ProverbWidgetState extends State<ProverbWidget> {
  String? englishProverb;
  String? italianProverb;
  bool showItalian = false;
  Color colorShade1 = const Color.fromARGB(255, 30, 30, 60);
  Color colorShade2 = const Color.fromARGB(255, 30, 30, 110);

  String customReplace(
      String text, String searchText, int replaceOn, String replaceText) {
    Match result = searchText.allMatches(text).elementAt(replaceOn - 1);
    return text.replaceRange(result.start, result.end, replaceText);
  }

  @override
  Widget build(BuildContext context) {
    var title = customReplace(widget.title, ' ', 2, "\n");

    return Column(
      children: [
        Container(height: 30),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary, fontSize: 40),
        ),
        Container(height: 50),
        Text(
          widget.englishProverb ?? "empty",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary, fontSize: 27),
        ),
      ],
    );
  }
}
