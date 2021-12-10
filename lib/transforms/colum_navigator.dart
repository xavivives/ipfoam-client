import 'package:flutter/material.dart';
import 'package:ipfoam_client/transforms/note_viewer.dart';
import 'package:provider/provider.dart';

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
