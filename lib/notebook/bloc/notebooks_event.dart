part of 'notebooks_bloc.dart';

abstract class NotebookEvent extends Equatable {
  const NotebookEvent();

  @override
  List<Object> get props => [];
}

class NotebooksLoadEvent extends NotebookEvent {}

class AddNoteToNotebookEvent extends NotebookEvent {
  final Note note;
  final String notebookName;

  const AddNoteToNotebookEvent(this.note, this.notebookName);

  @override
  List<Object> get props => [note, notebookName];
}

class RemoveNoteFromNotebookEvent extends NotebookEvent {
  final Note note;
  final String notebookName;

  const RemoveNoteFromNotebookEvent(this.note, this.notebookName);

  @override
  List<Object> get props => [note, notebookName];
}

class AddNotebookEvent extends NotebookEvent {
  final String title;

  const AddNotebookEvent(this.title);

  @override
  List<Object> get props => [title];
}

class RemoveNotebookEvent extends NotebookEvent {
  final Notebook notebook;

  const RemoveNotebookEvent(this.notebook);

  @override
  // TODO: implement props
  List<Object> get props => [notebook];
}
