import 'package:evernote_clone/note/note.dart';
import 'package:evernote_clone/widgets/label_with_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class NoteInfoScreen extends StatefulWidget {
  static const routeName = '/note-info';

  final String noteId;

  const NoteInfoScreen({super.key, required this.noteId});

  @override
  State<NoteInfoScreen> createState() => _NoteInfoScreenState();
}

class _NoteInfoScreenState extends State<NoteInfoScreen> {
  @override
  Widget build(BuildContext context) {
    final notes = context.read<NotesBloc>().state.loadedNotes;
    var note = notes.firstWhere((n) => n.id == widget.noteId);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note info'),
        elevation: 0,
        leading: ElevatedButton(
          child: const Icon(Icons.close),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              return Colors.white;
            }),
            foregroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.grey;
              }
              return Colors.black;
            }),
            elevation: MaterialStateProperty.resolveWith((states) {
              return 0;
            }),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
            const SizedBox(height: 25),
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
