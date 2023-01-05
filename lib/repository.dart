import 'dart:developer';

import './note/note.dart';
import './notebook/notebook.dart';

const String interesting = 'Interesting';

class Repository {
  final NoteProvider _noteProvider = NoteProvider();
  final NotebookProvider _notebookProvider = NotebookProvider();

  /// [noteList] is a list of all notes, except notes where isInTrash is true
  final List<Note> noteList = [];

  /// [notebookList] is a list of notebooks
  final List<Notebook> notebookList = [];

  /// [trashList] is a list of notes where [isInTrash] is true
  final List<Note> trashList = [];

  Future<void> getNotebooks() async {
    if (notebookList.isEmpty) {
      var nbList = await _notebookProvider.fetchNotebooks();
      notebookList.addAll(nbList);
    }
  }

  Future<void> saveNotebook(Notebook notebook) async {
    final nbIndex = notebookList.indexWhere((nb) => nb.id == notebook.id);
    if (nbIndex < 0) {
      notebookList.add(notebook);
    } else {
      notebookList[nbIndex] = notebook;
    }

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
    DateTime dateCreated, dateUpdated;
    if (index >= 0) {
      notebookList[index].title = newTitle;
      dateCreated = notebookList[index].dateCreated;
      dateUpdated = DateTime.now();
    } else {
      log('Error in repository.dart - renameNotebook');
      throw ('Error in repository.dart - renameNotebook');
    }
    await _notebookProvider.saveNotebook(Notebook(
      id: id,
      title: newTitle,
      dateCreated: dateCreated,
      dateUpdated: dateUpdated,
    ));
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
        dateCreated: source.dateCreated,
        dateUpdated: DateTime.now(),
        dateDeleted: source.dateDeleted,
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
    var editedNote = Note(
      id: note.id,
      title: note.title,
      text: note.text,
      dateCreated: note.dateCreated,
      dateUpdated: note.dateUpdated,
      dateDeleted: DateTime.now(),
      notebookId: note.notebookId,
      isInTrash: true,
    );

    if (willNotebookDelete) {
      editedNote.notebookId =
          notebookList.first.id; // It must be notebook with title 'Interesting'
    } else {
      var nbIndex =
          notebookList.indexWhere((nb) => nb.id == editedNote.notebookId);
      notebookList[nbIndex]
          .noteIdList
          .removeWhere((noteId) => noteId == editedNote.id);
    }
    trashList.add(editedNote);
    noteList.removeWhere((n) => n.id == editedNote.id);
    _noteProvider.saveNote(editedNote);
  }

  void restoreNote(Note note) async {
    var editedNote = Note(
      id: note.id,
      title: note.title,
      text: note.text,
      dateCreated: note.dateCreated,
      dateUpdated: DateTime.now(),
      dateDeleted: null,
      notebookId: note.notebookId,
      isInTrash: false,
    );
    var nbIndex =
        notebookList.indexWhere((nb) => nb.id == editedNote.notebookId);
    if (nbIndex >= 0) {
      notebookList[nbIndex].noteIdList.add(editedNote.id);
    } else {
      editedNote.notebookId = notebookList.first.id; // Notebook 'Interesting'
      notebookList.first.noteIdList.add(editedNote.id);
    }
    await _noteProvider.saveNote(editedNote);
    trashList.removeWhere((n) => n.id == editedNote.id);
    noteList.add(editedNote);
  }

  void emptyTrash() {
    trashList.clear();
    _noteProvider.emptyTrash();
  }
}
