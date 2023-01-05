import 'package:flutter/material.dart';
import 'package:rich_text_controller/rich_text_controller.dart';

class RichTextControllerDemo extends StatefulWidget {
  final String regExpStr;
  final bool enabled;
  final String initialValue;
  final TextStyle? style;
  final InputDecoration decoration;
  final Function(String?) onSaved;
  final Function()? onTap;
  final FocusNode? focusNode;
  final int? maxLines;

  RichTextControllerDemo({
    required this.regExpStr,
    required this.enabled,
    required this.initialValue,
    this.style,
    required this.decoration,
    required this.onSaved,
    this.onTap,
    this.focusNode,
    this.maxLines,
  });

  @override
  State<RichTextControllerDemo> createState() => _RichTextControllerDemoState();
}

class _RichTextControllerDemoState extends State<RichTextControllerDemo> {
// Add a controller
  late RichTextController _controller;

  @override
  void initState() {
    // initialize with your custom regex patterns or Strings and styles
    //* Starting V1.2.0 You also have "text" parameter in default constructor !
    _controller = RichTextController(
        patternMatchMap: {
          RegExp(
            widget.regExpStr,
            caseSensitive: false,
          ): TextStyle(
            fontWeight: FontWeight.w800,
            backgroundColor: Colors.lime,
          ),
        },
        onMatch: (List<String> matches) {
          // Do something with matches.
          //! P.S
          // as long as you're typing, the controller will keep updating the list.
        }
        //  deleteOnBack: true,

        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      enabled: widget.enabled,
      initialValue: widget.initialValue,
      style: widget.style,
      decoration: widget.decoration,
      onSaved: widget.onSaved,
      onTap: widget.onTap,
      focusNode: widget.focusNode,
      maxLines: widget.maxLines,
    );
  }
}
