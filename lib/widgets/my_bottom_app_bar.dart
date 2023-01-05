import 'package:evernote_clone/note/bloc/notes_bloc.dart';
import 'package:evernote_clone/notebook/bloc/notebooks_bloc.dart';
import 'package:evernote_clone/presentation/custom_icons_icons.dart';
import 'package:evernote_clone/repository.dart';
import 'package:evernote_clone/screens/note_details_screen.dart';
import 'package:evernote_clone/screens/note_list_screen.dart';
import 'package:evernote_clone/widgets/note_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_highlight_text/search_highlight_text.dart';

import '../note/note.dart';
import '../notebook/notebook.dart';

class AppBottomAppBar extends StatelessWidget {
  final VoidCallback openDrawer;
  AppBottomAppBar(this.openDrawer);
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: null,
      elevation: 10,
      color: Theme.of(context).bottomAppBarColor,
      child: IconTheme(
        data: IconThemeData(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              tooltip: 'Open navigation menu',
              icon: const Icon(Icons.menu),
              onPressed: () {
                openDrawer();
              },
            ),
            IconButton(
              tooltip: 'Search',
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: AppSearchDelegate(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AppSearchDelegate extends SearchDelegate {
  @override
  InputDecorationTheme? get searchFieldDecorationTheme => InputDecorationTheme(
        fillColor: Colors.grey[200],
        filled: true,
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(
            color: Colors.grey,
            style: BorderStyle.none,
          ),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(fontSize: 16),
        constraints: const BoxConstraints(maxHeight: 45),
      );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.filter_alt_rounded),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Note> loadedNotes = List.from(
        context.select((Repository repository) => repository.noteList));
    var regExp = RegExp(query, caseSensitive: false);
    List<Note> resultNotes = loadedNotes.where(
      (note) {
        return regExp.hasMatch(note.title) || regExp.hasMatch(note.text);
      },
    ).toList();
    return ListView.builder(
        itemCount: resultNotes.length,
        itemBuilder: (context, index) {
          return NoteItem(
              resultNotes[index], resultNotes[index].notebookId, query);
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Note> loadedNotes = List.from(
        context.select((Repository repository) => repository.noteList));
    List<Notebook> loadedNotebooks = List.from(
        context.select((Repository repository) => repository.notebookList));

    loadedNotes.sort(
      (a, b) => b.dateUpdated.compareTo(a.dateUpdated),
    );

    loadedNotebooks.sort(
      (a, b) => b.dateUpdated.compareTo(a.dateUpdated),
    );
    var noteIndex = 0, nbIndex = 0;

    List<Note> suggestedNotes = [];
    List<String> suggestedWords = [];

    if (query.isEmpty) {
      return ListView.builder(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: (loadedNotes.length + loadedNotebooks.length) >= 4
            ? 4
            : (loadedNotes.length + loadedNotebooks.length),
        itemBuilder: (context, _) {
          final note = loadedNotes[noteIndex];
          final notebook = loadedNotebooks[nbIndex];
          if (note.dateUpdated.compareTo(notebook.dateUpdated) >= 0) {
            noteIndex++;
            return ListTile(
              title: Row(
                children: [
                  const Icon(CustomIcons.note_outlined),
                  const SizedBox(width: 10),
                  Text(note.title),
                ],
              ),
              onTap: () {
                Navigator.of(context).pushNamed(
                  NoteDetailsScreen.routeName,
                  arguments: {
                    'note': note, /*'notebookId': note.notebookId*/
                  },
                );
              },
            );
          } else {
            nbIndex++;
            return ListTile(
              title: Row(
                children: [
                  const Icon(CustomIcons.notebook_filled),
                  const SizedBox(width: 10),
                  Text(notebook.title),
                ],
              ),
              onTap: () {
                Navigator.of(context).pushNamed(
                  NoteListScreen.routeName,
                  arguments: notebook.id,
                );
              },
            );
          }
        },
      );
    } else {
      final input = query.toLowerCase();
      suggestedNotes = loadedNotes.where(
        (note) {
          final result = note.title.toLowerCase();
          return result.contains(input);
        },
      ).toList();

      RegExp allWordsRegExp = RegExp(r'\w+');
      for (var note in loadedNotes) {
        var allWords = allWordsRegExp.allMatches(note.text);

        for (var word in allWords) {
          if (word[0]!.contains(query)) {
            if (!suggestedWords.contains(word[0])) {
              suggestedWords.add(word[0].toString());
            }
          }
        }
      }

      return ListView(
        children: [
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: suggestedWords.length,
            itemBuilder: (context, index) {
              final suggestion = suggestedWords[index];
              var queryIndex = suggestion.indexOf(query);

              return ListTile(
                title: Row(
                  children: [
                    const Icon(Icons.search),
                    const SizedBox(width: 10),
                    SearchHighlightText(
                      suggestion,
                      searchText: query,
                      highlightStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  query = suggestion;
                  showResults(context);
                },
              );
            },
          ),
          const Divider(
            thickness: 1,
            indent: 15,
            endIndent: 15,
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: suggestedNotes.length,
            itemBuilder: (context, index) {
              final suggestion = suggestedNotes[index].title;
              return ListTile(
                title: Row(
                  children: [
                    const Icon(CustomIcons.note_outlined),
                    const SizedBox(width: 10),
                    SearchHighlightText(
                      suggestion,
                      searchRegExp: RegExp(query, caseSensitive: false),
                      highlightStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    NoteDetailsScreen.routeName,
                    arguments: {
                      'note': suggestedNotes[index],
                      'searchString': query,
                    },
                  );
                },
              );
            },
          ),
        ],
      );
    }
  }
}
