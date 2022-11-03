import 'dart:developer';

import 'package:evernote_clone/presentation/custom_icons_icons.dart';
import 'package:evernote_clone/repository.dart';
import 'package:evernote_clone/screens/note_list_screen.dart';
import 'package:evernote_clone/widgets/modal_bottom_sheet.dart';
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

  Future<void> _saveNote(BuildContext ctx, String nbTitle) async {
    var noteBloc = BlocProvider.of<NotesBloc>(ctx);
    var notebookBloc = BlocProvider.of<NotebooksBloc>(ctx);
    _form.currentState!.save();
    _editedNote =
        await context.read<Repository>().verifyNote(_editedNote, nbTitle);
    editModeOff();

    noteBloc.add(AddNoteEvent(_editedNote));
    notebookBloc.add(AddNoteToNotebookEvent(_editedNote));
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

  void showMoreActions(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        builder: (_) {
          return _editedNote.isInTrash
              ? ModalBottomSheet.trashNoteMenu(note: _editedNote)
              : ModalBottomSheet.noteMenu(note: _editedNote);
        }).then((_) {});
  }

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    String notebookTitle = '';
    if (ModalRoute.of(context)?.settings.arguments != null) {
      var data =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      var note = data['note'];
      var nbTitle = data['notebookTitle'];
      if (note is Note) {
        _editedNote = note;
      }

      if (nbTitle is String) {
        if (nbTitle == 'Notes') {
          nbTitle = 'Interesting';
        }
        notebookTitle = nbTitle;
        var nbList = List.from(context.read<Repository>().notebookList);
        var nbIndex = nbList.indexWhere((nb) => nb.title == nbTitle);
        if (nbIndex >= 0) {
          _editedNote.notebookId = nbList[nbIndex].id;
        } else {
          log('Error in NoteDetailsScreen');
        }
      }
    }

    if (notebookTitle.isEmpty && !_editedNote.isInTrash) {
      var nbList = List.from(context.read<Repository>().notebookList);
      var nbIndex = nbList.indexWhere((nb) => nb.id == _editedNote.notebookId);
      notebookTitle = nbList[nbIndex].title;
    }

    return WillPopScope(
      onWillPop: () async {
        if (_isEditing) {
          _saveNote(context, notebookTitle);
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
                    _saveNote(context, notebookTitle);
                  },
                  icon: Icon(
                    Icons.check,
                  )),
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                showMoreActions(context);
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
                    _editedNote.isInTrash ? TRASH : notebookTitle,
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
                        dateCreated: _editedNote.dateCreated,
                        dateUpdated: _editedNote.dateUpdated,
                        dateDeleted: _editedNote.dateDeleted,
                        notebookId: _editedNote.notebookId,
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
                        dateCreated: _editedNote.dateCreated,
                        dateUpdated: _editedNote.dateUpdated,
                        dateDeleted: _editedNote.dateDeleted,
                        notebookId: _editedNote.notebookId,
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
                : const Icon(Icons.edit),
            label: _editedNote.isInTrash
                ? const Text('View only')
                : const Text('Edit'),
          ),
        ),
      ),
    );
  }
}
