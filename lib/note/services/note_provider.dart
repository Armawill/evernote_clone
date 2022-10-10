import 'dart:developer';

import '../../helpers/db_helper.dart';
import '../note.dart';

class NoteProvider {
  Future<List<Note>> loadNotes() async {
    var notes = await fetchNotes();
    return notes;
  }

  Future<List<Note>> fetchNotes() async {
    final noteData = await DBHelper.getData('user_notes');
    final noteList = noteData
        .map((note) => Note(
              id: note['id'],
              title: note['title'],
              text: note['text'],
              date: DateTime.parse(note['date']),
              notebook: note['notebook'],
              isInTrash: note['isInTrash'] == 0 ? false : true,
            ))
        .toList();
    if (noteList.isNotEmpty)
      return noteList;
    else {
      return [];
    }
  }

  Future<void> saveNote(Note note) async {
    try {
      await DBHelper.insert(
        'user_notes',
        {
          'id': note.id,
          'title': note.title,
          'text': note.text,
          'date': note.date.toIso8601String(),
          'notebook': note.notebook,
          'isInTrash': note.isInTrash ? 1 : 0,
        },
      );
    } catch (err) {
      print(err);
      throw (err);
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      DBHelper.delete('user_notes', id);
    } catch (err) {
      print(err);
      throw (err);
    }
  }

  Future<void> emptyTrash() async {
    try {
      DBHelper.multipleDelete('user_notes', 'isInTrash', 1);
    } catch (err) {
      throw (err);
    }
  }
}
