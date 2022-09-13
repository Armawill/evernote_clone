import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../notebook/bloc/notebooks_bloc.dart';

class AddNotebookScreen extends StatelessWidget {
  static const routeName = '/add-notebook';
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              var notebookBloc = BlocProvider.of<NotebooksBloc>(context);
              notebookBloc.add(AddNotebookEvent(_controller.text));
              Navigator.pop(context);
            },
            child: Text(
              'Create',
              style: TextStyle(fontSize: 18),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: 'Notebook name',
              hintStyle: TextStyle(
                color: Colors.grey[400],
              ),
              prefixIcon: Icon(Icons.book),
              iconColor: Colors.black,
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
          Divider(
            endIndent: 13,
            indent: 13,
            height: 2,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            child: Text(
              'Notebooks are useful for grouping notes around a common topic.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
