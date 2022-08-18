import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class Note with ChangeNotifier {
  final String? id;
  final String title;
  final String text;
  final DateTime date;

  Note({
    required this.id,
    required this.title,
    required this.text,
    required this.date,
  });
}

class Notes with ChangeNotifier {
  List<Note> _notes = [
    // Note(
    //   'n1',
    //   'Title 1',
    //   faker.lorem.sentences(4).join(' '),
    //   DateTime.now(),
    // ),
    // Note(
    //   'n2',
    //   'Title 2',
    //   faker.lorem.sentences(1).join(' '),
    //   DateTime.now(),
    // ),
    // Note(
    //   'n3',
    //   'Title 3',
    //   faker.lorem.sentences(4).join(' '),
    //   DateTime.now(),
    // ),
    // Note(
    //   'n4',
    //   'Title 4',
    //   faker.lorem.sentences(4).join(' '),
    //   DateTime.now(),
    // ),
    // Note(
    //   'n5',
    //   'Title 5',
    //   faker.lorem.sentences(4).join(' '),
    //   DateTime.now(),
    // ),
    // Note(
    //   'n6',
    //   'Title 6',
    //   faker.lorem.sentences(4).join(' '),
    //   DateTime.now(),
    // ),
    // Note(
    //   'n7',
    //   'Title 7',
    //   faker.lorem.sentences(4).join(' '),
    //   DateTime.now(),
    // ),
    // Note(
    //   'n8',
    //   'Title 8',
    //   faker.lorem.sentences(4).join(' '),
    //   DateTime.now(),
    // ),
    // Note(
    //   'n9',
    //   'Title 9',
    //   faker.lorem.sentences(4).join(' '),
    //   DateTime.now(),
    // ),
    // Note(
    //   'n10',
    //   'Title 10',
    //   faker.lorem.sentences(4).join(' '),
    //   DateTime.now(),
    // ),
    // Note(
    //   'n11',
    //   'Title 11',
    //   faker.lorem.sentences(4).join(' '),
    //   DateTime.now(),
    // ),
    // Note(
    //   'n12',
    //   'Title 12',
    //   faker.lorem.sentences(4).join(' '),
    //   DateTime.now(),
    // ),
    // Note(
    //   'n13',
    //   'Title 13',
    //   faker.lorem.sentences(4).join(' '),
    //   DateTime.now(),
    // ),
    // Note(
    //   'n14',
    //   'Title 14',
    //   faker.lorem.sentences(4).join(' '),
    //   DateTime.now(),
    // ),
    // Note(
    //   'n15',
    //   'Title 15',
    //   faker.lorem.sentences(4).join(' '),
    //   DateTime.now(),
    // ),
    // Note(
    //   'n16',
    //   'Title 16',
    //   faker.lorem.sentences(4).join(' '),
    //   DateTime.now(),
    // ),
    // Note(
    //   'n17',
    //   'Title 17',
    //   faker.lorem.sentences(4).join(' '),
    //   DateTime.now(),
    // ),
  ];

  List<Note> get notes {
    return [..._notes];
  }

  Note findById(String id) {
    return _notes.firstWhere((note) => note.id == id);
  }

  void addNote(Note note) {
    final newNote = Note(
      id: DateTime.now().toString(),
      title: note.title,
      text: note.text,
      date: note.date,
    );
    _notes.add(newNote);
    notifyListeners();
  }

  void updateNote(Note newNote) {
    var index = _notes.indexWhere((note) => note.id == newNote.id);
    if (index >= 0) {
      _notes[index] = newNote;
      notifyListeners();
    }
  }
}
