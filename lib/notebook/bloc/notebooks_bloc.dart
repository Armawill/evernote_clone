import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../note/models/note.dart';
import '../../repository.dart';
import '../models/notebook.dart';

part 'notebooks_event.dart';
part 'notebooks_state.dart';

class NotebooksBloc extends Bloc<NotebookEvent, NotebooksState> {
  Repository repository;
  NotebooksBloc(this.repository) : super(NotebooksInitialState()) {
    on<NotebooksLoadEvent>((event, emit) async {
      await repository.getNotebooks();
      emit(NotebooksLoadedState(loadedNotebooks: repository.notebookList));
    });
    on<UpdateNotebookEvent>((event, emit) {
      List<Notebook> loadedNotebooks = [];
      if (state is NotebooksLoadedState) {
        final state = this.state as NotebooksLoadedState;
        loadedNotebooks = state.loadedNotebooks;

        var index = loadedNotebooks.indexWhere(
          (nb) => nb.title == event.notebookName,
        );
        if (index >= 0) {
          var noteIndex = repository.notebookList[index].noteList
              .indexWhere((note) => note.id == event.note.id);
          if (noteIndex >= 0) {
            repository.notebookList
                .elementAt(index)
                .noteList
                .replaceRange(noteIndex, noteIndex + 1, [event.note]);
            loadedNotebooks = List.from(repository.notebookList);
          } else {
            loadedNotebooks = List.from(repository.notebookList
              ..elementAt(index).noteList.add(event.note));
          }
          log('${state.loadedNotebooks == loadedNotebooks}');

          emit(NotebooksUpdatedState());
          emit(NotebooksLoadedState(loadedNotebooks: loadedNotebooks));
        }
      }
    });
    on<AddNotebookEvent>((event, emit) {
      var newNotebook =
          Notebook(id: DateTime.now().toString(), title: event.title);
      repository.addNotebook(newNotebook);
      emit(NotebooksLoadedState(
          loadedNotebooks: List.from(repository.notebookList)
            ..add(newNotebook)));
    });
  }
}
