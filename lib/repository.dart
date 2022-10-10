import 'dart:developer';

import './note/note.dart';
import './notebook/notebook.dart';

class Repository {
  final NoteProvider _noteProvider = NoteProvider();
  final NotebookProvider _notebookProvider = NotebookProvider();

  final List<Note> noteList = [];
  final List<Notebook> notebookList = [];
  final List<Note> trashList = [];

  Future<void> getNotebooks() async {
    var nbList = await _notebookProvider.fetchNotebooks();
    notebookList.addAll(nbList);
  }

  Future<void> addNotebook(Notebook notebook) async {
    notebookList.add(notebook);
    await _notebookProvider.addNotebook(notebook);
  }

  void deleteNotebook(String notebookTitle) async {
    var notebook = notebookList.firstWhere((nb) => nb.title == notebookTitle);
    for (var note in notebook.noteList) {
      moveNoteToTrash(note, true);
    }

    notebookList.removeWhere((nb) => nb.id == notebook.id);
    await _notebookProvider.deleteNotebook(notebook.id);
  }

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

  Future<void> addNote(Note editedNote) async {
    if (notebookList.isEmpty) {
      await getNotebooks();
    }
    await _noteProvider.saveNote(editedNote);
    var noteIndex = noteList.indexWhere((note) => note.id == editedNote.id);
    var nbIndex =
        notebookList.indexWhere((nb) => nb.title == editedNote.notebook);
    if (noteIndex >= 0) {
      noteList[noteIndex] = editedNote;
      noteIndex = notebookList[nbIndex]
          .noteList
          .indexWhere((note) => note.id == editedNote.id);
      if (noteIndex >= 0) {
        notebookList[nbIndex].noteList[noteIndex] = editedNote;
      }
    } else {
      noteList.add(editedNote);
      notebookList[nbIndex].noteList.add(editedNote);
    }
  }

  Future<void> deleteNote(String id) async {
    await _noteProvider.deleteNote(id);
    trashList.removeWhere((note) => note.id == id);
  }

  ///Moves [note] to trash, [willNotebookDelete] should specified as true, when notebook from which is deleting [note], will also deleted
  void moveNoteToTrash(Note note, [bool willNotebookDelete = false]) async {
    if (notebookList.isEmpty) {
      await getNotebooks();
    }
    note.isInTrash = true;
    note.date = DateTime.now();

    if (!willNotebookDelete) {
      note.notebook = 'Interesting';
      var nbIndex = notebookList.indexWhere((nb) => nb.title == note.notebook);
      notebookList[nbIndex].noteList.removeWhere((n) => n.id == note.id);
    }
    trashList.add(note);
    noteList.removeWhere((n) => n.id == note.id);
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

  void emptyTrash() {
    trashList.clear();
    _noteProvider.emptyTrash();
  }
}
