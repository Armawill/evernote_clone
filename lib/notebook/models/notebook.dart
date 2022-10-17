import 'package:equatable/equatable.dart';

import '../../note/note.dart';

class Notebook extends Equatable {
  final String id;
  String title;
  final List<String> noteIdList = [];

  Notebook({required this.id, required this.title});

  ///Copies values of all feilds
  Notebook.clone(Notebook source)
      : id = source.id,
        title = source.title {
    noteIdList.addAll(List.from(source.noteIdList));
  }

  @override
  List<Object?> get props => [id, title, noteIdList];
}
