import 'dart:developer';

import 'package:evernote_clone/presentation/custom_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../note/note.dart';
import '../notebook/bloc/notebooks_bloc.dart';
import '../widgets/app_drawer.dart';
import '../widgets/my_bottom_app_bar.dart';

const TRASH = 'Trash';

class NoteDetailsScreen extends StatefulWidget {
  static const routeName = '/note-details';

  @override
  State<NoteDetailsScreen> createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  late FocusNode _focusText;
  late FocusNode _focusTitle;
  bool _isEditing = false;
  bool _wasDeletedOrRestored = false;
  final _form = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _editedNote = Note.empty();

  @override
  void initState() {
    super.initState();
    _focusText = FocusNode();
    _focusTitle = FocusNode();
  }

  @override
  void dispose() {
    _focusTitle.dispose();
    _focusText.dispose();
    super.dispose();
  }

  void _saveNote(BuildContext ctx) {
    var noteBloc = BlocProvider.of<NotesBloc>(ctx);
    var notebookBloc = BlocProvider.of<NotebooksBloc>(ctx);
    editModeOff();
    _form.currentState!.save();
    _editedNote.date = DateTime.now();
    noteBloc.add(AddNoteEvent(_editedNote));
    notebookBloc.add(AddNoteToNotebookEvent(_editedNote, _editedNote.notebook));
  }

  void _deleteNote(BuildContext ctx) {
    var noteBloc = BlocProvider.of<NotesBloc>(ctx);
    setState(() {
      _wasDeletedOrRestored = true;
    });
    noteBloc.add(RemoveNoteEvent(_editedNote));
  }

  void _moveNoteToTrash(BuildContext ctx) {
    var noteBloc = BlocProvider.of<NotesBloc>(ctx);
    var notebookBloc = BlocProvider.of<NotebooksBloc>(ctx);
    setState(() {
      _wasDeletedOrRestored = true;
    });
    noteBloc.add(MoveNoteToTrashEvent(_editedNote));
    notebookBloc
        .add(RemoveNoteFromNotebookEvent(_editedNote, _editedNote.notebook));
  }

  void _restoreNote(BuildContext ctx, Note editedNote) {
    setState(() {
      _wasDeletedOrRestored = true;
    });
    context.read<NotesBloc>().add(RestoreNoteFromTrash(editedNote));
    context
        .read<NotebooksBloc>()
        .add(AddNoteToNotebookEvent(editedNote, editedNote.notebook));
  }

  void editModeOn() {
    setState(() {
      _isEditing = true;
    });
  }

  void editModeOff() {
    setState(() {
      _isEditing = false;
    });
  }

  Widget _trashModalBottomSheetBuilder(BuildContext context, Note editedNote) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(
            Icons.find_in_page_outlined,
          ),
          title: Text(
            'Find in note',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(
            Icons.restart_alt,
          ),
          title: Text(
            'Restore',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          onTap: () {
            _restoreNote(context, editedNote);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          title: Text(
            'Delete note forever',
            style: TextStyle(
              fontSize: 16,
              color: Colors.red,
            ),
          ),
          onTap: () {
            _deleteNote(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _noteModalBottomSheetBuilder(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(
            Icons.find_in_page_outlined,
          ),
          title: Text(
            'Find in note',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          title: Text(
            'Move to trash',
            style: TextStyle(
              fontSize: 16,
              color: Colors.red,
            ),
          ),
          onTap: () {
            _moveNoteToTrash(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  void showMoreActions(BuildContext ctx, Note editedNote) {
    showModalBottomSheet(
        context: ctx,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: editedNote.isInTrash
                ? _trashModalBottomSheetBuilder(context, editedNote)
                : _noteModalBottomSheetBuilder(context),
          );
        }).then((_) {
      if (_wasDeletedOrRestored) {
        Navigator.pop(context);
      }
    });
  }

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final Note note;
    if (ModalRoute.of(context)?.settings.arguments != null) {
      var data =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      var note = data['note'];
      var nbTitle = data['notebookTitle'];
      if (note is Note) {
        _editedNote = note;
      } else {
        if (nbTitle is String) {
          // if (nbTitle == 'Notes') {
          //   nbTitle = 'Interesting';
          // }
          _editedNote = Note(
            id: _editedNote.id,
            title: _editedNote.title,
            text: _editedNote.text,
            date: _editedNote.date,
            notebook: nbTitle,
          );
        }
      }
    }
    return WillPopScope(
      onWillPop: () async {
        if (_isEditing) {
          _saveNote(context);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: AppDrawer(),
        appBar: AppBar(
          leading: !_isEditing
              ? BackButton(
                  color: Theme.of(context).primaryColor,
                )
              : IconButton(
                  onPressed: () {
                    _saveNote(context);
                  },
                  icon: Icon(
                    Icons.check,
                  )),
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                showMoreActions(context, _editedNote);
              },
              icon: Icon(Icons.more_horiz),
            ),
          ],
        ),
        bottomNavigationBar: AppBottomAppBar(_openDrawer),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Icon(
                    _editedNote.isInTrash
                        ? Icons.delete
                        : CustomIcons.notebook_filled,
                    color: Colors.grey[400],
                  ),
                  Text(
                    _editedNote.isInTrash ? TRASH : _editedNote.notebook,
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
            Form(
              key: _form,
              child: Column(
                children: [
                  TextFormField(
                    enabled: _editedNote.isInTrash ? false : true,
                    initialValue: _editedNote.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    decoration: InputDecoration(
                      hintText: 'Title',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                    onSaved: (value) {
                      _editedNote = Note(
                        id: _editedNote.id,
                        title: value!,
                        text: _editedNote.text,
                        date: _editedNote.date,
                        notebook: _editedNote.notebook,
                      );
                      _focusTitle.unfocus();
                    },
                    onTap: editModeOn,
                    focusNode: _focusTitle,
                  ),
                  TextFormField(
                    enabled: _editedNote.isInTrash ? false : true,
                    initialValue: _editedNote.text,
                    decoration: InputDecoration(
                      hintText: 'Start writing',
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                    maxLines: null,
                    focusNode: _focusText,
                    onSaved: (value) {
                      _editedNote = Note(
                        id: _editedNote.id,
                        title: _editedNote.title,
                        text: value!,
                        date: _editedNote.date,
                        notebook: _editedNote.notebook,
                      );
                      _focusText.unfocus();
                    },
                    onTap: editModeOn,
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Visibility(
          visible: !_isEditing,
          child: FloatingActionButton.extended(
            onPressed: _editedNote.isInTrash
                ? null
                : () {
                    editModeOn();
                    _focusText.requestFocus();
                  },
            backgroundColor:
                _editedNote.isInTrash ? Colors.grey[300] : Colors.blue[700],
            foregroundColor:
                _editedNote.isInTrash ? Colors.grey[600] : Colors.white,
            elevation: 0,
            icon: _editedNote.isInTrash
                ? const Icon(Icons.remove_red_eye_outlined)
                : Icon(Icons.edit),
            label:
                _editedNote.isInTrash ? const Text('View only') : Text('Edit'),
          ),
        ),
      ),
    );
  }
}
