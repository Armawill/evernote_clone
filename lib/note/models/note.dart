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

  Note.empty()
      : id = '',
        title = '',
        text = '',
        date = DateTime.now(),
        notebook = 'Interesting',
        isInTrash = false;

  static Note verify(Note source) {
    String id = source.id, title = source.title;
    if (source.id.isEmpty) {
      id = DateTime.now().toString();
    }
    if (source.title.isEmpty) {
      title = 'Untitled note';
    }
    return Note(
        id: id,
        title: title,
        text: source.text,
        date: source.date,
        notebook: source.notebook);
  }

  @override
  List<Object?> get props => [id, title, text, date, notebook, isInTrash];
}
