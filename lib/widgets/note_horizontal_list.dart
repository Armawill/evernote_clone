import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../note/note.dart';
import '../widgets/note_card.dart';
import './all_note_card.dart';

class NoteHorizontalList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<NotesBloc>().add(const ShowNotesFromNotebook('Notes'));
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      child: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.isNoteListNotEmpty) {
            state.loadedNotes.sort(
              (a, b) => b.date.compareTo(a.date),
            );
            var notes = state.loadedNotes;
            int notesLength = notes.length;
            if (notesLength >= 11) {
              notesLength = 11;
            }
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: notesLength + 1,
              itemBuilder: (context, index) {
                if (index < notesLength) {
                  return NoteCard(notes[index]);
                } else {
                  return AllNoteCard(quantity: notes.length);
                }
              },
            );
          }
          if (state.isNoteListEmpty) {
            return const Center(
              child: Text('No notes yet'),
            );
          }
          // if (state is NotesErrorState) {
          //   return Center(
          //     child: Text('Something went wrong'),
          //   );
          // }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
