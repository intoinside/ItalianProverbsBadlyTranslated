import 'package:flutter/material.dart';
import 'package:italian_proverbs_badly_translated/screens/daily_proverb.dart';
import 'package:italian_proverbs_badly_translated/screens/favorite_widget.dart';
import 'package:italian_proverbs_badly_translated/config.dart';
import 'package:italian_proverbs_badly_translated/utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerWidget extends StatefulWidget {
  final int selectedIndex;
  const DrawerWidget({super.key, required this.selectedIndex});

  @override
  State<StatefulWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  int _selectedIndex = 0;
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  static const List<Widget> _widgetOptions = <Widget>[
    DailyProverbScreen(),
    FavoriteScreen(),
  ];

  _DrawerWidgetState();

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _selectedIndex = widget.selectedIndex;
    var title = Utils.customReplace(Config.appTitle, ' ', 2, "\n");

    List<Widget> childrenList = [
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
                  builder: (context) => _widgetOptions[_selectedIndex]),
            );
          }
          _onItemTapped(0);
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
                  builder: (context) => _widgetOptions[_selectedIndex]),
            );
          }
          _onItemTapped(1);
        },
      ),
      const Divider(),
      ListTile(
          title: Text(
            'About',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary, fontSize: 20),
          ),
          onTap: () {
            showAboutDialog(
              context: context,
              applicationIcon: Image.asset("assets/icon/icon.png", height: 44),
              applicationName: Config.appTitle,
              applicationVersion: _packageInfo.version,
              children: <Widget>[
                const Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 10),
                    child: Text(
                        'Author: Raffaele Intorcia\nFor complaining send me an email')),
                InkWell(
                    child:
                        const Text('Suggest a new proverb \u{1F30E}\u{2192}'),
                    onTap: () => launchUrl(Uri.parse(
                        'https://github.com/intoinside/ItalianProverbsBadlyTranslated/issues/new'))),
              ],
            );
          })
    ];
    childrenList.insert(
        0,
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
        ));

    return Drawer(
      backgroundColor: Config.colorShade2,
      child: ListView(
        children: childrenList,
      ),
    );
  }
}
