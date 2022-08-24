part of 'notes_bloc.dart';

abstract class NotesState extends Equatable {
  const NotesState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class NotesInitialState extends NotesState {}

class NotesEmptyState extends NotesState {}

class NotesLoadedState extends NotesState {
  List<Note> loadedNotes;

  NotesLoadedState({required this.loadedNotes});

  @override
  // TODO: implement props
  List<Object?> get props => [loadedNotes];
}

class NotesErrorState extends NotesState {}
