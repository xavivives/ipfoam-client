
import 'package:flutter/material.dart';
import 'package:ipfoam_client/note.dart';
import 'package:ipfoam_client/transforms/interplanetary_text/interplanetary_text.dart';
import 'package:ipfoam_client/transforms/note_viewer.dart';
import 'package:ipfoam_client/transforms/sub_abstraction_block.dart';
import 'package:provider/provider.dart';
import 'dart:html' as Html;

class ColumnNavigator extends StatefulWidget {
  ColumnNavigator({
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
    for (var i = 0; i < navigation.history.length; i++) {
      notes.add(
        ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 20, 0),
                child: ListView(
                  //shrinkWrap: true,
                  children: [
                    buildMenuBar(navigation, i),
                    IptRoot.fromArray([Note.iidSubAbstractionBlock,navigation.history[i]])
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
  List<String> history = ["iamsdlhba"];

  void add(String iid) {
    history.add(iid);
    notify();
  }

  void close(int column) {
    history.removeAt(column);
    notify();
  }

  void reset() {
    history = [];
  }

  void notify() {
    notifyListeners();
    Html.window.history.pushState(
        null, "Interplanetary mind-map", "#?iids=" + history.join(","));
  }
}
