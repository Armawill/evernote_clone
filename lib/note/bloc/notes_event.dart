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

class AddToTrashEvent extends NotesEvent {
  final Note note;

  const AddToTrashEvent(this.note);

  @override
  List<Object> get props => [note];
}
