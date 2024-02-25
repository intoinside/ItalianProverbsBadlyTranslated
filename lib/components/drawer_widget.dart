import 'package:flutter/material.dart';
import 'package:italian_proverbs_badly_translated/config.dart';
import 'package:italian_proverbs_badly_translated/utils.dart';

class DrawerWidget extends StatelessWidget {
  final List<Widget> listTile;

  const DrawerWidget({super.key, required this.listTile});

  @override
  Widget build(BuildContext context) {
    var title = Utils.customReplace(Config.appTitle, ' ', 2, "\n");

    List<Widget> childrenList = List.from(listTile);
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
