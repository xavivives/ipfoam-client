import 'package:flutter/material.dart';
import 'package:ipfoam_client/transforms/note_viewer.dart';
import 'package:provider/provider.dart';

class ColumNavigator extends StatefulWidget {
  ColumNavigator({
    Key? key,
  }) : super(key: key);

  @override
  State<ColumNavigator> createState() => ColumNavigatorState();

  List<String> history = ["ig3yg7m4q", "ig3yg7m4q", "iyd6bkixa"];
}

class ColumNavigatorState extends State<ColumNavigator> {
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
        SizedBox(
            width: 600,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: ListView(
                  //shrinkWrap: true,
                  children: [
                    buildMenuBar(navigation, i),
                    NoteViewer(navigation.history[i], i),
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
    notifyListeners();
  }

  void close(int column) {
    history.removeAt(column);
    notifyListeners();
  }

  void reset() {
    history = [];
  }
}
