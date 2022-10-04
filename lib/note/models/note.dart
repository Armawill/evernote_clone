import 'package:equatable/equatable.dart';

class Note extends Equatable {
  late final String id;
  late String title;
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

  Note.verify(Note source)
      : text = source.text,
        date = source.date,
        notebook = source.notebook,
        isInTrash = source.isInTrash {
    if (source.id.isEmpty) {
      id = DateTime.now().toString();
    }
    if (source.title.isEmpty) {
      title = 'Untitled note';
    }
  }

  @override
  List<Object?> get props => [id, title, text, date, notebook, isInTrash];
}
