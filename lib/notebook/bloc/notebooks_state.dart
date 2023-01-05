part of 'notebooks_bloc.dart';

class NotebooksState extends Equatable {
  final List<Notebook> loadedNotebooks;
  final bool isLoading;

  /// If [descAscSort] is false, then the list of notes will be sorted in descending order, otherwise in ascending order.
  final bool descAscSort;

  final SortType sortType;

  const NotebooksState({
    this.loadedNotebooks = const [],
    this.isLoading = false,
    this.descAscSort = true,
    this.sortType = SortType.dateCreated,
  });

  NotebooksState copyWith({
    List<Notebook>? loadedNotebooks,
    bool isLoading = false,
    bool? descAscSort,
    SortType? sortType,
  }) =>
      NotebooksState(
        loadedNotebooks: loadedNotebooks ?? this.loadedNotebooks,
        isLoading: isLoading,
        descAscSort: descAscSort ?? this.descAscSort,
        sortType: sortType ?? this.sortType,
      );

  @override
  List<Object> get props => [loadedNotebooks];
}

// abstract class NotebooksState extends Equatable {
//   const NotebooksState();

//   @override
//   List<Object> get props => [];
// }

// class NotebooksInitialState extends NotebooksState {}

// class NotebooksLoadedState extends NotebooksState {
//   final List<Notebook> loadedNotebooks;

//   const NotebooksLoadedState({required this.loadedNotebooks});

//   @override
//   List<Object> get props => [loadedNotebooks];
// }

// class NotebooksUpdatedState extends NotebooksState {}

// class NotebooksErrorState extends NotebooksState {}
