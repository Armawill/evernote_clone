import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import '../bloc/notes_bloc.dart';
import '../models/note.dart';
import '../screens/note_details_screen.dart';

class NoteCard extends StatelessWidget {
  final Note loadedNote;
  // final String title;
  // final String text;
  // final DateTime date;

  NoteCard(this.loadedNote);

  String _getDate(DateTime date) {
    final Duration duration = DateTime.now().difference(date);
    if (duration.inMinutes == 0)
      return 'just now';
    else if (duration.inHours == 0)
      return '${duration.inMinutes} min ago';
    else if (duration.inDays == 0)
      return '${duration.inHours} h ago';
    else
      return DateFormat.d().add_MMM().format(date);
  }

  @override
  Widget build(BuildContext context) {
    final note = loadedNote;
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed(NoteDetailsScreen.routeName, arguments: note);
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
                _getDate(note.date),
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
