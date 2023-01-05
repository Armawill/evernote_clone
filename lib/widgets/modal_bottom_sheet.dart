import 'package:evernote_clone/helpers/screen_arguments.dart';
import 'package:evernote_clone/presentation/custom_icons_icons.dart';
import 'package:evernote_clone/screens/add_notebook_screen.dart';
import 'package:evernote_clone/screens/note_details_screen.dart';
import 'package:evernote_clone/screens/note_info_screen.dart';
import 'package:evernote_clone/screens/note_list_screen.dart';
import 'package:evernote_clone/widgets/sort_by_expansion_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';

import '../note/note.dart';
import '../notebook/notebook.dart';
import '../screens/notebook_list_screen.dart';

class ModalBottomSheet extends StatelessWidget {
  final String? notebookTitle;
  final Note? note;
  late final WidgetBuilder child;

  ModalBottomSheet.noteMenu({required this.note}) : notebookTitle = null {
    child = _noteSheetBuilder;
  }

  ModalBottomSheet.noteListMenu()
      : note = null,
        notebookTitle = null {
    child = _noteListSheetBuilder;
  }

  ModalBottomSheet.notebookMenu({
    required this.notebookTitle,
  }) : note = null {
    child = _notebookSheetBuilder;
  }

  ModalBottomSheet.notebookListMenu()
      : note = null,
        notebookTitle = null {
    child = _notebookListSheetBuilder;
  }

  ModalBottomSheet.trashListMenu()
      : note = null,
        notebookTitle = null {
    child = _trashListSheetBuilder;
  }

  ModalBottomSheet.trashNoteMenu({required this.note}) : notebookTitle = null {
    child = _trashNoteSheetBuilder;
  }

  ModalBottomSheet.noteListWidgetMenu()
      : note = null,
        notebookTitle = null {
    child = _noteListWidgetSheetBuilder;
  }

  void _deleteNotebook(BuildContext context, String notebook) {
    Navigator.of(context).pushReplacementNamed(NotebookListScreen.routeName);
    context.read<NotebooksBloc>().add(RemoveNotebookEvent(notebook));
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
      notebookBloc.add(RemoveNoteFromNotebookEvent(note!));
    }
  }

  void _restoreNote(BuildContext context) {
    if (note != null) {
      context.read<NotesBloc>().add(RestoreNoteFromTrash(note!));
      context.read<NotebooksBloc>().add(AddNoteToNotebookEvent(note!));
    }
  }

  void _emptyTrash(BuildContext context) {
    context.read<NotesBloc>().add(EmptyTrash());
  }

  Widget _buildListTile({
    required BuildContext context,
    required IconData icon,
    required String text,
    Color color = Colors.black,
    bool enabled = true,
    required Function() func,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        text,
        style: TextStyle(fontSize: 16, color: color),
      ),
      enabled: enabled,
      onTap: () {
        func();
      },
    );
  }

  Widget _noteSheetBuilder(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildListTile(
          context: context,
          icon: Icons.info_outline,
          text: 'Note info',
          func: () {
            Navigator.of(context).pushNamed(NoteInfoScreen.routeName,
                arguments: ScreenArguments(note!.id));
          },
        ),
        _buildListTile(
          context: context,
          icon: Icons.find_in_page_outlined,
          text: 'Find in note',
          func: () {},
        ),
        _buildListTile(
          context: context,
          icon: Icons.delete,
          text: 'Move to trash',
          color: Colors.red,
          func: () {
            _moveNoteToTrash(context);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _noteListSheetBuilder(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildListTile(
          context: context,
          icon: Icons.apps,
          text: 'View options',
          func: () {},
        ),
        SortByExpansionPanel(
          blocType: BlocType.notesBloc,
        ),
        _buildListTile(
          context: context,
          icon: Icons.filter_alt,
          text: 'Filter Notes',
          func: () {},
        ),
      ],
    );
  }

  Widget _notebookSheetBuilder(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildListTile(
          context: context,
          icon: Icons.apps,
          text: 'View options',
          func: () {},
        ),
        SortByExpansionPanel(blocType: BlocType.notesBloc),
        _buildListTile(
          context: context,
          icon: Icons.filter_alt,
          text: 'Filter Notes',
          func: () {},
        ),
        const Divider(
          thickness: 3,
        ),
        _buildListTile(
          context: context,
          icon: Icons.edit,
          text: 'Rename notebook',
          func: () {
            Navigator.of(context).pushNamed(
              AddNotebookScreen.routeName,
              arguments: notebookTitle,
            );
          },
        ),
        _buildListTile(
          context: context,
          icon: Icons.delete,
          text: 'Delete notebook',
          color: notebookTitle == 'Interesting' ? Colors.grey : Colors.red,
          enabled: notebookTitle == 'Interesting' ? false : true,
          func: () {
            _deleteNotebook(context, notebookTitle!);
          },
        ),
      ],
    );
  }

  Widget _notebookListSheetBuilder(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildListTile(
          context: context,
          icon: CustomIcons.add_notebook_filled,
          text: 'New notebook',
          func: () {},
        ),
        SortByExpansionPanel(blocType: BlocType.notebooksBloc),
        _buildListTile(
          context: context,
          icon: Icons.settings,
          text: 'Notebooks settings',
          func: () {},
        ),
      ],
    );
  }

  Widget _trashNoteSheetBuilder(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildListTile(
          context: context,
          icon: Icons.find_in_page_outlined,
          text: 'Find in note',
          func: () {},
        ),
        _buildListTile(
          context: context,
          icon: Icons.restart_alt,
          text: 'Restore',
          func: () {
            _restoreNote(context);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
        _buildListTile(
          context: context,
          icon: Icons.delete,
          text: 'Delete note forever',
          color: Colors.red,
          func: () {
            _deleteNote(context);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _trashListSheetBuilder(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildListTile(
          context: context,
          icon: Icons.apps,
          text: 'View options',
          func: () {},
        ),
        SortByExpansionPanel(
          isTrash: true,
          blocType: BlocType.notesBloc,
        ),
        _buildListTile(
          context: context,
          icon: Icons.delete,
          text: 'Empty trash',
          color: Colors.red,
          func: () {
            _emptyTrash(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _noteListWidgetSheetBuilder(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildListTile(
          context: context,
          icon: Icons.arrow_forward_ios,
          text: 'Go to Notes',
          func: () {
            Navigator.pop(context);
            Navigator.of(context).pushNamed(NoteListScreen.routeName);
          },
        ),
        _buildListTile(
          context: context,
          icon: CustomIcons.add_note_filled,
          text: 'Create new note',
          func: () {
            Navigator.pop(context);
            Navigator.of(context).pushNamed(NoteDetailsScreen.routeName,
                arguments: {'notebookTitle': 'Notes'});
          },
        ),
        _buildListTile(
          context: context,
          icon: Icons.remove_circle_outline,
          text: 'Remove widget',
          color: Colors.red,
          func: () {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: child(context),
    );
  }
}
