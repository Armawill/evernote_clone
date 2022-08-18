import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/note_card.dart';
import '../provider/note.dart';

class NoteHorizontalList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var notesData = Provider.of<Notes>(context);
    var notes = notesData.notes;
    int notesLength = notes.length;
    if (notes.length > 11) {
      notesLength = 11;
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: notesLength,
          itemBuilder: (context, index) {
            if (index <= notesLength - 1) {
              return ChangeNotifierProvider.value(
                value: notes[index],
                child: NoteCard(),
              );
            } else {
              return Card(
                elevation: 5,
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        child: Icon(Icons.note_rounded),
                        radius: 25,
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      SizedBox(height: 15),
                      RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(
                              text: 'Notes ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            TextSpan(
                              text: '(${notes.length})',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
