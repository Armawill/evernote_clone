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
    on<SortNotes>(_onNotesSorted);
  }

  Future<void> _onNotesLoaded(
    NotesLoadEvent event,
    Emitter<NotesState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await Future.delayed(const Duration(milliseconds: 500));
      await repository.getNotes();

      List<Note> loadedNotes = List.from(repository.noteList);
      List<Note> trashNotesList = List.from(repository.trashList);

      emit(state.copyWith(
        loadedNotes: loadedNotes,
        trashNotesList: trashNotesList,
        isLoading: false,
      ));
    } catch (err) {
      log('Error from NotesBloc: $err');
    }
  }

  void _onNoteAdded(AddNoteEvent event, Emitter<NotesState> emit) {
    List<Note> loadedNotes = List.from(state.loadedNotes);
    var editedNote = Note(
        id: event.note.id,
        title: event.note.title,
        text: event.note.text,
        dateCreated: event.note.dateCreated,
        dateUpdated: DateTime.now(),
        dateDeleted: event.note.dateDeleted,
        notebookId: event.note.notebookId);

    var noteIndex = loadedNotes.indexWhere(
      (note) => note.id == editedNote.id,
    );

    if (noteIndex >= 0) {
      loadedNotes[noteIndex] = editedNote;
      loadedNotes = sort(loadedNotes, state.sortType, state.descAscSort);
      emit(
        state.copyWith(
          loadedNotes: List.from(loadedNotes),
        ),
      );
    } else {
      loadedNotes.add(editedNote);
      loadedNotes = sort(loadedNotes, state.sortType, state.descAscSort);
      emit(
        state.copyWith(
          loadedNotes: List.from(loadedNotes),
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
      // var noteList =
      //     sort(repository.noteList, state.sortType, state.descAscSort);
      emit(state.copyWith(
          loadedNotes:
              sort(repository.noteList, state.sortType, state.descAscSort)));
    } else if (event.notebookTitle == 'Trash') {
      // var noteList =
      //     sort(repository.trashList, state.sortType, state.descAscSort);
      emit(state.copyWith(
        loadedNotes:
            sort(repository.trashList, state.sortType, state.descAscSort),
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
        // noteList = sort(noteList, state.sortType, state.descAscSort);
        emit(state.copyWith(
            loadedNotes: sort(noteList, state.sortType, state.descAscSort)));
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

  List<Note> sort(
    List<Note> loadedNotes,
    SortType sortType,
    bool descAscSort,
  ) {
    List<Note> noteList = List.from(loadedNotes);
    if (sortType == SortType.dateUpdated) {
      if (descAscSort == false) {
        noteList.sort(
          (a, b) => b.dateUpdated.compareTo(a.dateUpdated),
        );
      } else {
        noteList.sort(
          (a, b) => a.dateUpdated.compareTo(b.dateUpdated),
        );
      }
    }
    if (sortType == SortType.dateCreated) {
      if (descAscSort == false) {
        noteList.sort(
          (a, b) => b.dateCreated.compareTo(a.dateCreated),
        );
      } else {
        noteList.sort(
          (a, b) => a.dateCreated.compareTo(b.dateCreated),
        );
      }
    }
    if (sortType == SortType.title) {
      if (descAscSort == false) {
        noteList.sort(
          (a, b) => b.title.compareTo(a.title),
        );
      } else {
        noteList.sort(
          (a, b) => a.title.compareTo(b.title),
        );
      }
    }
    return noteList;
  }

  void _onNotesSorted(SortNotes event, Emitter<NotesState> emit) {
    List<Note> loadedNotes = List.from(state.loadedNotes);
    loadedNotes = sort(loadedNotes, event.sortType, event.descAscSort);

    emit(state.copyWith(
      loadedNotes: List.from(loadedNotes),
      descAscSort: event.descAscSort,
      sortType: event.sortType,
    ));
  }
}
