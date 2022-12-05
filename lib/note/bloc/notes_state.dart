part of 'notes_bloc.dart';

/// enum SortType { dateDeleted, dateUpdated, dateCreated, title, }
enum SortType {
  dateDeleted,
  dateUpdated,
  dateCreated,
  title,
}

class NotesState extends Equatable {
  final List<Note> loadedNotes;
  final List<Note> trashNotesList;
  final bool isLoading;
  late final bool isNoteListEmpty;
  late final bool isNoteListNotEmpty;
  late final bool isTrashListEmpty;
  late final bool isTrashListNotEmpty;

  /// If [descAscSort] is false, then the list of notes will be sorted in descending order, otherwise in ascending order.
  final bool descAscSort;

  final SortType sortType;

  NotesState({
    this.loadedNotes = const [],
    this.trashNotesList = const [],
    this.isLoading = true,
    this.descAscSort = false,
    this.sortType = SortType.dateUpdated,
  }) {
    isNoteListEmpty = loadedNotes.isEmpty;
    isNoteListNotEmpty = loadedNotes.isNotEmpty;
    isTrashListEmpty = trashNotesList.isEmpty;
    isTrashListNotEmpty = trashNotesList.isNotEmpty;
  }

  NotesState copyWith({
    List<Note>? loadedNotes,
    List<Note>? trashNotesList,
    bool? isLoading,
    bool? descAscSort,
    SortType? sortType,
  }) =>
      NotesState(
        loadedNotes: loadedNotes ?? this.loadedNotes,
        trashNotesList: trashNotesList ?? this.trashNotesList,
        isLoading: isLoading ?? this.isLoading,
        descAscSort: descAscSort ?? this.descAscSort,
        sortType: sortType ?? this.sortType,
      );

  @override
  List<Object?> get props => [
        loadedNotes,
        isLoading,
        isNoteListEmpty,
        isTrashListEmpty,
        descAscSort,
        sortType,
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
