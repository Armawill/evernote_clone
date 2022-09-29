part of 'notes_bloc.dart';

class NotesState extends Equatable {
  final List<Note> loadedNotes;
  final List<Note> trashNotesList;
  final bool isLoading;
  late final bool isNoteListEmpty;
  late final bool isNoteListNotEmpty;
  late final bool isTrashListEmpty;
  late final bool isTrashListNotEmpty;

  NotesState({
    this.loadedNotes = const [],
    this.trashNotesList = const [],
    this.isLoading = false,
  }) {
    isNoteListEmpty = loadedNotes.isEmpty;
    isNoteListNotEmpty = loadedNotes.isNotEmpty;
    isTrashListEmpty = trashNotesList.isEmpty;
    isTrashListNotEmpty = trashNotesList.isNotEmpty;
  }

  NotesState copyWith({
    List<Note>? loadedNotes,
    List<Note>? trashNotesList,
    bool isLoading = false,
  }) =>
      NotesState(
        loadedNotes: loadedNotes ?? this.loadedNotes,
        trashNotesList: trashNotesList ?? this.trashNotesList,
        isLoading: isLoading,
      );

  @override
  List<Object?> get props => [
        loadedNotes,
        isLoading,
        isNoteListEmpty,
        isTrashListEmpty,
      ];
}

// abstract class NotesState extends Equatable {
//   const NotesState();

//   @override
//   // TODO: implement props
//   List<Object?> get props => [];
// }

// class NotesInitialState extends NotesState {}

// class NotesEmptyState extends NotesState {}

// class NotesLoadedState extends NotesState {
//   List<Note> loadedNotes;

//   NotesLoadedState({required this.loadedNotes});

//   @override
//   // TODO: implement props
//   List<Object?> get props => [loadedNotes];
// }

// class NotesErrorState extends NotesState {}
