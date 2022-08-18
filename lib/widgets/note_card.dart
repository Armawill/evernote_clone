import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'package:provider/provider.dart';

import '../screens/note_details_screen.dart';
import '../provider/note.dart';

class NoteCard extends StatelessWidget {
  // final String title;
  // final String text;
  // final DateTime date;

  // NoteCard(this.title, this.text, this.date);

  @override
  Widget build(BuildContext context) {
    final note = Provider.of<Note>(context);
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed(NoteDetailsScreen.routeName, arguments: note.id);
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
                DateFormat.d().add_MMM().format(note.date),
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
