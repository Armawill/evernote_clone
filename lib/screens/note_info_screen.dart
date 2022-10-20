import 'package:evernote_clone/note/note.dart';
import 'package:evernote_clone/widgets/label_with_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class NoteInfoScreen extends StatelessWidget {
  static const routeName = '/note-info';

  final String noteId;

  const NoteInfoScreen({super.key, required this.noteId});

  @override
  Widget build(BuildContext context) {
    final notes = context.read<NotesBloc>().state.loadedNotes;
    var note = notes.firstWhere((n) => n.id == noteId);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note info'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            LabelWithText(
              labelText: 'Created',
              text: DateFormat('dd/MM/yyyy').format(note.dateCreated),
            ),
            const SizedBox(height: 15),
            LabelWithText(
              labelText: 'Updated',
              text: DateFormat('dd/MM/yyyy').format(note.dateUpdated),
            ),
          ],
        ),
      ),
    );
  }
}
