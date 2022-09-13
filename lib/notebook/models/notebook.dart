import 'package:equatable/equatable.dart';

import '../../note/models/note.dart';

class Notebook extends Equatable {
  final String id;
  final String title;
  final List<Note> noteList = [];

  Notebook({required this.id, required this.title});

  @override
  // TODO: implement props
  List<Object?> get props => [id, title, noteList];
}
