import 'package:flutter/material.dart';

import 'package:evernote_clone/screens/note_details_screen.dart';

class AppFloatingActionButton extends StatelessWidget {
  final String notebookTitle;

  const AppFloatingActionButton({super.key, required this.notebookTitle});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.of(context).pushNamed(NoteDetailsScreen.routeName,
            arguments: {'notebookTitle': notebookTitle});
      },
      elevation: 0,
      tooltip: 'Add note',
      icon: const Icon(Icons.add),
      label: Text('New'),
    );
  }
}
