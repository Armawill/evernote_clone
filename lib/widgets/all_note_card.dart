import 'package:flutter/material.dart';

import '../screens/note_list_screen.dart';

class AllNoteCard extends StatelessWidget {
  final int quantity;
  const AllNoteCard({Key? key, required this.quantity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(NoteListScreen.routeName);
        },
        splashFactory: NoSplash.splashFactory,
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
                    const TextSpan(
                      text: 'Notes ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    TextSpan(
                      text: '($quantity)',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
