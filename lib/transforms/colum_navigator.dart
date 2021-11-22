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
  Widget build(BuildContext context) {
    final navigation = Provider.of<Navigation>(context);
    List<Widget> notes = [];
    for (var iid in navigation.history) {
      notes.add(NoteViewer(iid));
    }

    return Row(
      children: notes,
    );
  }
}

class Navigation with ChangeNotifier {
  List<String> history = ["ig3yg7m4q"];
  void add(String iid) {
    history.add(iid);
    notifyListeners();
  }
}
