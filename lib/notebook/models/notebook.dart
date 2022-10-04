import 'package:equatable/equatable.dart';

import '../../note/note.dart';

class Notebook extends Equatable {
  final String id;
  final String title;
  final List<Note> noteList = [];

  Notebook({required this.id, required this.title});

  ///Copies values of all feilds
  Notebook.clone(Notebook source)
      : id = source.id,
        title = source.title {
    noteList.addAll(List.from(source.noteList));
  }

  @override
  List<Object?> get props => [id, title, noteList];
}
