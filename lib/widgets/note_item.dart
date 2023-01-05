import 'package:flutter/material.dart';
import 'package:search_highlight_text/search_highlight_text.dart';

import '../helpers/datetime_helper.dart';
import '../note/note.dart';
import '../screens/note_details_screen.dart';

class NoteItem extends StatelessWidget {
  NoteItem(this.note, this._notebookTitle, [this.searchedString]);
  final Note note;
  final String _notebookTitle;
  final String? searchedString;

  @override
  Widget build(BuildContext context) {
    List<int> searchedStringIndexes = [];
    int index = 0;
    if (searchedString != null) {
      while (note.title.indexOf(searchedString!, index) > 0) {
        var nextIndex = note.title.indexOf(searchedString!, index);
        searchedStringIndexes.add(nextIndex);
        index = nextIndex;
      }
    }
    return ListTile(
      key: ValueKey(note.id),
      onTap: () {
        Navigator.of(context).pushNamed(
          NoteDetailsScreen.routeName,
          arguments: {'note': note, 'notebookId': _notebookTitle},
        );
      },
      title: Container(
        height: MediaQuery.of(context).size.height * 0.25,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SearchHighlightText(
                    searchRegExp: RegExp(searchedString!, caseSensitive: false),
                    note.title,
                    highlightStyle: TextStyle(
                      backgroundColor: Colors.lime[400],
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                SearchHighlightText(
                  searchRegExp: RegExp(searchedString!, caseSensitive: false),
                  note.text,
                  highlightStyle: TextStyle(
                    backgroundColor: Colors.lime[400],
                    color: Colors.grey[700],
                    fontSize: 15,
                  ),
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                  ),
                  maxLines: 6,
                ),
              ],
            ),
            Text(
              DateTimeHelper.getDate(note.dateUpdated),
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
