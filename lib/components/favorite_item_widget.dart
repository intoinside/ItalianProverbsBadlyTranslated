import 'package:flutter/material.dart';
import 'package:overlay_toast_message/overlay_toast_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteItemWidget extends StatefulWidget {
  final String proverb;
  final bool isCurrentlyFav;

  const FavoriteItemWidget(
      {super.key, required this.proverb, required this.isCurrentlyFav});

  @override
  State<StatefulWidget> createState() => _FavoriteItemWidgetState();
}

class _FavoriteItemWidgetState extends State<FavoriteItemWidget> {
  String? proverb;
  bool isCurrentlyFav = false;

  _FavoriteItemWidgetState();

  @override
  void initState() {
    super.initState();
    proverb = widget.proverb;
    isCurrentlyFav = widget.isCurrentlyFav;
  }

  String _writeFullProverb(String proverb) {
    String englishProverb = proverb.split('-').first;
    String italianProverb = proverb.split('-').last;

    if (englishProverb == italianProverb) italianProverb = "";
    return "$englishProverb\n$italianProverb";
  }

  Future<void> _updateFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();

    if (proverb == null) return;

    setState(() {
      if (isCurrentlyFav) {
        prefs.setBool(proverb!, false);
      } else {
        prefs.setBool(proverb!, true);
      }
      isCurrentlyFav = !isCurrentlyFav;

      OverlayToastMessage.show(
        context,
        dismissAll: true,
        textMessage:
            isCurrentlyFav ? "Added to favorite" : "Removed from favorite",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: isCurrentlyFav
          ? Tooltip(
              message: "Remove from favorite",
              child: Icon(
                Icons.favorite,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )
          : Tooltip(
              message: "Add to favorite",
              child: Icon(
                Icons.favorite_border,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
      title: Text(
        _writeFullProverb(proverb!),
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.onPrimary, fontSize: 20),
      ),
      onTap: _updateFavoriteStatus,
    );
  }
}
