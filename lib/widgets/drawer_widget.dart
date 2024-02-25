import 'package:flutter/material.dart';
import 'package:italian_proverbs_badly_translated/config.dart';
import 'package:italian_proverbs_badly_translated/screens/favorite_widget.dart';
import 'package:italian_proverbs_badly_translated/screens/main_page_widget.dart';
import 'package:italian_proverbs_badly_translated/utils.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<StatefulWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var title = Utils.customReplace(Config.appTitle, ' ', 2, "\n");

    return Drawer(
      backgroundColor: Config.colorShade2,
      child: ListView(
        children: [
          DrawerHeader(
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 220,
                  child: Text(
                    title,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 20),
                  ),
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        size: 26,
                        color: Theme.of(context).colorScheme.onPrimary,
                      )),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(
              'Proverb of the day',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary, fontSize: 20),
            ),
            selected: _selectedIndex == 0,
            onTap: () {
              Navigator.pop(context);
              if (_selectedIndex != 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MainPageScreen()),
                );
                _onItemTapped(0);
              }
            },
          ),
          ListTile(
            title: Text(
              'My favorite proverbs',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary, fontSize: 20),
            ),
            selected: _selectedIndex == 1,
            onTap: () {
              Navigator.pop(context);
              if (_selectedIndex != 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FavoriteScreen()),
                );
                _onItemTapped(1);
              }
            },
          )
        ],
      ),
    );
  }
}
