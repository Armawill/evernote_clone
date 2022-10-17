import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final String id;
  String title;
  String text;
  DateTime date;
  String notebookId;
  bool isInTrash;

  Note({
    required this.id,
    required this.title,
    required this.text,
    required this.date,
    required this.notebookId,
    this.isInTrash = false,
  });

  Note.empty()
      : id = '',
        title = '',
        text = '',
        date = DateTime.now(),
        notebookId = '',
        isInTrash = false;

  @override
  List<Object?> get props => [id, title, text, date, notebookId, isInTrash];
}
