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
    if (notebookList.isEmpty) {
      await getNotebooks();
    }
    await _noteProvider.saveNote(editedNote);
    noteList.add(editedNote);
    var nbIndex =
        notebookList.indexWhere((nb) => nb.title == editedNote.notebook);
    notebookList[nbIndex].noteList.add(editedNote);
  }

  Future<void> deleteNote(String id) async {
    await _noteProvider.deleteNote(id);
    trashList.removeWhere((note) => note.id == id);
  }

  Future<void> addNotebook(Notebook notebook) async {
    notebookList.add(notebook);
    await _notebookProvider.addNotebook(notebook);
  }

  void moveNoteToTrash(Note note) async {
    if (notebookList.isEmpty) {
      await getNotebooks();
    }
    note.isInTrash = true;
    note.date = DateTime.now();
    trashList.add(note);
    noteList.removeWhere((n) => n.id == note.id);
    var nbIndex = notebookList.indexWhere((nb) => nb.title == note.notebook);
    notebookList[nbIndex].noteList.removeWhere((n) => n.id == note.id);
    _noteProvider.saveNote(note);
  }

  void restoreNote(Note note) async {
    if (notebookList.isEmpty) {
      await getNotebooks();
    }
    note.isInTrash = false;
    note.date = DateTime.now();
    var nbIndex = notebookList.indexWhere((nb) => nb.title == note.notebook);
    if (nbIndex >= 0) {
      await _noteProvider.saveNote(note);
      notebookList[nbIndex].noteList.add(note);
    } else {
      await _noteProvider.saveNote(note);
      note.notebook = notebookList.first.title; // Notebook 'Interesting'
      notebookList.first.noteList.add(note);
    }
    trashList.removeWhere((n) => n.id == note.id);
    noteList.add(note);
  }
}
