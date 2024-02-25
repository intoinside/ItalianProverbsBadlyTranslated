import 'package:flutter/material.dart';
import 'package:italian_proverbs_badly_translated/components/favorite_widget.dart';
import 'package:italian_proverbs_badly_translated/components/daily_proverb.dart';
import 'package:italian_proverbs_badly_translated/components/drawer_widget.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<StatefulWidget> createState() => _MainState();
}

class _MainState extends State<Main> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    DailyProverbWidget(),
    FavoriteWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(listTile: [
        ListTile(
          title: Text(
            'Proverb of the day',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary, fontSize: 20),
          ),
          selected: _selectedIndex == 0,
          onTap: () {
            _onItemTapped(0);
            Navigator.pop(context);
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
            _onItemTapped(1);
          },
        )
      ]),
      body: _widgetOptions[_selectedIndex],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
