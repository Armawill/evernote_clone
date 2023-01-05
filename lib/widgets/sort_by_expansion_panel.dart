import 'dart:developer';

import 'package:evernote_clone/notebook/bloc/notebooks_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enum_to_string/enum_to_string.dart';

import 'package:evernote_clone/note/note.dart';

enum BlocType { notesBloc, notebooksBloc }

class Item {
  final String title;

  Item(this.title);
}

List<Item> items = [
  Item('Date deleted'),
  Item('Date updated'),
  Item('Date created'),
  Item('Title'),
];

class SortByExpansionPanel extends StatefulWidget {
  final bool isTrash;
  final BlocType blocType;

  SortByExpansionPanel({required this.blocType, this.isTrash = false});

  @override
  State<SortByExpansionPanel> createState() => _SortByExpansionPanelState();
}

class _SortByExpansionPanelState extends State<SortByExpansionPanel> {
  var _isExpanded = false;
  late SortType sortType;

  /// If [descAscSort] is false, then the list of notes will be sorted in descending order, otherwise in ascending order.
  late bool descAscSort;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.blocType == BlocType.notesBloc) {
      sortType = context.read<NotesBloc>().state.sortType;
      descAscSort = context.read<NotesBloc>().state.descAscSort;
    } else {
      sortType = context.read<NotebooksBloc>().state.sortType;
      descAscSort = context.read<NotebooksBloc>().state.descAscSort;
    }
  }

  void sort(SortType newSortType) {
    if (newSortType == sortType) {
      setState(() {
        descAscSort = !descAscSort;
      });
    } else {
      setState(() {
        sortType = newSortType;
      });
    }

    if (widget.blocType == BlocType.notesBloc) {
      context.read<NotesBloc>().add(SortNotes(newSortType, descAscSort));
    } else if (widget.blocType == BlocType.notebooksBloc) {
      context
          .read<NotebooksBloc>()
          .add(SortNotebooks(newSortType, descAscSort));
    } else {
      log('Error: bloc type is wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    const divider = Divider(
      height: 0,
      thickness: 1,
      indent: 10,
      endIndent: 10,
    );

    var icon = descAscSort
        ? const Icon(Icons.arrow_upward)
        : const Icon(Icons.arrow_downward);
    return ExpansionPanelList(
      expansionCallback: (_, __) {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      elevation: 0,
      children: [
        ExpansionPanel(
          backgroundColor: Colors.grey[50],
          canTapOnHeader: true,
          isExpanded: _isExpanded,
          headerBuilder: (context, isExpanded) {
            return ListTile(
              leading: const Icon(
                Icons.sort,
              ),
              title: const Text('Sort by'),
              trailing: Text(
                EnumToString.convertToString(sortType, camelCase: true),
                style: const TextStyle(color: Colors.grey),
              ),
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            );
          },
          body: Material(
            color: Colors.grey[100],
            child: Column(
              children: [
                ListTile(
                  title: const Text('Title'),
                  trailing: sortType == SortType.title ? icon : null,
                  onTap: () {
                    sort(SortType.title);
                  },
                ),
                divider,
                ListTile(
                  title: const Text('Date created'),
                  trailing: sortType == SortType.dateCreated ? icon : null,
                  onTap: () {
                    sort(SortType.dateCreated);
                  },
                ),
                divider,
                ListTile(
                  title: const Text('Date updated'),
                  trailing: sortType == SortType.dateUpdated ? icon : null,
                  onTap: () {
                    sort(SortType.dateUpdated);
                  },
                ),
                if (widget.isTrash)
                  Column(
                    children: [
                      divider,
                      ListTile(
                        title: const Text('Date deleted'),
                        trailing:
                            sortType == SortType.dateDeleted ? icon : null,
                        onTap: () {
                          sort(SortType.dateDeleted);
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
