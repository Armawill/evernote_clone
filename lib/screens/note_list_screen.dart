import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../note/note.dart';
import '../widgets/app_drawer.dart';
import '../widgets/fade_on_scroll.dart';
import '../widgets/my_bottom_app_bar.dart';
import '../widgets/note_item.dart';
import './note_details_screen.dart';

class NoteListScreen extends StatelessWidget {
  static const routeName = '/note-list';

  final ScrollController scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
      // physics: BouncingScrollPhysics(),
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
              onPressed: () {},
              icon: Icon(Icons.more_horiz),
            ),
          ],
          title: FadeOnScroll(
            child: Text(
              notebook,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            scrollController: scrollController,
            fullOpacityOffset: 40,
            zeroOpacityOffset: 39,
          ),
          expandedHeight: 100,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            expandedTitleScale: 1.0,
            titlePadding: EdgeInsets.only(left: 20, bottom: 16),
            title: FadeOnScroll(
              scrollController: scrollController,
              fullOpacityOffset: 25,
              zeroOpacityOffset: 26,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: notebook,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.black)),
                    TextSpan(
                        text: notes.isNotEmpty ? ' (${notes.length})' : '',
                        style: TextStyle(fontSize: 18, color: Colors.grey)),
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

  @override
  Widget build(BuildContext context) {
    String notebook;
    try {
      notebook = ModalRoute.of(context)!.settings.arguments as String;
    } catch (err) {
      notebook = 'Notes';
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(),
      body: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          if (state is NotesInitialState) {
            return SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (state is NotesLoadedState) {
            state.loadedNotes.sort(
              (a, b) => b.date.compareTo(a.date),
            );
            List<Note> notes;
            if (notebook != 'Notes') {
              notes = state.loadedNotes
                  .where((note) => note.notebook == notebook)
                  .toList();
            } else {
              notes = state.loadedNotes;
            }

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
          if (state is NotesEmptyState) {
            return _buildCustomScrollView(
                context: context,
                child: SliverFillRemaining(
                  child: Center(
                    child: Text('No notes yet'),
                  ),
                ),
                notes: [],
                notebook: notebook);
          }
          if (state is NotesErrorState) {
            return _buildCustomScrollView(
                context: context,
                child: SliverFillRemaining(
                  child: Center(
                    child: Text('Something went wrong'),
                  ),
                ),
                notes: [],
                notebook: notebook);
          }
          return _buildCustomScrollView(
              context: context,
              child: SliverFillRemaining(
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
        label: Text('New'),
      ),
    );
  }
}
