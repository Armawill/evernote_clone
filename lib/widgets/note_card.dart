import 'package:flutter/material.dart';

import '../note/note.dart';
import '../screens/note_details_screen.dart';
import '../helpers/datetime_helper.dart';

class NoteCard extends StatelessWidget {
  final Note loadedNote;
  // final String title;
  // final String text;
  // final DateTime date;

  NoteCard(this.loadedNote);

  @override
  Widget build(BuildContext context) {
    final note = loadedNote;
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(NoteDetailsScreen.routeName,
              arguments: {'note': note, 'notebookId': note.notebookId});
        },
        splashFactory: NoSplash.splashFactory,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          padding: const EdgeInsets.all(10),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
      ),
    );
  }
}
