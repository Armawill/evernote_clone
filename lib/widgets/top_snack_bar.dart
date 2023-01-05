import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';

class TopSnackBar extends Flushbar {
  final BuildContext context;
  final String text;
  TopSnackBar(this.context, [this.text = 'Message'])
      : super(
          messageText: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.indigo,
          duration: const Duration(seconds: 3),
          flushbarPosition: FlushbarPosition.TOP,
          maxWidth: MediaQuery.of(context).size.width * 0.6,
          borderRadius: BorderRadius.circular(8),
          animationDuration: const Duration(milliseconds: 700),
        );

  TopSnackBar.deleteNote(BuildContext context)
      : this(context, 'Note moved to trash');

  TopSnackBar.restoreNote(BuildContext context)
      : this(context, 'Note restored');
}
