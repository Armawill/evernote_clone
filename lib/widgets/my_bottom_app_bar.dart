import 'package:flutter/material.dart';

class MyBottomAppBar extends StatelessWidget {
  final VoidCallback openDrawer;
  MyBottomAppBar(this.openDrawer);
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: null,
      elevation: 10,
      color: Theme.of(context).bottomAppBarColor,
      child: IconTheme(
        data: IconThemeData(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              tooltip: 'Open navigation menu',
              icon: const Icon(Icons.menu),
              onPressed: () {
                openDrawer();
              },
            ),
            IconButton(
              tooltip: 'Search',
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
