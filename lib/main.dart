import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './screens/home_screen.dart';
import './screens/note_details_screen.dart';
import './note/note.dart';
import './screens/note_list_screen.dart';
import './screens/notebook_list_screen.dart';
import './notebook/notebook.dart';
import './repository.dart';
import './screens/add_notebook_screen.dart';

void main() {
  runApp(MyApp(
    repository: Repository(),
  ));
}

class MyApp extends StatelessWidget {
  final noteRepository = NoteProvider();
  final notebookRepository = NotebookProvider();
  final Repository _repository;

  MyApp({required Repository repository}) : _repository = repository;

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
    return RepositoryProvider.value(
      value: _repository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<NotesBloc>(
            create: (context) => NotesBloc(_repository)
              ..add(
                NotesLoadEvent(),
              ),
          ),
          BlocProvider<NotebooksBloc>(
            create: (context) => NotebooksBloc(_repository)
              ..add(
                NotebooksLoadEvent(),
              ),
          )
        ],
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
            appBarTheme: const AppBarTheme(
              color: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
            ),
            listTileTheme: ListTileThemeData(
              iconColor: Colors.black,
            ),
            scaffoldBackgroundColor: Colors.white,
          ),
          home: HomeScreen(),
          routes: {
            NotebookListScreen.routeName: (context) => NotebookListScreen(),
            AddNotebookScreen.routeName: (context) => AddNotebookScreen(),
          },
        ),
      ),
    );
  }
}
