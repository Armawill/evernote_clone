part of 'notebooks_bloc.dart';

class NotebooksState extends Equatable {
  final List<Notebook> loadedNotebooks;
  final bool isLoading;

  const NotebooksState({
    this.loadedNotebooks = const [],
    this.isLoading = false,
  });

  NotebooksState copyWith({
    List<Notebook>? loadedNotebooks,
    bool isLoading = false,
  }) =>
      NotebooksState(
          loadedNotebooks: loadedNotebooks ?? this.loadedNotebooks,
          isLoading: isLoading);

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
