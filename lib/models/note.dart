import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final String id;
  final String title;
  final String text;
  final DateTime date;

  Note({
    required this.id,
    required this.title,
    required this.text,
    required this.date,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id, title, text, date];
}
