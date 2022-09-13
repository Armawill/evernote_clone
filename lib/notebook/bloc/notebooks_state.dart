part of 'notebooks_bloc.dart';

abstract class NotebooksState extends Equatable {
  const NotebooksState();

  @override
  List<Object> get props => [];
}

class NotebooksInitialState extends NotebooksState {}

class NotebooksLoadedState extends NotebooksState {
  final List<Notebook> loadedNotebooks;

  const NotebooksLoadedState({required this.loadedNotebooks});

  @override
  List<Object> get props => [loadedNotebooks];
}

class NotebooksUpdatedState extends NotebooksState {}

class NotebooksErrorState extends NotebooksState {}
