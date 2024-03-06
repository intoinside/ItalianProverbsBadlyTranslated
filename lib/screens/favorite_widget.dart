import 'package:flutter/material.dart';
import 'package:italian_proverbs_badly_translated/components/drawer_widget.dart';
import 'package:italian_proverbs_badly_translated/components/favorite_item_widget.dart';
import 'package:italian_proverbs_badly_translated/config.dart';
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
                          FavoriteItemWidget(
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
