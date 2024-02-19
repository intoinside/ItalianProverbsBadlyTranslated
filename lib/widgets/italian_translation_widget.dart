import 'package:flutter/material.dart';

class ItalianTranslationWidget extends StatelessWidget {
  final String italianProverb;

  const ItalianTranslationWidget(this.italianProverb, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      italianProverb,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Theme.of(context).colorScheme.onPrimary, fontSize: 19),
    );
  }
}
