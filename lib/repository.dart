import 'dart:developer';

import './note/note.dart';
import './notebook/notebook.dart';

class Repository {
  final NoteProvider _noteProvider = NoteProvider();
  final NotebookProvider _notebookProvider = NotebookProvider();

  final List<Note> noteList = [];
  final List<Notebook> notebookList = [];
  final List<Note> trashList = [];

  Future<void> getNotes() async {
    var nlist = await _noteProvider.fetchNotes();
    noteList.addAll(nlist);
    noteList.removeWhere(
      (note) {
        if (note.isInTrash) {
          trashList.add(note);
        }
        return note.isInTrash;
      },
    );
  }

  Future<void> getNotebooks() async {
    var nbList = await _notebookProvider.fetchNotebooks();
    notebookList.addAll(nbList);
  }

  Future<void> addNote(Note editedNote) async {
    await _noteProvider.addNote(editedNote);
    noteList.add(editedNote);
  }

  Future<void> deleteNote(String id) async {
    await _noteProvider.deleteNote(id);
    trashList.removeWhere((note) => note.id == id);
  }

  Future<void> addNotebook(Notebook notebook) async {
    notebookList.add(notebook);
    await _notebookProvider.addNotebook(notebook);
  }

  void addToTrash(Note note) {
    trashList.add(noteList.firstWhere((n) => n.id == note.id));
    noteList.removeWhere((n) => n.id == note.id);
    var nbIndex = notebookList.indexWhere((nb) => nb.title == note.notebook);
    notebookList[nbIndex].noteList.removeWhere((n) => n.id == note.id);
    _noteProvider.addToTrash(note);
  }
}
