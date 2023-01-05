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
    emit(state.copyWith(loadedNotebooks: List.from(notebooks)));
  }

  void _onNotebookAdded(AddNotebookEvent event, Emitter<NotebooksState> emit) {
    var newNotebook =
        Notebook(id: DateTime.now().toString(), title: event.title);
    repository.addNotebook(newNotebook);
    emit(state.copyWith(
        loadedNotebooks: List.from(state.loadedNotebooks)..add(newNotebook)));
  }

  void _onNotebookRemoved(
    RemoveNotebookEvent event,
    Emitter<NotebooksState> emit,
  ) {
    repository.deleteNotebook(event.notebookTitle);
    emit(
      state.copyWith(
        loadedNotebooks: List.from(state.loadedNotebooks)
          ..removeWhere((nb) => nb.title == event.notebookTitle),
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

    var index = notebooks.indexWhere(
      (nb) => nb.id == event.note.notebookId,
    );

    if (index >= 0) {
      var noteIndex = notebooks[index]
          .noteIdList
          .indexWhere((noteId) => noteId == event.note.id);
      if (noteIndex < 0) {
        notebooks.elementAt(index).noteIdList.add(event.note.id);
      }

      emit(state.copyWith(loadedNotebooks: List.from(notebooks)));
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
      emit(state.copyWith(loadedNotebooks: List.from(notebooks)));
    }
  }

  void _onNotebookRenamed(
      RenameNotebookEvent event, Emitter<NotebooksState> emit) {
    List<Notebook> loadedNotebooks = List.from(state.loadedNotebooks);
    var index = loadedNotebooks.indexWhere((nb) => nb.title == event.oldTitle);
    var notebook = Notebook.clone(loadedNotebooks[index]);
    notebook.title = event.newTitle;
    repository.renameNotebook(notebook.id, notebook.title);
    emit(state.copyWith(
        loadedNotebooks: loadedNotebooks
          ..replaceRange(index, index + 1, [notebook])));
  }
}

// class NotebooksBloc extends Bloc<NotebookEvent, NotebooksState> {
//   Repository repository;
//   NotebooksBloc(this.repository) : super(NotebooksInitialState()) {
//     on<NotebooksLoadEvent>((event, emit) async {
//       await repository.getNotebooks();
//       emit(NotebooksLoadedState(loadedNotebooks: repository.notebookList));
//     });
//     on<UpdateNotebookEvent>((event, emit) {
//       List<Notebook> loadedNotebooks = [];
//       if (state is NotebooksLoadedState) {
//         final state = this.state as NotebooksLoadedState;
//         loadedNotebooks = List.from(state.loadedNotebooks);

//         var index = loadedNotebooks.indexWhere(
//           (nb) => nb.title == event.notebookName,
//         );
//         if (index >= 0) {
//           var noteIndex = repository.notebookList[index].noteList
//               .indexWhere((note) => note.id == event.note.id);
//           if (noteIndex >= 0) {
//             repository.notebookList
//                 .elementAt(index)
//                 .noteList
//                 .replaceRange(noteIndex, noteIndex + 1, [event.note]);
//             loadedNotebooks = List.from(repository.notebookList);
//           } else {
//             loadedNotebooks = List.from(repository.notebookList
//               ..elementAt(index).noteList.add(event.note));
//           }
//           log('repository.notebookList.first.noteList.length: ${repository.notebookList.first.noteList.length}');
//           log('state.loadedNotebooks.first.noteList.length: ${state.loadedNotebooks.first.noteList.length}');
//           log('notebooks.first.noteList.length: ${loadedNotebooks.first.noteList.length}');
//           // log('temp.first.noteList.length: ${temp.first.noteList.length}');
//           log('${state.loadedNotebooks == loadedNotebooks}');
//           log('${repository.notebookList == loadedNotebooks}');

//           //emit(NotebooksUpdatedState());
//           emit(NotebooksLoadedState(
//               loadedNotebooks: List.from(loadedNotebooks)));
//         }
//       }
//     });
//     on<AddNotebookEvent>((event, emit) {
//       var newNotebook =
//           Notebook(id: DateTime.now().toString(), title: event.title);
//       repository.addNotebook(newNotebook);
//       emit(NotebooksLoadedState(
//           loadedNotebooks: List.from(repository.notebookList)
//             ..add(newNotebook)));
//     });
//   }
// }
