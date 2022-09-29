import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final String id;
  String title;
  String text;
  DateTime date;
  String notebook;
  bool isInTrash;

  Note({
    required this.id,
    required this.title,
    required this.text,
    required this.date,
    required this.notebook,
    this.isInTrash = false,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id, title, text, date, notebook, isInTrash];
}
