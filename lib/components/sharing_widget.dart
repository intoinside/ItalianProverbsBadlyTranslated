import 'package:flutter/material.dart';
import 'package:italian_proverbs_badly_translated/config.dart';

class SharingWidget extends StatelessWidget {
  final Widget proverbWidget;
  final Widget translationWidget;

  const SharingWidget(
      {super.key,
      required this.proverbWidget,
      required this.translationWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
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
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary, fontSize: 16),
            ),
          ],
        ));
  }
}
