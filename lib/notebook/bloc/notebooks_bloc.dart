import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../note/note.dart';
import '../../repository.dart';
import '../notebook.dart';

part 'notebooks_event.dart';
part 'notebooks_state.dart';

class NotebooksBloc extends Bloc<NotebookEvent, NotebooksState> {
  Repository repository;
  NotebooksBloc(this.repository) : super(const NotebooksState()) {
    on<NotebooksLoadEvent>(_onNotebooksLoaded);
    on<AddNoteToNotebookEvent>(_onNoteToNotebookAdded);
    on<RemoveNoteFromNotebookEvent>(_onNoteFromNotebookRemoved);
    on<AddNotebookEvent>(_onNotebookAdded);
    on<RemoveNotebookEvent>(_onNotebookRemoved);
    on<RenameNotebookEvent>(_onNotebookRenamed);
    on<SortNotebooks>(_onNotebooksSorted);
  }

  Future<void> _onNotebooksLoaded(
    NotebooksLoadEvent event,
    Emitter<NotebooksState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    await repository.getNotebooks();
    List<Notebook> notebooks = [];
    List<Notebook> temp = List.from(repository.notebookList);
    for (int i = 0; i < temp.length; i++) {
      notebooks.add(Notebook.clone(temp[i]));
    }
    emit(state.copyWith(
        loadedNotebooks: sort(notebooks, state.sortType, state.descAscSort)));
  }

  void _onNotebookAdded(AddNotebookEvent event, Emitter<NotebooksState> emit) {
    var newNotebook = Notebook(
      id: DateTime.now().toString(),
      title: event.title,
      dateCreated: DateTime.now(),
      dateUpdated: DateTime.now(),
    );

    List<Notebook> notebooks = List.from(state.loadedNotebooks);

    notebooks.add(newNotebook);

    emit(state.copyWith(
        loadedNotebooks: sort(notebooks, state.sortType, state.descAscSort)));
    repository.saveNotebook(newNotebook);
  }

  void _onNotebookRemoved(
    RemoveNotebookEvent event,
    Emitter<NotebooksState> emit,
  ) {
    repository.deleteNotebook(event.notebookTitle);
    List<Notebook> notebooks = List.from(state.loadedNotebooks);
    notebooks.removeWhere((nb) => nb.title == event.notebookTitle);
    emit(
      state.copyWith(
        loadedNotebooks:
            sort(state.loadedNotebooks, state.sortType, state.descAscSort),
      ),
    );
  }

  void _onNoteToNotebookAdded(
      AddNoteToNotebookEvent event, Emitter<NotebooksState> emit) {
    List<Notebook> notebooks = [];
    List<Notebook> temp = List.from(state.loadedNotebooks);
    for (int i = 0; i < temp.length; i++) {
      notebooks.add(Notebook.clone(temp[i]));
    }

    var nbIndex = notebooks.indexWhere(
      (nb) => nb.id == event.note.notebookId,
    );

    if (nbIndex >= 0) {
      var noteIndex = notebooks[nbIndex]
          .noteIdList
          .indexWhere((noteId) => noteId == event.note.id);
      if (noteIndex < 0) {
        notebooks.elementAt(nbIndex).noteIdList.add(event.note.id);
      }
      notebooks[nbIndex].dateUpdated = DateTime.now();

      emit(state.copyWith(
          loadedNotebooks: sort(
        notebooks,
        state.sortType,
        state.descAscSort,
      )));
      repository.saveNotebook(notebooks[nbIndex]);
    } else {
      log('Error in method _onNoteToNotebookAdded');
    }
  }

  void _onNoteFromNotebookRemoved(
      RemoveNoteFromNotebookEvent event, Emitter<NotebooksState> emit) {
    List<Notebook> notebooks = [];
    List<Notebook> temp = List.from(state.loadedNotebooks);
    for (int i = 0; i < temp.length; i++) {
      notebooks.add(Notebook.clone(temp[i]));
    }

    var nbIndex = state.loadedNotebooks.indexWhere(
      (nb) => nb.id == event.note.notebookId,
    );

    if (nbIndex >= 0) {
      var noteIndex = notebooks[nbIndex]
          .noteIdList
          .indexWhere((noteId) => noteId == event.note.id);
      if (noteIndex >= 0) {
        notebooks[nbIndex].noteIdList.removeAt(noteIndex);
      } else {
        log('Error from _onNoteFromNotebookRemoved: note isn\'t exsist');
      }
      notebooks[nbIndex].dateUpdated = DateTime.now();
      emit(state.copyWith(
          loadedNotebooks: sort(notebooks, state.sortType, state.descAscSort)));
    }
  }

  void _onNotebookRenamed(
      RenameNotebookEvent event, Emitter<NotebooksState> emit) {
    List<Notebook> notebooks = List.from(state.loadedNotebooks);
    var index = notebooks.indexWhere((nb) => nb.title == event.oldTitle);
    var notebook = Notebook.clone(notebooks[index]);
    notebook.title = event.newTitle;
    notebook.dateUpdated = DateTime.now();
    repository.renameNotebook(notebook.id, notebook.title);
    notebooks[index] = notebook;
    emit(state.copyWith(
        loadedNotebooks: sort(notebooks, state.sortType, state.descAscSort)));
  }

  List<Notebook> sort(
    List<Notebook> notebooks,
    SortType sortType,
    bool descAscSort,
  ) {
    List<Notebook> notebookList = List.from(notebooks);
    if (sortType == SortType.dateUpdated) {
      if (descAscSort == false) {
        notebookList.sort(
          (a, b) => b.dateUpdated.compareTo(a.dateUpdated),
        );
      } else {
        notebookList.sort(
          (a, b) => a.dateUpdated.compareTo(b.dateUpdated),
        );
      }
    }
    if (sortType == SortType.dateCreated) {
      if (descAscSort == false) {
        notebookList.sort(
          (a, b) => b.dateCreated.compareTo(a.dateCreated),
        );
      } else {
        notebookList.sort(
          (a, b) => a.dateCreated.compareTo(b.dateCreated),
        );
      }
    }
    if (sortType == SortType.title) {
      if (descAscSort == false) {
        notebookList.sort(
          (a, b) => b.title.compareTo(a.title),
        );
      } else {
        notebookList.sort(
          (a, b) => a.title.compareTo(b.title),
        );
      }
    }
    return notebookList;
  }

  void _onNotebooksSorted(SortNotebooks event, Emitter<NotebooksState> emit) {
    List<Notebook> notebooks = List.from(state.loadedNotebooks);
    notebooks = sort(notebooks, event.sortType, event.descAscSort);

    emit(state.copyWith(
      loadedNotebooks: List.from(notebooks),
      descAscSort: event.descAscSort,
      sortType: event.sortType,
    ));
  }
}
