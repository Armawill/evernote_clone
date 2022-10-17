import 'package:flutter/material.dart';

import '../helpers/datetime_helper.dart';
import '../note/note.dart';
import '../screens/note_details_screen.dart';

class NoteItem extends StatelessWidget {
  NoteItem(this.note, this._notebookTitle);
  final Note note;
  final String _notebookTitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey(note.id),
      onTap: () {
        Navigator.of(context).pushNamed(
          NoteDetailsScreen.routeName,
          arguments: {'note': note, 'notebookId': _notebookTitle},
        );
      },
      title: Container(
        height: MediaQuery.of(context).size.height * 0.25,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    note.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Text(
                  overflow: TextOverflow.ellipsis,
                  note.text,
                  style: TextStyle(color: Colors.grey[700], fontSize: 15),
                  maxLines: 6,
                ),
              ],
            ),
            Text(
              DateTimeHelper.getDate(note.date),
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
