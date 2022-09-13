import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:evernote_clone/repository.dart';
import 'package:faker/faker.dart';

import '../models/note.dart';
import '../services/note_provider.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final Repository repository;
  NotesBloc(this.repository) : super(NotesInitialState()) {
    on<NotesLoadEvent>(
      (event, emit) async {
        // var noteList = [
        //   Note(
        //     id: 'n1',
        //     title: 'Title 1',
        //     text: faker.lorem.sentences(4).join(' '),
        //     date: DateTime.now(),
        //   ),
        //   Note(
        //     id: 'n2',
        //     title: 'Title 2',
        //     text: faker.lorem.sentences(1).join(' '),
        //     date: DateTime.now(),
        //   ),
        //   Note(
        //     id: 'n3',
        //     title: 'Title 3',
        //     text: faker.lorem.sentences(4).join(' '),
        //     date: DateTime.now(),
        //   ),
        //   Note(
        //     id: 'n4',
        //     title: 'Title 4',
        //     text: faker.lorem.sentences(4).join(' '),
        //     date: DateTime.now(),
        //   ),
        //   Note(
        //     id: 'n5',
        //     title: 'Title 5',
        //     text: faker.lorem.sentences(4).join(' '),
        //     date: DateTime.now(),
        //   ),
        //   Note(
        //     id: 'n6',
        //     title: 'Title 6',
        //     text: faker.lorem.sentences(4).join(' '),
        //     date: DateTime.now(),
        //   ),
        //   Note(
        //     id: 'n7',
        //     title: 'Title 7',
        //     text: faker.lorem.sentences(4).join(' '),
        //     date: DateTime.now(),
        //   ),
        //   Note(
        //     id: 'n8',
        //     title: 'Title 8',
        //     text: faker.lorem.sentences(4).join(' '),
        //     date: DateTime.now(),
        //   ),
        //   Note(
        //     id: 'n9',
        //     title: 'Title 9',
        //     text: faker.lorem.sentences(4).join(' '),
        //     date: DateTime.now(),
        //   ),
        //   Note(
        //     id: 'n10',
        //     title: 'Title 10',
        //     text: faker.lorem.sentences(4).join(' '),
        //     date: DateTime.now(),
        //   ),
        //   Note(
        //     id: 'n11',
        //     title: 'Title 11',
        //     text: faker.lorem.sentences(4).join(' '),
        //     date: DateTime.now(),
        //   ),
        //   Note(
        //     id: 'n12',
        //     title: 'Title 12',
        //     text: faker.lorem.sentences(4).join(' '),
        //     date: DateTime.now(),
        //   ),
        //   Note(
        //     id: 'n13',
        //     title: 'Title 13',
        //     text: faker.lorem.sentences(4).join(' '),
        //     date: DateTime.now(),
        //   ),
        //   Note(
        //     id: 'n14',
        //     title: 'Title 14',
        //     text: faker.lorem.sentences(4).join(' '),
        //     date: DateTime.now(),
        //   ),
        //   Note(
        //     id: 'n15',
        //     title: 'Title 15',
        //     text: faker.lorem.sentences(4).join(' '),
        //     date: DateTime.now(),
        //   ),
        //   Note(
        //     id: 'n16',
        //     title: 'Title 16',
        //     text: faker.lorem.sentences(4).join(' '),
        //     date: DateTime.now(),
        //   ),
        //   Note(
        //     id: 'n17',
        //     title: 'Title 17',
        //     text: faker.lorem.sentences(4).join(' '),
        //     date: DateTime.now(),
        //   ),
        // ];
        try {
          await repository.getNotes();
          var loadedNotes = repository.noteList;
          if (loadedNotes.isEmpty) {
            emit(NotesEmptyState());
          } else {
            emit(NotesLoadedState(loadedNotes: loadedNotes));
          }
        } catch (err) {
          print(err);
          emit(NotesErrorState());
        }
      },
    );
    on<AddNoteEvent>(
      (event, emit) {
        List<Note> loadedNotes = [];
        if (state is NotesEmptyState) {
          emit(NotesLoadedState(loadedNotes: loadedNotes));
        } else if (state is NotesLoadedState) {
          final state = this.state as NotesLoadedState;
          loadedNotes = state.loadedNotes;
        }
        var noteIndex = loadedNotes.indexWhere(
          (note) => note.id == event.note.id,
        );
        repository.addNote(event.note);
        if (noteIndex >= 0) {
          //loadedNotes[noteIndex] = event.note;
          emit(
            NotesLoadedState(
              loadedNotes: List.from(loadedNotes)
                ..replaceRange(noteIndex, noteIndex + 1, [event.note]),
            ),
          );
        } else {
          emit(
            NotesLoadedState(
              loadedNotes: List.from(loadedNotes)..add(event.note),
            ),
          );
        }
      },
    );
    on<RemoveNoteEvent>(
      (event, emit) {
        if (state is NotesLoadedState) {
          final state = this.state as NotesLoadedState;
          repository.deleteNote(event.note.id);
          emit(
            NotesLoadedState(
              loadedNotes: List.from(state.loadedNotes)..remove(event.note),
            ),
          );
        }
      },
    );
  }
}