import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../note/note.dart';
import '../notebook/notebook.dart';
import '../screens/notebook_list_screen.dart';

class ModalBottomSheet extends StatelessWidget {
  final String? notebookTitle;
  final Note? note;
  late final WidgetBuilder child;

  ModalBottomSheet.notebookMenu({
    required this.notebookTitle,
  }) : note = null {
    child = _notebookModalBottomSheetBuilder;
  }

  ModalBottomSheet.noteListMenu()
      : note = null,
        notebookTitle = null {
    child = _noteListModalBottomSheetBuilder;
  }

  ModalBottomSheet.trashListMenu()
      : note = null,
        notebookTitle = null {
    child = _trashListModalBottomSheetBuilder;
  }

  ModalBottomSheet.trashNoteMenu({required this.note}) : notebookTitle = null {
    child = _trashNoteModalBottomSheetBuilder;
  }

  ModalBottomSheet.noteMenu({required this.note}) : notebookTitle = null {
    child = _noteModalBottomSheetBuilder;
  }

  void _deleteNotebook(BuildContext context, String notebook) {
    context.read<NotebooksBloc>().add(RemoveNotebookEvent(notebook));
    Navigator.of(context).pushReplacementNamed(NotebookListScreen.routeName);
  }

  void _deleteNote(BuildContext context) {
    if (note != null) {
      var noteBloc = BlocProvider.of<NotesBloc>(context);
      noteBloc.add(RemoveNoteEvent(note!));
    }
  }

  void _moveNoteToTrash(BuildContext context) {
    if (note != null) {
      var noteBloc = BlocProvider.of<NotesBloc>(context);
      var notebookBloc = BlocProvider.of<NotebooksBloc>(context);
      noteBloc.add(MoveNoteToTrashEvent(note!));
      notebookBloc.add(RemoveNoteFromNotebookEvent(note!, note!.notebook));
    }
  }

  void _restoreNote(BuildContext context) {
    if (note != null) {
      context.read<NotesBloc>().add(RestoreNoteFromTrash(note!));
      context
          .read<NotebooksBloc>()
          .add(AddNoteToNotebookEvent(note!, note!.notebook));
    }
  }

  void _emptyTrash(BuildContext context) {
    context.read<NotesBloc>().add(EmptyTrash());
  }

  Widget _trashListModalBottomSheetBuilder(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(
            Icons.apps,
          ),
          title: Text(
            'View options',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(
            Icons.sort,
          ),
          title: Text(
            'Sort by',
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
            'Empty trash',
            style: TextStyle(
              fontSize: 16,
              color: Colors.red,
            ),
          ),
          onTap: () {
            _emptyTrash(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _noteListModalBottomSheetBuilder(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(
            Icons.apps,
          ),
          title: Text(
            'View options',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(
            Icons.sort,
          ),
          title: Text(
            'Sort by',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(
            Icons.filter_alt,
          ),
          title: Text(
            'Filter Notes',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _notebookModalBottomSheetBuilder(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(
            Icons.apps,
          ),
          title: Text(
            'View options',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(
            Icons.sort,
          ),
          title: Text(
            'Sort by',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(
            Icons.filter_alt,
          ),
          title: Text(
            'Filter Notes',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          onTap: () {},
        ),
        Divider(
          thickness: 3,
        ),
        ListTile(
          leading: Icon(
            Icons.edit,
          ),
          title: Text(
            'Rename notebook',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(
            Icons.delete,
            color: notebookTitle == 'Interesting' ? Colors.grey : Colors.red,
          ),
          title: Text(
            'Delete notebook',
            style: TextStyle(
              fontSize: 16,
              color: notebookTitle == 'Interesting' ? Colors.grey : Colors.red,
            ),
          ),
          enabled: notebookTitle == 'Interesting' ? false : true,
          onTap: () {
            _deleteNotebook(context, notebookTitle!);
          },
        ),
      ],
    );
  }

  Widget _trashNoteModalBottomSheetBuilder(BuildContext context) {
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
            _restoreNote(context);
            Navigator.pop(context);
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
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child(context),
    );
  }
}
