import '../helpers/db_helper.dart';
import '../models/note.dart';

class NoteRepository {
  Future<List<Note>> fetchNotes() async {
    final noteData = await DBHelper.getData('user_notes');
    final noteList = noteData
        .map((note) => Note(
              id: note['id'],
              title: note['title'],
              text: note['text'],
              date: DateTime.parse(note['date']),
            ))
        .toList();
    // return noteList;
    if (noteList.isNotEmpty)
      return noteList;
    else {
      return [];
    }
  }

  void addNote(Note note) {
    DBHelper.insert('user_notes', {
      'id': note.id,
      'title': note.title,
      'text': note.text,
      'date': note.date.toIso8601String(),
    });
  }

  void deleteNote(String id) {
    DBHelper.delete('user_notes', id);
  }
}
