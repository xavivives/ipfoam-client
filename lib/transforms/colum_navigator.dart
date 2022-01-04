import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ipfoam_client/transforms/interplanetary_text/interplanetary_text.dart';
import 'package:provider/provider.dart';
import 'dart:html' as Html;

class ColumnNavigator extends StatefulWidget {
  List<dynamic> arguments;
  ColumnNavigator({
    required this.arguments,
    Key? key,
  }) : super(key: key);

  @override
  State<ColumnNavigator> createState() => ColumnNavigatorState();
}

class ColumnNavigatorState extends State<ColumnNavigator> {
  @override
  Widget buildMenuBar(Navigation navigation, int column) {
    return Row(children: [
      TextButton(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(fontSize: 12),
        ),
        onPressed: () {
          navigation.close(column);
        },
        child: const Text('Close'),
      ),
    ], mainAxisAlignment: MainAxisAlignment.end);
  }

  Widget build(BuildContext context) {
    final navigation = Provider.of<Navigation>(context);
    List<Widget> notes = [];
    for (var i = 0; i < widget.arguments.length; i++) {
      notes.add(
        ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 20, 0),
                child: ListView(
                  //shrinkWrap: true,
                  children: [
                    buildMenuBar(navigation, i),
                    IPTFactory.getRootTransform(widget.arguments[i])
                    //IptRoot.fromExpr([widget.columns[i]])
                    //NoteViewer(navigation.history[i], i),
                  ],
                ))),
      );
    }

    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        Row(
          children: notes,
        )
      ],
    );
  }
}

class Navigation with ChangeNotifier {
  List<List<dynamic>> history = [[]];

  void add(List<dynamic> expr) {
    history.add(expr);
    notify();
  }

  void close(int column) {
    history.removeAt(column);
    notify();
  }

  /*void reset() {
    history = [];
  }
*/
  void notify() {
    notifyListeners();
    Html.window.history
        .pushState(null, "Interplanetary mind-map", "#?expr=" + json.encode(history.last));
  }
}
