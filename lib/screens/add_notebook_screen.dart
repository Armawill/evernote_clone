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
  bool _isExist = false;

  String _newTitile = '';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var notebookBloc = BlocProvider.of<NotebooksBloc>(context);
    var data = ModalRoute.of(context)!.settings.arguments;
    var oldTitle = '';
    if (data != null) {
      oldTitle = data as String;
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: _newTitile.isEmpty || _isExist
                ? null
                : oldTitle.isEmpty
                    ? () {
                        var notebookBloc =
                            BlocProvider.of<NotebooksBloc>(context);
                        notebookBloc.add(AddNotebookEvent(_newTitile.trim()));
                        Navigator.pop(context);
                      }
                    : () {
                        var notebookBloc =
                            BlocProvider.of<NotebooksBloc>(context);
                        notebookBloc
                            .add(RenameNotebookEvent(oldTitle, _newTitile));
                        Navigator.pop(context);
                      },
            child: oldTitle.isEmpty
                ? const Text(
                    'Create',
                    style: TextStyle(fontSize: 18),
                  )
                : const Text(
                    'Rename',
                    style: TextStyle(fontSize: 18),
                  ),
          )
        ],
      ),
      body: Column(
        children: [
          TextFormField(
            key: _formKey,
            initialValue: oldTitle,
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
              value = value.trim();
              var index = notebookBloc.state.loadedNotebooks
                  .indexWhere((nb) => (nb.title == value && value != oldTitle));
              if (index >= 0) {
                setState(() {
                  _isExist = true;
                  _newTitile = value;
                });
              } else {
                setState(() {
                  _isExist = false;
                  _newTitile = value;
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
                'Error: There is already a notebook named "${_newTitile}". Please use a unique name.',
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
