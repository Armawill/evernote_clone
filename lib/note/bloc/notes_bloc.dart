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
    on<MoveNoteToTrashEvent>(_onNoteToTrashMoved);
    on<ShowNotesFromNotebook>(_onNotesFromNotebookShowed);
    on<RestoreNoteFromTrash>(_onNoteFromTrashRestored);
    on<EmptyTrash>(_onEmptiedTrash);
  }

  Future<void> _onNotesLoaded(
    NotesLoadEvent event,
    Emitter<NotesState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await Future.delayed(const Duration(milliseconds: 500));
      await repository.getNotes();

      var loadedNotes = repository.noteList;
      var trashNotesList = repository.trashList;

      emit(state.copyWith(
        loadedNotes: List.from(loadedNotes),
        trashNotesList: List.from(trashNotesList),
        isLoading: false,
      ));
    } catch (err) {
      log('Error from NotesBloc: $err');
      // emit(NotesErrorState());
    }
  }

  void _onNoteAdded(AddNoteEvent event, Emitter<NotesState> emit) {
    List<Note> loadedNotes = List.from(state.loadedNotes);
    var editedNote = event.note;
    // if (editedNote.title.isEmpty) {
    //   editedNote.title = 'Untitled note';
    // }
    // if (event.note.id.isEmpty) {
    //   editedNote = Note(
    //     id: DateTime.now().toString(),
    //     title: editedNote.title,
    //     text: editedNote.text,
    //     date: editedNote.date,
    //     notebook: editedNote.notebook,
    //   );
    // }

    var noteIndex = loadedNotes.indexWhere(
      (note) => note.id == editedNote.id,
    );

    if (noteIndex >= 0) {
      emit(
        state.copyWith(
          loadedNotes: List.from(loadedNotes)
            ..replaceRange(noteIndex, noteIndex + 1, [editedNote]),
        ),
      );
    } else {
      emit(
        state.copyWith(
          loadedNotes: List.from(loadedNotes)..add(editedNote),
        ),
      );
    }
    repository.addNote(editedNote);
  }

  void _onNoteRemoved(RemoveNoteEvent event, Emitter<NotesState> emit) {
    repository.deleteNote(event.note.id);
    emit(
      state.copyWith(
        loadedNotes: List.from(state.loadedNotes)..remove(event.note),
      ),
    );
  }

  void _onNoteToTrashMoved(
      MoveNoteToTrashEvent event, Emitter<NotesState> emit) {
    var loadedNotes = List.from(state.loadedNotes);
    var trashList = List.from(state.trashNotesList);

    repository.moveNoteToTrash(event.note);
    // var noteIndex = loadedNotes.indexWhere((note) => note.id == event.note.id);
    emit(
      state.copyWith(
        loadedNotes: List.from(loadedNotes)
          ..removeWhere((note) => note.id == event.note.id),
        trashNotesList: List.from(trashList)
          ..add(
            loadedNotes.firstWhere((e) => e.id == event.note.id),
          ),
      ),
    );
  }

  void _onNotesFromNotebookShowed(
      ShowNotesFromNotebook event, Emitter<NotesState> emit) {
    if (event.notebookTitle == 'Notes') {
      emit(state.copyWith(loadedNotes: List.from(repository.noteList)));
    } else if (event.notebookTitle == 'Trash') {
      emit(state.copyWith(
        loadedNotes: List.from(repository.trashList),
        trashNotesList: List.from(repository.trashList),
      ));
    } else {
      var nbIndex = repository.notebookList
          .indexWhere((nb) => nb.title == event.notebookTitle);
      if (nbIndex >= 0) {
        List<Note> noteList = [];
        for (var noteId in repository.notebookList[nbIndex].noteIdList) {
          try {
            noteList.add(
                repository.noteList.firstWhere((note) => note.id == noteId));
          } catch (err) {
            log('Error in _onNotesFromNotebookShowed. $err');
          }
        }
        emit(state.copyWith(loadedNotes: List.from(noteList)));
      }
    }
  }

  void _onNoteFromTrashRestored(
    RestoreNoteFromTrash event,
    Emitter<NotesState> emit,
  ) {
    repository.restoreNote(event.note);
    emit(state.copyWith(
      loadedNotes: List.from(state.loadedNotes)
        ..removeWhere((n) => n.id == event.note.id),
      trashNotesList: List.from(state.trashNotesList)
        ..removeWhere((n) => n.id == event.note.id),
    ));
  }

  void _onEmptiedTrash(EmptyTrash event, Emitter<NotesState> emit) async {
    repository.emptyTrash();
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(milliseconds: 300));
    emit(
      state.copyWith(
          loadedNotes: List.from(state.loadedNotes)..clear(),
          trashNotesList: List.from(state.trashNotesList)..clear(),
          isLoading: false),
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
