import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';

import '../bloc/notes_bloc.dart';
import '../helpers/datetime_helper.dart';
import '../widgets/evernote_drawer.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: EvernoteDrawer(),
      body: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          if (state is NotesInitialState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is NotesLoadedState) {
            state.loadedNotes.sort(
              (a, b) => b.date.compareTo(a.date),
            );
            var notes = state.loadedNotes;
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
                      'Notes',
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
                                text: 'Notes',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: Colors.black)),
                            TextSpan(
                                text: ' (${notes.length})',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    ListTile.divideTiles(
                      tiles: notes
                          .map((note) => NoteItem(
                                key: ValueKey(note.id),
                                note: note,
                              ))
                          .toList(),
                      context: context,
                    ).toList(),
                  ),
                ),
              ],
            );
          }
          if (state is NotesEmptyState) {
            return Center(
              child: Text('No notes yet'),
            );
          }
          if (state is NotesErrorState) {
            return Center(
              child: Text('Something went wrong'),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomNavigationBar: MyBottomAppBar(_openDrawer),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed(NoteDetailsScreen.routeName);
        },
        elevation: 0,
        tooltip: 'Add note',
        icon: const Icon(Icons.add),
        label: Text('New'),
      ),
    );
  }
}
