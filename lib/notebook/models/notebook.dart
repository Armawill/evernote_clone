import 'package:equatable/equatable.dart';

import '../../note/note.dart';

class Notebook extends Equatable {
  final String id;
  String title;
  final List<String> noteIdList = [];
  DateTime dateCreated;
  DateTime dateUpdated;

  Notebook({
    required this.id,
    required this.title,
    required this.dateCreated,
    required this.dateUpdated,
  });

  ///Copies values of all feilds
  Notebook.clone(Notebook source)
      : id = source.id,
        title = source.title,
        dateCreated = source.dateCreated,
        dateUpdated = source.dateUpdated {
    noteIdList.addAll(List.from(source.noteIdList));
  }

  @override
  List<Object?> get props => [id, title, noteIdList];
}
