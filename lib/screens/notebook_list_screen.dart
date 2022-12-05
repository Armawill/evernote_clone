import 'dart:developer';

import 'package:evernote_clone/presentation/custom_icons_icons.dart';
import 'package:evernote_clone/widgets/app_floating_action_button.dart';
import 'package:evernote_clone/widgets/modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../note/note.dart';
import '../notebook/notebook.dart';
import '../widgets/app_drawer.dart';
import '../widgets/my_bottom_app_bar.dart';
import './note_details_screen.dart';
import './note_list_screen.dart';
import './add_notebook_screen.dart';

class NotebookListScreen extends StatelessWidget {
  static const routeName = '/notebook-list';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scrollController = ScrollController();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void showMoreActions(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(ctx).size.height * 0.75,
        ),
        isScrollControlled: true,
        builder: (_) {
          return ModalBottomSheet.notebookListMenu();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(),
      bottomNavigationBar: AppBottomAppBar(_openDrawer),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            elevation: 1,
            leading: ModalRoute.of(context)!.canPop
                ? BackButton(
                    color: Theme.of(context).primaryColor,
                  )
                : Container(),
            leadingWidth: ModalRoute.of(context)!.canPop ? 56 : 0,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AddNotebookScreen.routeName);
                },
                icon: const Icon(CustomIcons.add_notebook_filled),
              ),
              IconButton(
                onPressed: () {
                  showMoreActions(context);
                },
                icon: const Icon(Icons.more_horiz),
              ),
            ],
            pinned: true,
            expandedHeight: 100,
            flexibleSpace: const FlexibleSpaceBar(
              expandedTitleScale: 1,
              titlePadding: EdgeInsets.only(left: 15, bottom: 16),
              title: Text(
                'Notebooks',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              BlocBuilder<NotebooksBloc, NotebooksState>(
                builder: (context, state) {
                  final notebooks = state.loadedNotebooks;
                  if (state.isLoading && notebooks.isEmpty) {
                    // if (state is NotebooksInitialState) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (notebooks.isNotEmpty) {
                    // if (state is NotebooksLoadedState) {
                    // final notebooks = state.loadedNotebooks;
                    // log(state.loadedNotebooks.first.noteList.length.toString());

                    return Container(
                      height: MediaQuery.of(context).size.height - 130,
                      child: ListView(
                        controller: _scrollController,
                        children: ListTile.divideTiles(
                          tiles: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 18,
                              ),
                              child: Text(
                                '${notebooks.length} Notebooks'.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ...notebooks
                                .map((nb) => ListTile(
                                      onTap: () {
                                        context.read<NotesBloc>().add(
                                            ShowNotesFromNotebook(nb.title));
                                        Navigator.of(context).pushNamed(
                                            NoteListScreen.routeName,
                                            arguments: nb.id);
                                      },
                                      title: Container(
                                          height: 50,
                                          child: Row(
                                            children: [
                                              const Icon(
                                                  CustomIcons.notebook_filled),
                                              const SizedBox(width: 10),
                                              RichText(
                                                text: TextSpan(children: [
                                                  TextSpan(
                                                    text: nb.title,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        ' (${nb.noteIdList.length})',
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ]),
                                              )
                                            ],
                                          )),
                                    ))
                                .toList(),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(AddNotebookScreen.routeName);
                              },
                              child: Row(
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child:
                                        Icon(CustomIcons.add_notebook_filled),
                                  ),
                                  SizedBox(width: 7),
                                  Text(
                                    'New notebook',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            )
                          ],
                          context: context,
                        ).toList(),
                      ),
                    );
                  }
                  // if (state is NotebooksErrorState) {
                  //   return Center(
                  //     child: Text('Something went wrong'),
                  //   );
                  // }
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                },
              ),
            ]),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const AppFloatingActionButton(
        notebookTitle: 'Notes',
      ),
    );
  }
}
