import './notebook/services/notebook_provider.dart';
import './note/services/note_provider.dart';
import './note/models/note.dart';
import './notebook/models/notebook.dart';

class Repository {
  final NoteProvider _noteProvider = NoteProvider();
  final NotebookProvider _notebookProvider = NotebookProvider();

  final List<Note> noteList = [];
  final List<Notebook> notebookList = [];

  Future<void> getNotes() async {
    var nlist = await _noteProvider.fetchNotes();
    noteList.addAll(nlist);
  }

  Future<void> getNotebooks() async {
    var nbList = await _notebookProvider.fetchNotebooks();
    notebookList.addAll(nbList);
  }

  Future<void> addNote(Note editedNote) async {
    await _noteProvider.addNote(editedNote);

    // final nbIndex = notebookList
    //     .indexWhere((notebook) => notebook.title == editedNote.notebook);
    // if (nbIndex >= 0) {
    //   final noteIndex = notebookList[nbIndex]
    //       .noteList
    //       .indexWhere((note) => note.id == editedNote.id);
    //   if (noteIndex >= 0) {
    //     notebookList[nbIndex].noteList[noteIndex] = editedNote;
    //   } else {
    //     notebookList[nbIndex].noteList.add(editedNote);
    //   }
    // }
  }

  Future<void> deleteNote(String id) async {
    await _noteProvider.deleteNote(id);
  }

  Future<void> addNotebook(Notebook notebook) async {
    notebookList.add(notebook);
    await _notebookProvider.addNotebook(notebook);
  }
}
