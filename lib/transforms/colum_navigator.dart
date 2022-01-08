import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ipfoam_client/main.dart';
import 'package:ipfoam_client/note.dart';
import 'package:ipfoam_client/transforms/interplanetary_text/interplanetary_text.dart';
import 'package:provider/provider.dart';
import 'dart:html' as Html;

class ColumnNavigator extends StatefulWidget {
  // [[column1, column2], pref] or [[[column1 render, column1 note], [column2 render, column2 note]],pref]
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

  makeSabExpr(AbstractionReference aref) {
    return [Note.iidSubAbstractionBlock, aref.iid];
  }

  makeColumnExpr(dynamic expr) {
    return [Note.iidColumnNavigator, expr];
  }

  Widget build(BuildContext context) {
    final navigation = Provider.of<Navigation>(context);
    List<Widget> columns = [];

    List<dynamic> columnsExpr = widget.arguments[0];

    for (var i = 0; i < columnsExpr.length; i++) {

      void onTap(AbstractionReference aref) {
        var newColumns = columnsExpr;

        if (newColumns.length > i + 1) {
          newColumns.removeRange(i + 1, newColumns.length);
        }
        newColumns.add(makeSabExpr(aref));
        var expr = makeColumnExpr(newColumns);
        navigation.add(expr);
      }

      columns.add(
        ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 20, 0),
                child: ListView(
                  //shrinkWrap: true,
                  children: [
                    buildMenuBar(navigation, i),
                    IPTFactory.getRootTransform(columnsExpr[i], onTap)
                  ],
                ))),
      );
    }

    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        Row(
          children: columns,
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
    Html.window.history.pushState(
        null, "Interplanetary mind-map", "#?expr=" + json.encode(history.last));
  }
}
