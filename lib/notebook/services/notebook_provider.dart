import '../../helpers/db_helper.dart';
import '../../note/note.dart';
import '../notebook.dart';

class NotebookProvider {
  Future<List<Notebook>> fetchNotebooks() async {
    try {
      final notebookData = await DBHelper.getNotebooks('user_notebooks');
      final notebooksLoaded = notebookData
          .map((nb) => Notebook(
                id: nb['id'],
                title: nb['title'],
              ))
          .toList();
      for (int i = 0; i < notebooksLoaded.length; i++) {
        final data = await DBHelper.getNotesForNotebook(
            'user_notes', notebooksLoaded[i].title);
        final noteList = data
            .map((note) => Note(
                  id: note['id'],
                  title: note['title'],
                  text: note['text'],
                  date: DateTime.parse(note['date']),
                  notebook: note['notebook'],
                ))
            .toList();

        notebooksLoaded[i].noteList.addAll(noteList);
      }
      return notebooksLoaded;
    } catch (err) {
      return [];
    }
  }

  Future<void> addNotebook(Notebook notebook) async {
    try {
      DBHelper.insert('user_notebooks', {
        'id': notebook.id,
        'title': notebook.title,
      });
    } catch (err) {
      throw (err);
    }
  }
}
