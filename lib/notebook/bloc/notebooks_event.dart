part of 'notebooks_bloc.dart';

abstract class NotebookEvent extends Equatable {
  const NotebookEvent();

  @override
  List<Object> get props => [];
}

class NotebooksLoadEvent extends NotebookEvent {}

class AddNoteToNotebookEvent extends NotebookEvent {
  final Note note;

  const AddNoteToNotebookEvent(this.note);

  @override
  List<Object> get props => [note];
}

class RemoveNoteFromNotebookEvent extends NotebookEvent {
  final Note note;

  const RemoveNoteFromNotebookEvent(this.note);

  @override
  List<Object> get props => [note];
}

class AddNotebookEvent extends NotebookEvent {
  final String title;

  const AddNotebookEvent(this.title);

  @override
  List<Object> get props => [title];
}

class RemoveNotebookEvent extends NotebookEvent {
  final String notebookTitle;

  const RemoveNotebookEvent(this.notebookTitle);

  @override
  List<Object> get props => [notebookTitle];
}

class RenameNotebookEvent extends NotebookEvent {
  final String oldTitle;
  final String newTitle;

  const RenameNotebookEvent(this.oldTitle, this.newTitle);

  @override
  List<Object> get props => [oldTitle, newTitle];
}

class SortNotebooks extends NotebookEvent {
  final SortType sortType;
  final bool descAscSort;

  const SortNotebooks(this.sortType, this.descAscSort);

  @override
  List<Object> get props => [sortType, descAscSort];
}
