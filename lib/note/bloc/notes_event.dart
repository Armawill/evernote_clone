part of 'notes_bloc.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class NotesLoadEvent extends NotesEvent {}

class AddNoteEvent extends NotesEvent {
  final Note note;

  const AddNoteEvent(this.note);

  @override
  List<Object> get props => [note];
}

class RemoveNoteEvent extends NotesEvent {
  final Note note;

  const RemoveNoteEvent(this.note);

  @override
  List<Object> get props => [note];
}

class MoveNoteToTrashEvent extends NotesEvent {
  final Note note;

  const MoveNoteToTrashEvent(this.note);

  @override
  List<Object> get props => [note];
}

class RestoreNoteFromTrash extends NotesEvent {
  final Note note;

  const RestoreNoteFromTrash(this.note);

  @override
  List<Object> get props => [note];
}

class ShowNotesFromNotebook extends NotesEvent {
  final String notebookTitle;

  const ShowNotesFromNotebook(this.notebookTitle);

  @override
  List<Object> get props => [notebookTitle];
}

class EmptyTrash extends NotesEvent {}

class SortNotes extends NotesEvent {
  final SortType sortType;
  final bool descAscSort;

  const SortNotes(this.sortType, this.descAscSort);

  @override
  List<Object> get props => [sortType, descAscSort];
}
