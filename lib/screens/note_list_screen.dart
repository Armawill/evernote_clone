import 'dart:developer';

import 'package:evernote_clone/presentation/custom_icons_icons.dart';
import 'package:evernote_clone/repository.dart';
import 'package:evernote_clone/screens/notebook_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../note/note.dart';
import '../notebook/notebook.dart';
import '../widgets/app_drawer.dart';
import '../widgets/fade_on_scroll.dart';
import '../widgets/my_bottom_app_bar.dart';
import '../widgets/note_item.dart';
import './note_details_screen.dart';

const TRASH = 'Trash';
const NOTES = 'Notes';

class NoteListScreen extends StatelessWidget {
  static const routeName = '/note-list';

  final ScrollController scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _wasNotebookDelete = false;

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  Widget _buildCustomScrollView({
    required BuildContext context,
    required Widget child,
    required List<dynamic> notes,
    required String notebook,
  }) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverAppBar(
          leading: ModalRoute.of(context)!.canPop
              ? BackButton(
                  color: Theme.of(context).primaryColor,
                )
              : Container(),
          leadingWidth: ModalRoute.of(context)!.canPop ? 56 : 0,
          automaticallyImplyLeading: false,
          elevation: 1,
          actions: [
            IconButton(
              onPressed: () {
                showMoreActions(context, notebook);
              },
              icon: const Icon(Icons.more_horiz),
            ),
          ],
          title: FadeOnScroll(
            child: Text(
              notebook,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
            scrollController: scrollController,
            fullOpacityOffset: 40,
            zeroOpacityOffset: 39,
          ),
          expandedHeight: 100,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            expandedTitleScale: 1.0,
            titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
            title: FadeOnScroll(
              scrollController: scrollController,
              fullOpacityOffset: 25,
              zeroOpacityOffset: 26,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: notebook,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.black)),
                    TextSpan(
                        text: notes.isNotEmpty ? ' (${notes.length})' : '',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }

  void _deleteNotebook(BuildContext context, String notebook) {
    context.read<NotebooksBloc>().add(RemoveNotebookEvent(notebook));
    Navigator.of(context).pushReplacementNamed(NotebookListScreen.routeName);
  }

  Widget _trashModalBottomSheetBuilder(BuildContext context) {
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
            // _deleteNote(context);
            // Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _notesModalBottomSheetBuilder(BuildContext context) {
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

  Widget _notesInNotebookModalBottomSheetBuilder(
      BuildContext context, String notebook) {
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
            color: notebook == 'Interesting' ? Colors.grey : Colors.red,
          ),
          title: Text(
            'Delete notebook',
            style: TextStyle(
              fontSize: 16,
              color: notebook == 'Interesting' ? Colors.grey : Colors.red,
            ),
          ),
          enabled: notebook == 'Interesting' ? false : true,
          onTap: () {
            _deleteNotebook(context, notebook);
          },
        ),
      ],
    );
  }

  void showMoreActions(BuildContext ctx, String notebook) {
    showModalBottomSheet(
        context: ctx,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(ctx).size.height * 0.75,
        ),
        builder: (_) {
          if (notebook == TRASH) {
            return _trashModalBottomSheetBuilder(ctx);
          } else if (notebook == NOTES) {
            return _notesModalBottomSheetBuilder(ctx);
          } else {
            return _notesInNotebookModalBottomSheetBuilder(ctx, notebook);
          }
        }).then((_) {
      // if (_wasNotebookDelete) {
      //   Navigator.pop(ctx);
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    String notebook;
    try {
      notebook = ModalRoute.of(context)!.settings.arguments as String;
    } catch (err) {
      notebook = NOTES;
    }

    context.read<NotesBloc>().add(ShowNotesFromNotebook(notebook));

    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(),
      body: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if ((state.isNoteListNotEmpty && notebook != TRASH) ||
              (state.isTrashListNotEmpty && notebook == TRASH)) {
            List<Note> notes = state.loadedNotes;
            notes.sort(
              (a, b) => b.date.compareTo(a.date),
            );

            return _buildCustomScrollView(
                context: context,
                child: SliverList(
                  delegate: SliverChildListDelegate(
                    ListTile.divideTiles(
                      tiles: notes
                          .map((note) => NoteItem(
                                note,
                                notebook,
                              ))
                          .toList(),
                      context: context,
                    ).toList(),
                  ),
                ),
                notes: notes,
                notebook: notebook);
          }
          if ((state.isNoteListEmpty && notebook != TRASH) ||
              (state.isTrashListEmpty && notebook == TRASH)) {
            return _buildCustomScrollView(
                context: context,
                child: SliverFillRemaining(
                  child: LayoutBuilder(
                    builder: (context, constraints) => Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: constraints.maxHeight * 0.15),
                          child: Image.asset(
                            'assets/images/empty_note_list.png',
                            fit: BoxFit.cover,
                            height: constraints.maxHeight * 0.25,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 15),
                        const Text(
                          'No notes yet',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: constraints.maxWidth * 0.6,
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 16),
                              children: [
                                const TextSpan(text: 'Tap the '),
                                TextSpan(
                                    text: '+ New',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor)),
                                const TextSpan(
                                    text: ' button to create a note'),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                notes: [],
                notebook: notebook);
          }
          // if (state is NotesErrorState) {
          //   return _buildCustomScrollView(
          //       context: context,
          //       child: const SliverFillRemaining(
          //         child: Center(
          //           child: Text('Something went wrong'),
          //         ),
          //       ),
          //       notes: [],
          //       notebook: notebook);
          // }
          return _buildCustomScrollView(
              context: context,
              child: const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              notes: [],
              notebook: notebook);
        },
      ),
      bottomNavigationBar: AppBottomAppBar(_openDrawer),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed(NoteDetailsScreen.routeName,
              arguments: {'notebookTitle': notebook});
        },
        elevation: 0,
        tooltip: 'Add note',
        icon: const Icon(Icons.add),
        label: const Text('New'),
      ),
    );
  }
}
