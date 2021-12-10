import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ipfoam_client/bridge.dart';
import 'dart:developer';
import 'package:ipfoam_client/repo.dart';
import 'package:ipfoam_client/transforms/colum_navigator.dart';
import 'package:ipfoam_client/transforms/square.dart';
import 'package:provider/provider.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var repo = Repo();
    var navigation = Navigation();
    var bridge = Bridge();
    var square = Square(repo, navigation, bridge);
    var columNavigator = ColumnNavigator();

    var page = ChangeNotifierProvider.value(
          value: repo,
          child: Scaffold(
              body: ChangeNotifierProvider.value(
                  value: navigation,
                  child: columNavigator
                  )));

    return MaterialApp(
      title: ' Interplanetary mind map',
      theme: ThemeData(
        fontFamily: 'OpenSans',
        canvasColor: Colors.white,
      ),
      home: page,


      onGenerateRoute: (settings) {
        if (settings.name != null) {
          final settingsUri = Uri.parse(settings.name!);
          square.processRoute(settingsUri);
          //Navigator.pushNamed(context, "/abc");
          
          
         return PageRouteBuilder(pageBuilder: (_, __, ___) => page, settings:settings);
        }
      },
    );
  }
}


class ScreenArguments {
  final String title;
  final String message;

  ScreenArguments(this.title, this.message);
}

typedef NoteRequester = Function(List<String>);

class AbstractionReference {
  String? mid;
  String? iid;
  String? tiid; //TypeIId (property)
  List<String>? path;
  String? cid;
  late String origin; // "mid:iid" or "cid"
  static String midToIidToken = ":";
  static String pathToken = "/";
  static String midPlaceholder = "x";

  //An abstraction reference has the signature "mid:iid/tiid/path/" or "cid/tiid/path" or cid/path

  AbstractionReference.fromText(String text) {
    var t = text.split(AbstractionReference.pathToken);
    origin = t[0]; // "mid:iid" or "cid"

    //if there is no token we can assume is a CID. Except whie mids are not implemented
    var o = origin.split(AbstractionReference.midToIidToken);

    if (o.length == 1) {
      if (o[0].length > 12) {
        cid = o[0];
      } else {
        //Current version without mid
        mid = AbstractionReference.midPlaceholder;
        iid = o[0];
      }
    } else if (o.length == 2) {
      mid = o[0];
      iid = o[1];
    } else {
      log("Error parssing expression:" + text);
    }

    if (t.length > 1) {
      var propertiesRuns = t..removeAt(0);
      tiid = propertiesRuns[0];
      if (propertiesRuns.length > 1) {
        path = propertiesRuns..remove(0);
      }
    }
    //print("mid:$mid iid:$iid tiid:$tiid path:$path");
  }

  bool isIid() {
    return iid != null;
  }

  bool isCid() {
    return cid != null;
  }
}
