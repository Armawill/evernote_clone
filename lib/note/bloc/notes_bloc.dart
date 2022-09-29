import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:evernote_clone/repository.dart';

import '../note.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final Repository repository;
  NotesBloc(this.repository) : super(NotesState()) {
    on<NotesLoadEvent>(_onNotesLoaded);
    on<AddNoteEvent>(_onNoteAdded);
    on<RemoveNoteEvent>(_onNoteRemoved);
    on<AddToTrashEvent>(_onToTrashAdded);
  }

  Future<void> _onNotesLoaded(
    NotesLoadEvent event,
    Emitter<NotesState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await repository.getNotes();
      var loadedNotes = repository.noteList;
      var trashNotesList = repository.trashList;

      emit(state.copyWith(
          loadedNotes: List.from(loadedNotes), trashNotesList: trashNotesList));
    } catch (err) {
      log('Error from NotesBloc: $err');
      // emit(NotesErrorState());
    }
  }

  void _onNoteAdded(AddNoteEvent event, Emitter<NotesState> emit) {
    List<Note> loadedNotes = [];
    loadedNotes = List.from(state.loadedNotes);

    var noteIndex = loadedNotes.indexWhere(
      (note) => note.id == event.note.id,
    );
    repository.addNote(event.note);
    if (noteIndex >= 0) {
      emit(
        state.copyWith(
          loadedNotes: List.from(loadedNotes)
            ..replaceRange(noteIndex, noteIndex + 1, [event.note]),
        ),
      );
    } else {
      emit(
        state.copyWith(
          loadedNotes: List.from(loadedNotes)..add(event.note),
        ),
      );
    }
  }

  void _onNoteRemoved(RemoveNoteEvent event, Emitter<NotesState> emit) {
    repository.deleteNote(event.note.id);
    emit(
      state.copyWith(
        loadedNotes: List.from(state.loadedNotes)..remove(event.note),
      ),
    );
  }

  void _onToTrashAdded(AddToTrashEvent event, Emitter<NotesState> emit) {
    var loadedNotes = List.from(state.loadedNotes);
    var trashList = List.from(state.trashNotesList);
    repository.addToTrash(event.note);
    // var noteIndex = loadedNotes.indexWhere((note) => note.id == event.note.id);
    emit(
      state.copyWith(
        loadedNotes: List.from(loadedNotes)..remove(event.note),
        trashNotesList: List.from(trashList)
          ..add(
            loadedNotes.firstWhere((e) => e.id == event.note.id),
          ),
      ),
    );
  }
}

// class NotesBloc extends Bloc<NotesEvent, NotesState> {
//   final Repository repository;
//   NotesBloc(this.repository) : super(NotesInitialState()) {
//     on<NotesLoadEvent>(_onNotesLoaded);
//     on<AddNoteEvent>(_onNoteAdded);
//     on<RemoveNoteEvent>(_onNoteRemoved);
//     on<AddToTrashEvent>(_onToTrashAdded);
//   }

//   Future<void> _onNotesLoaded(
//     NotesLoadEvent event,
//     Emitter<NotesState> emit,
//   ) async {
//     try {
//       await repository.getNotes();
//       var loadedNotes = repository.noteList;
//       if (loadedNotes.isEmpty) {
//         emit(NotesEmptyState());
//       } else {
//         emit(NotesLoadedState(loadedNotes: loadedNotes));
//       }
//     } catch (err) {
//       print(err);
//       emit(NotesErrorState());
//     }
//   }

//   void _onNoteAdded(AddNoteEvent event, Emitter<NotesState> emit) {
//     List<Note> loadedNotes = [];
//     if (state is NotesEmptyState) {
//       emit(NotesLoadedState(loadedNotes: loadedNotes));
//     } else if (state is NotesLoadedState) {
//       final state = this.state as NotesLoadedState;
//       loadedNotes = state.loadedNotes;
//     }
//     var noteIndex = loadedNotes.indexWhere(
//       (note) => note.id == event.note.id,
//     );
//     repository.addNote(event.note);
//     if (noteIndex >= 0) {
//       emit(
//         NotesLoadedState(
//           loadedNotes: List.from(loadedNotes)
//             ..replaceRange(noteIndex, noteIndex + 1, [event.note]),
//         ),
//       );
//     } else {
//       emit(
//         NotesLoadedState(
//           loadedNotes: List.from(loadedNotes)..add(event.note),
//         ),
//       );
//     }
//   }

//   void _onNoteRemoved(RemoveNoteEvent event, Emitter<NotesState> emit) {
//     if (state is NotesLoadedState) {
//       final state = this.state as NotesLoadedState;
//       repository.deleteNote(event.note.id);
//       emit(
//         NotesLoadedState(
//           loadedNotes: List.from(state.loadedNotes)..remove(event.note),
//         ),
//       );
//     }
//   }

//   void _onToTrashAdded(AddToTrashEvent event, Emitter<NotesState> emit) {
//     if (state is NotesLoadedState) {
//       final state = this.state as NotesLoadedState;
//       var loadedNotes = state.loadedNotes;
//       repository.addToTrash(event.note);
//       loadedNotes.removeWhere((e) => e.id == event.note.id);
//       NotesLoadedState(loadedNotes: List.from(loadedNotes));
//     }
//   }
// }
