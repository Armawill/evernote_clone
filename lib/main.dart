import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/home_screen.dart';
import './screens/note_details_screen.dart';
import './provider/note.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Notes(),
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
