import 'package:flutter/material.dart';

import '../screens/note_list_screen.dart';
import '../screens/notebook_list_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: [
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
              ListTile(
                leading: Icon(Icons.note),
                title: Text('Notes'),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(NoteListScreen.routeName);
                },
              ),
              ListTile(
                leading: Icon(Icons.star_rounded),
                title: Text('Shortcuts'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.book),
                title: Text('Notebooks'),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(NotebookListScreen.routeName);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Trash'),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(
                      NoteListScreen.routeName,
                      arguments: 'Trash');
                },
              ),
            ],
          ).toList(),
        ),
      ),
    );
  }
}
