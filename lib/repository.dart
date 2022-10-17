import 'dart:developer';

import './note/note.dart';
import './notebook/notebook.dart';

const String interesting = 'Interesting';

class Repository {
  final NoteProvider _noteProvider = NoteProvider();
  final NotebookProvider _notebookProvider = NotebookProvider();

  final List<Note> noteList = [];
  final List<Notebook> notebookList = [];
  final List<Note> trashList = [];

  Future<void> getNotebooks() async {
    if (notebookList.isEmpty) {
      var nbList = await _notebookProvider.fetchNotebooks();
      notebookList.addAll(nbList);
    }
  }

  Future<void> addNotebook(Notebook notebook) async {
    notebookList.add(notebook);
    await _notebookProvider.saveNotebook(notebook);
  }

  void deleteNotebook(String notebookTitle) async {
    var notebook = notebookList.firstWhere((nb) => nb.title == notebookTitle);
    for (var noteId in notebook.noteIdList) {
      moveNoteToTrash(noteList.firstWhere((note) => note.id == noteId), true);
    }

    notebookList.removeWhere((nb) => nb.id == notebook.id);
    await _notebookProvider.deleteNotebook(notebook.id);
  }

  Future<void> renameNotebook(String id, String newTitle) async {
    var index = notebookList.indexWhere((nb) => nb.id == id);
    if (index >= 0) {
      notebookList[index].title = newTitle;
    }
    await _notebookProvider.saveNotebook(Notebook(id: id, title: newTitle));
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
    if (notebookList.isEmpty) {
      await getNotebooks();
    }
  }

  Future<Note> verifyNote(Note source, String nbTitle) async {
    String id = source.id, title = source.title, notebookId = source.notebookId;
    if (source.id.isEmpty) {
      id = DateTime.now().toString();
    }
    if (source.title.isEmpty) {
      title = 'Untitled note';
    }
    if (source.notebookId.isEmpty) {
      notebookId = notebookList.firstWhere((nb) => nb.title == nbTitle).id;
    }

    return Note(
        id: id,
        title: title,
        text: source.text,
        date: DateTime.now(),
        notebookId: notebookId);
  }

  Future<void> addNote(Note editedNote) async {
    var noteIndex = noteList.indexWhere((note) => note.id == editedNote.id);

    if (noteIndex >= 0) {
      noteList[noteIndex] = editedNote;
    } else {
      noteList.add(editedNote);
      var nbIndex =
          notebookList.indexWhere((nb) => nb.id == editedNote.notebookId);
      if (nbIndex >= 0) {
        notebookList[nbIndex].noteIdList.add(editedNote.id);
      }
    }
    await _noteProvider.saveNote(editedNote);
  }

  Future<void> deleteNote(String id) async {
    await _noteProvider.deleteNote(id);
    trashList.removeWhere((note) => note.id == id);
  }

  ///Moves [note] to trash, [willNotebookDelete] should specified as true, when notebook from which is deleting [note], will also deleted
  void moveNoteToTrash(Note note, [bool willNotebookDelete = false]) async {
    note.isInTrash = true;
    note.date = DateTime.now();

    if (!willNotebookDelete) {
      note.notebookId =
          notebookList.first.id; // It must be notebook with title 'Interesting'
      var nbIndex = notebookList.indexWhere((nb) => nb.id == note.notebookId);
      notebookList[nbIndex]
          .noteIdList
          .removeWhere((noteId) => noteId == note.id);
    }
    trashList.add(note);
    noteList.removeWhere((n) => n.id == note.id);
    _noteProvider.saveNote(note);
  }

  void restoreNote(Note note) async {
    note.isInTrash = false;
    note.date = DateTime.now();
    var nbIndex = notebookList.indexWhere((nb) => nb.id == note.notebookId);
    if (nbIndex >= 0) {
      await _noteProvider.saveNote(note);
      notebookList[nbIndex].noteIdList.add(note.id);
    } else {
      note.notebookId = notebookList.first.title; // Notebook 'Interesting'
      await _noteProvider.saveNote(note);
      notebookList.first.noteIdList.add(note.id);
    }
    trashList.removeWhere((n) => n.id == note.id);
    noteList.add(note);
  }

  void emptyTrash() {
    trashList.clear();
    _noteProvider.emptyTrash();
  }
}
