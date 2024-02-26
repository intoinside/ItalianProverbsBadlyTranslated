import 'package:flutter/material.dart';
import 'package:italian_proverbs_badly_translated/components/drawer_widget.dart';
import 'package:italian_proverbs_badly_translated/config.dart';
import 'package:overlay_toast_message/overlay_toast_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteScreen> {
  final String headerKey = "HEADER";

  Map<String, bool> favMap = <String, bool>{};

  _FavoriteWidgetState();

  @override
  void initState() {
    super.initState();
    _getAllFavouriteList();
  }

  void _getAllFavouriteList() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      for (var key in prefs.getKeys()) {
        try {
          var value = prefs.get(key) as bool;
          if (value) {
            // If current map is empty, add a header
            if (favMap.isEmpty) favMap[headerKey] = true;
            favMap[key] = true;
          }
        } on Exception catch (_) {
          rethrow;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const DrawerWidget(selectedIndex: 1),
        body: Container(
          width: double.infinity,
          height: double.infinity,
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
          padding: const EdgeInsets.fromLTRB(8, 40, 8, 24),
          child: favMap.isNotEmpty
              ? ListView.builder(
                  itemCount: favMap.length,
                  itemBuilder: (BuildContext context, int index) {
                    String key = favMap.keys.elementAt(index);

                    if (key == headerKey) {
                      return Text("Favorite list",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontSize: 26));
                    } else {
                      return Column(
                        children: [
                          FavoriteItem(
                            proverb: key,
                            isCurrentlyFav: favMap[key] ?? false,
                          ),
                          const Divider(),
                        ],
                      );
                    }
                  },
                  padding: const EdgeInsets.all(8),
                )
              : Text(
                  "No favorite proverbs collected",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 20),
                ),
        ));
  }
}

class FavoriteItem extends StatefulWidget {
  final String proverb;
  final bool isCurrentlyFav;

  const FavoriteItem(
      {super.key, required this.proverb, required this.isCurrentlyFav});

  @override
  State<StatefulWidget> createState() => _FavoriteItemState();
}

class _FavoriteItemState extends State<FavoriteItem> {
  String? proverb;
  bool isCurrentlyFav = false;

  _FavoriteItemState();

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
