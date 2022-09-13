import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../notebook/notebook.dart';
import '../widgets/app_drawer.dart';
import '../widgets/my_bottom_app_bar.dart';
import './note_details_screen.dart';
import './note_list_screen.dart';
import './add_notebook_screen.dart';

class NotebookListScreen extends StatelessWidget {
  static final routeName = '/notebook-list';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _scrollController = ScrollController();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
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
                onPressed: () {},
                icon: Icon(Icons.bookmark_add),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_horiz),
              ),
            ],
            pinned: true,
            expandedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
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
                  if (state is NotebooksInitialState) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is NotebooksLoadedState) {
                    final notebooks = state.loadedNotebooks;
                    log(state.loadedNotebooks.first.noteList.length.toString());

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
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ...notebooks
                                .map((nb) => ListTile(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            NoteListScreen.routeName,
                                            arguments: nb.title);
                                      },
                                      title: Container(
                                          height: 50,
                                          child: Row(
                                            children: [
                                              Icon(Icons.book),
                                              RichText(
                                                text: TextSpan(children: [
                                                  TextSpan(
                                                    text: nb.title,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        ' (${nb.noteList.length})',
                                                    style: TextStyle(
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
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 7),
                                    child: Icon(Icons.bookmark_add),
                                  ),
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
                  if (state is NotebooksErrorState) {
                    return Center(
                      child: Text('Something went wrong'),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ]),
          )
        ],
      ),
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
