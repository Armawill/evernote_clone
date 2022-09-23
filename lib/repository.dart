import './note/note.dart';
import './notebook/notebook.dart';

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
  }

  Future<void> deleteNote(String id) async {
    await _noteProvider.deleteNote(id);
  }

  Future<void> addNotebook(Notebook notebook) async {
    notebookList.add(notebook);
    await _notebookProvider.addNotebook(notebook);
  }
}
