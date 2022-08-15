import 'package:faker/faker.dart';

class Note {
  String title;
  String text;
  DateTime date;

  Note(this.title, this.text, this.date);
}

class Notes {
  List<Note> _notes = [
    Note(
      'Title 1',
      faker.lorem.sentences(4).join(' '),
      DateTime.now(),
    ),
    Note(
      'Title 2',
      faker.lorem.sentences(1).join(' '),
      DateTime.now(),
    ),
    Note(
      'Title 3',
      faker.lorem.sentences(4).join(' '),
      DateTime.now(),
    ),
    Note(
      'Title 4',
      faker.lorem.sentences(4).join(' '),
      DateTime.now(),
    ),
    Note(
      'Title 5',
      faker.lorem.sentences(4).join(' '),
      DateTime.now(),
    ),
    Note(
      'Title 6',
      faker.lorem.sentences(4).join(' '),
      DateTime.now(),
    ),
    Note(
      'Title 7',
      faker.lorem.sentences(4).join(' '),
      DateTime.now(),
    ),
    Note(
      'Title 8',
      faker.lorem.sentences(4).join(' '),
      DateTime.now(),
    ),
    Note(
      'Title 9',
      faker.lorem.sentences(4).join(' '),
      DateTime.now(),
    ),
    Note(
      'Title 10',
      faker.lorem.sentences(4).join(' '),
      DateTime.now(),
    ),
    Note(
      'Title 11',
      faker.lorem.sentences(4).join(' '),
      DateTime.now(),
    ),
    Note(
      'Title 12',
      faker.lorem.sentences(4).join(' '),
      DateTime.now(),
    ),
    Note(
      'Title 13',
      faker.lorem.sentences(4).join(' '),
      DateTime.now(),
    ),
    Note(
      'Title 14',
      faker.lorem.sentences(4).join(' '),
      DateTime.now(),
    ),
    Note(
      'Title 15',
      faker.lorem.sentences(4).join(' '),
      DateTime.now(),
    ),
    Note(
      'Title 16',
      faker.lorem.sentences(4).join(' '),
      DateTime.now(),
    ),
    Note(
      'Title 17',
      faker.lorem.sentences(4).join(' '),
      DateTime.now(),
    ),
  ];

  List<Note> get notes {
    return [..._notes];
  }
}
