import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './screens/home_screen.dart';
import './screens/note_details_screen.dart';
import './bloc/notes_bloc.dart';
import './services/note_repository.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final noteRepository = NoteRepository();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotesBloc>(
      create: (ctx) => NotesBloc(noteRepository)..add(NotesLoadEvent()),
      child: MaterialApp(
        title: 'Evernote Clone',
        theme: ThemeData(
            primarySwatch: Colors.green,
            bottomAppBarColor: Colors.white,
            appBarTheme: AppBarTheme(
              color: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
            ),
            scaffoldBackgroundColor: Colors.white),
        home: HomeScreen(),
        routes: {
          NoteDetailsScreen.routeName: (context) => NoteDetailsScreen(),
        },
      ),
    );
  }
}
