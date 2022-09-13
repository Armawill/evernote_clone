import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../note/note.dart';
import '../notebook/bloc/notebooks_bloc.dart';
import '../widgets/app_drawer.dart';
import '../widgets/my_bottom_app_bar.dart';

class NoteDetailsScreen extends StatefulWidget {
  static const routeName = '/note-details';

  @override
  State<NoteDetailsScreen> createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  late FocusNode _focusText;
  late FocusNode _focusTitle;
  bool _isEditing = false;
  bool _wasDelete = false;
  final _form = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var editedNote = Note(
    id: '',
    title: '',
    text: '',
    date: DateTime.now(),
    notebook: 'Interesting',
  );

  @override
  void initState() {
    super.initState();

    _focusText = FocusNode();
    _focusTitle = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _focusTitle.dispose();
    _focusText.dispose();
  }

  void _saveNote(BuildContext ctx) {
    var noteBloc = BlocProvider.of<NotesBloc>(ctx);
    var notebookBloc = BlocProvider.of<NotebooksBloc>(ctx);
    editModeOff();
    _form.currentState!.save();
    if (editedNote.title.isEmpty) {
      editedNote = Note(
        id: editedNote.id,
        title: 'Untitled note',
        text: editedNote.text,
        date: editedNote.date,
        notebook: editedNote.notebook,
      );
    }
    if (editedNote.id.isEmpty) {
      editedNote = Note(
        id: DateTime.now().toString(),
        title: editedNote.title,
        text: editedNote.text,
        date: editedNote.date,
        notebook: editedNote.notebook,
      );
    }
    editedNote = Note(
      id: editedNote.id,
      title: editedNote.title,
      text: editedNote.text,
      date: DateTime.now(),
      notebook: editedNote.notebook,
    );
    noteBloc.add(AddNoteEvent(editedNote));
    notebookBloc.add(UpdateNotebookEvent(editedNote, editedNote.notebook));
  }

  void _deleteNote(BuildContext ctx) {
    var noteBloc = BlocProvider.of<NotesBloc>(ctx);
    setState(() {
      _wasDelete = true;
    });
    noteBloc.add(RemoveNoteEvent(editedNote));
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

  void showMoreActions() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: Column(
              children: [
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Icon(Icons.delete),
                        SizedBox(width: 15),
                        Text(
                          'Delete',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    _deleteNote(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        }).then((_) {
      if (_wasDelete) {
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
        editedNote = note;
      } else {
        if (nbTitle is String) {
          if (nbTitle == 'Notes') {
            nbTitle = 'Interesting';
          }
          editedNote = Note(
            id: editedNote.id,
            title: editedNote.title,
            text: editedNote.text,
            date: editedNote.date,
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
              onPressed: showMoreActions,
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
                    Icons.book,
                    color: Colors.grey[400],
                  ),
                  Text(
                    editedNote.notebook,
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
                    initialValue: editedNote.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    decoration: InputDecoration(
                      hintText: 'Title',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                    onSaved: (value) {
                      editedNote = Note(
                        id: editedNote.id,
                        title: value!,
                        text: editedNote.text,
                        date: editedNote.date,
                        notebook: editedNote.notebook,
                      );
                      _focusTitle.unfocus();
                    },
                    onTap: editModeOn,
                    focusNode: _focusTitle,
                  ),
                  TextFormField(
                    initialValue: editedNote.text,
                    decoration: InputDecoration(
                      hintText: 'Start writing',
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                    maxLines: null,
                    focusNode: _focusText,
                    onSaved: (value) {
                      editedNote = Note(
                        id: editedNote.id,
                        title: editedNote.title,
                        text: value!,
                        date: editedNote.date,
                        notebook: editedNote.notebook,
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
            onPressed: () {
              editModeOn();
              _focusText.requestFocus();
            },
            backgroundColor: Colors.blue[700],
            elevation: 0,
            icon: const Icon(Icons.edit),
            label: Text('Edit'),
          ),
        ),
      ),
    );
  }
}
