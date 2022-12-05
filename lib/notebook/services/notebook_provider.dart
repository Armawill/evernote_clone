import 'dart:developer';

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
                dateCreated: DateTime.parse(nb['dateCreated']),
                dateUpdated: DateTime.parse(nb['dateUpdated']),
              ))
          .toList();
      for (int i = 0; i < notebooksLoaded.length; i++) {
        final data = await DBHelper.getNotesForNotebook(
            'user_notes', notebooksLoaded[i].id);
        final noteList = data
            .map(
              (note) => Note(
                id: note['id'],
                title: note['title'],
                text: note['text'],
                dateCreated: DateTime.parse(note['dateCreated']),
                dateUpdated: DateTime.parse(note['dateUpdated']),
                dateDeleted: note['dateDeleted'] == 'null'
                    ? null
                    : DateTime.parse(note['dateDeleted']),
                notebookId: note['notebookId'],
                isInTrash: note['isInTrash'] == 0 ? false : true,
              ),
            )
            .toList();
        noteList.removeWhere((note) => note.isInTrash);
        List<String> noteIdList = [];
        for (var note in noteList) {
          noteIdList.add(note.id);
        }

        notebooksLoaded[i].noteIdList.addAll(noteIdList);
      }
      return notebooksLoaded;
    } catch (err) {
      log('$err');
      return [];
    }
  }

  Future<void> saveNotebook(Notebook notebook) async {
    try {
      DBHelper.insert('user_notebooks', {
        'id': notebook.id,
        'title': notebook.title,
        'dateCreated': notebook.dateCreated.toIso8601String(),
        'dateUpdated': notebook.dateUpdated.toIso8601String(),
      });
    } catch (err) {
      log('$err');
      throw (err);
    }
  }

  Future<void> deleteNotebook(String id) async {
    try {
      DBHelper.delete('user_notebooks', id);
    } catch (err) {
      log('$err');
      throw (err);
    }
  }
}
