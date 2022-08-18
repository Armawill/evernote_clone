import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/my_bottom_app_bar.dart';
import '../provider/note.dart';

class NoteDetailsScreen extends StatefulWidget {
  static const routeName = 'note-details';

  @override
  State<NoteDetailsScreen> createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  late FocusNode _focusText;
  late FocusNode _focusTitle;
  bool _isEditing = false;
  final _form = GlobalKey<FormState>();
  var editedNote = Note(id: null, title: '', text: '', date: DateTime.now());

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
    editModeOff();
    _form.currentState!.save();
    if (editedNote.id != null) {
      Provider.of<Notes>(context, listen: false).updateNote(editedNote);
    } else {
      if (editedNote.title.isEmpty) {
        editedNote = Note(
          id: editedNote.id,
          title: 'Untitled note',
          text: editedNote.text,
          date: editedNote.date,
        );
      }
      Provider.of<Notes>(context, listen: false).addNote(editedNote);
    }
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

  @override
  Widget build(BuildContext context) {
    final String noteId;
    if (ModalRoute.of(context)?.settings.arguments != null) {
      final noteId = ModalRoute.of(context)!.settings.arguments as String;
      editedNote = Provider.of<Notes>(context, listen: false).findById(noteId);
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
              onPressed: () {},
              icon: Icon(Icons.more_horiz),
            ),
          ],
        ),
        bottomNavigationBar: MyBottomAppBar(),
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
                    'Notebook',
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
