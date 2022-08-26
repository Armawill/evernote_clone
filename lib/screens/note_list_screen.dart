import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/notes_bloc.dart';
import '../helpers/datetime_helper.dart';
import '../widgets/fade_on_scroll.dart';
import '../widgets/my_bottom_app_bar.dart';
import './note_details_screen.dart';

class NoteListScreen extends StatefulWidget {
  static const routeName = '/note-list';

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          if (state is NotesInitialState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is NotesLoadedState) {
            var notes = state.loadedNotes;
            return CustomScrollView(
              controller: scrollController,
              // physics: BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
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
                  delegate: SliverChildBuilderDelegate(
                    (context, int index) {
                      return Container(
                        child: Card(
                          elevation: 0,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  NoteDetailsScreen.routeName,
                                  arguments: notes[index]);
                            },
                            splashFactory: NoSplash.splashFactory,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              height: MediaQuery.of(context).size.height * 0.25,
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Text(
                                          notes[index].title,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                      Text(
                                        overflow: TextOverflow.ellipsis,
                                        notes[index].text,
                                        style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 15),
                                        maxLines: 6,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    DateTimeHelper.getDate(notes[index].date),
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: notes.length,
                  ),
                )
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
      bottomNavigationBar: const MyBottomAppBar(),
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
