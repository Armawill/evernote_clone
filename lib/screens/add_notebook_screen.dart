import 'package:evernote_clone/presentation/custom_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../notebook/notebook.dart';

class AddNotebookScreen extends StatefulWidget {
  static const routeName = '/add-notebook';

  @override
  State<AddNotebookScreen> createState() => _AddNotebookScreenState();
}

class _AddNotebookScreenState extends State<AddNotebookScreen> {
  final _controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String title = '';

  bool _isExist = false;

  @override
  Widget build(BuildContext context) {
    var notebookBloc = BlocProvider.of<NotebooksBloc>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: _controller.text.isEmpty || _isExist
                ? null
                : () {
                    var notebookBloc = BlocProvider.of<NotebooksBloc>(context);
                    notebookBloc.add(AddNotebookEvent(_controller.text.trim()));
                    Navigator.pop(context);
                  },
            child: const Text(
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
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: 'Notebook name',
              hintStyle: TextStyle(
                color: Colors.grey[400],
              ),
              prefixIcon: const Icon(
                CustomIcons.notebook_filled,
                color: Colors.black,
              ),
              iconColor: Colors.black,
              border: const OutlineInputBorder(borderSide: BorderSide.none),
            ),
            onChanged: (value) {
              var index = notebookBloc.state.loadedNotebooks
                  .indexWhere((nb) => nb.title == value.trim());
              if (index >= 0) {
                setState(() {
                  _isExist = true;
                  title = value;
                });
              } else {
                setState(() {
                  _isExist = false;
                  title = '';
                });
              }
            },
          ),
          const Divider(
            endIndent: 13,
            indent: 13,
            height: 2,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            child: Text(
              'Notebooks are useful for grouping notes around a common topic.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
          ),
          if (_isExist)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
              child: Text(
                'Error: There is already a notebook named "$title". Please use a unique name.',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 15,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
