import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final String id;
  String title;
  String text;
  DateTime dateCreated;
  DateTime dateUpdated;
  String notebookId;
  bool isInTrash;

  Note({
    required this.id,
    required this.title,
    required this.text,
    required this.dateCreated,
    required this.dateUpdated,
    required this.notebookId,
    this.isInTrash = false,
  });

  Note.empty()
      : id = '',
        title = '',
        text = '',
        dateCreated = DateTime.now(),
        dateUpdated = DateTime.now(),
        notebookId = '',
        isInTrash = false;

  @override
  List<Object?> get props =>
      [id, title, text, dateCreated, dateUpdated, notebookId, isInTrash];
}
