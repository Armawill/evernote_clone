import 'dart:developer';

import 'package:evernote_clone/notebook/bloc/notebooks_bloc.dart';
import 'package:evernote_clone/widgets/app_floating_action_button.dart';
import 'package:evernote_clone/widgets/modal_bottom_sheet.dart';
import 'package:evernote_clone/widgets/top_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../note/note.dart';
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

  bool _wasMovedToTrash = false;

  bool _wasRestored = false;

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

  void showMoreActions(BuildContext ctx, String notebook) {
    showModalBottomSheet(
        context: ctx,
        shape: const RoundedRectangleBorder(
            borderRadius:
                const BorderRadius.vertical(top: const Radius.circular(10))),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(ctx).size.height * 0.75,
        ),
        builder: (_) {
          if (notebook == TRASH) {
            return ModalBottomSheet.trashListMenu();
          } else if (notebook == NOTES) {
            return ModalBottomSheet.noteListMenu();
          } else {
            return ModalBottomSheet.notebookMenu(
              notebookTitle: notebook,
            );
          }
        }).then((_) {});
  }

  @override
  Widget build(BuildContext context) {
    String notebookId, notebookTitle = '';

    if (ModalRoute.of(context)!.settings.arguments != null) {
      notebookId = ModalRoute.of(context)!.settings.arguments as String;
      var nbIndex = context
          .read<NotebooksBloc>()
          .state
          .loadedNotebooks
          .indexWhere((nb) => nb.id == notebookId);
      if (nbIndex >= 0) {
        var loadedNotebooks =
            context.select((NotebooksBloc bloc) => bloc.state.loadedNotebooks);
        notebookTitle = loadedNotebooks[nbIndex].title;
      } else {
        notebookTitle = TRASH;
      }
    } else {
      notebookTitle = NOTES;
    }
    // if (notebookTitle.isEmpty &&
    //     context.read<NotesBloc>().state.loadedNotes.first.isInTrash) {
    //   notebookTitle = TRASH;
    // }

    return Scaffold(
        key: _scaffoldKey,
        drawer: AppDrawer(),
        body: BlocConsumer<NotesBloc, NotesState>(
          listenWhen: (previous, current) {
            if ((previous.loadedNotes.length > current.loadedNotes.length) &&
                (previous.trashNotesList.length <
                    current.trashNotesList.length)) {
              _wasMovedToTrash = !_wasMovedToTrash;

              return true;
            } else if ((previous.loadedNotes.length >
                    current.loadedNotes.length) &&
                (previous.trashNotesList.length >
                    current.trashNotesList.length)) {
              _wasRestored = !_wasRestored;

              return true;
            } else {
              return false;
            }
          },
          listener: (context, state) {
            if (_wasMovedToTrash) {
              TopSnackBar.deleteNote(context).show(context);
            }
            if (_wasRestored) {
              TopSnackBar.restoreNote(context).show(context);
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return _buildCustomScrollView(
                context: context,
                child: const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                notes: [],
                notebook: notebookTitle,
              );
            }
            if ((state.isNoteListNotEmpty && notebookTitle != TRASH) ||
                (state.isTrashListNotEmpty && notebookTitle == TRASH)) {
              List<Note> notes;
              if (notebookTitle == TRASH) {
                notes = state.trashNotesList;
              } else {
                notes = state.loadedNotes;
              }

              notes.sort(
                (a, b) => b.dateUpdated.compareTo(a.dateUpdated),
              );

              return _buildCustomScrollView(
                  context: context,
                  child: SliverList(
                    delegate: SliverChildListDelegate(
                      ListTile.divideTiles(
                        tiles: notes
                            .map((note) => NoteItem(
                                  note,
                                  notebookTitle,
                                ))
                            .toList(),
                        context: context,
                      ).toList(),
                    ),
                  ),
                  notes: notes,
                  notebook: notebookTitle);
            }
            if ((state.isNoteListEmpty && notebookTitle != TRASH) ||
                (state.isTrashListEmpty && notebookTitle == TRASH)) {
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
                          const SizedBox(height: 15),
                          const Text(
                            'No notes yet',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
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
                                          color:
                                              Theme.of(context).primaryColor)),
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
                  notebook: notebookTitle);
            }
            return _buildCustomScrollView(
                context: context,
                child: const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                notes: [],
                notebook: notebookTitle);
          },
        ),
        bottomNavigationBar: AppBottomAppBar(_openDrawer),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: AppFloatingActionButton(
            notebookTitle: notebookTitle == TRASH ? 'Notes' : notebookTitle));
  }
}
