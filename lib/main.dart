import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './screens/home_screen.dart';
import './screens/note_details_screen.dart';
import './bloc/notes_bloc.dart';
import './services/note_repository.dart';
import './screens/note_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final noteRepository = NoteRepository();

  PageRouteBuilder buildRoute(Widget widget, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => widget,
      transitionsBuilder: (_, animation, __, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotesBloc>(
      create: (ctx) => NotesBloc(noteRepository)..add(NotesLoadEvent()),
      child: MaterialApp(
        onGenerateRoute: (settings) {
          if (settings.name == NoteDetailsScreen.routeName) {
            return buildRoute(NoteDetailsScreen(), settings);
          }
          if (settings.name == NoteListScreen.routeName) {
            return buildRoute(NoteListScreen(), settings);
          }
        },
        title: 'Evernote Clone',
        theme: ThemeData(
          primarySwatch: Colors.green,
          bottomAppBarColor: Colors.white,
          appBarTheme: AppBarTheme(
            color: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          scaffoldBackgroundColor: Colors.white,
        ),

        home: HomeScreen(),
        // routes: {
        //   NoteDetailsScreen.routeName: (context) => NoteDetailsScreen(),
        // },
      ),
    );
  }
}
