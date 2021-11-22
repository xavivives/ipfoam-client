import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:ipfoam_client/repo.dart';
import 'package:ipfoam_client/transforms/colum_navigator.dart';
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //server.getCids(["mstfwyya", "isw76vwa", "x77cl54q", "TYPEpwqlajqq"]);
    //Repo.getCidWrapByIid("mstfwyya");
    //Server.requestIidsToLoad();

    return MaterialApp(
        title: ' Interplanetary mind map',
        theme: ThemeData(
          fontFamily: 'OpenSans',
          canvasColor: Colors.white,
        ),
        home: ChangeNotifierProvider<Repo>(
            create: (context) => Repo(),
            child: Scaffold(
                body: ChangeNotifierProvider<Navigation>(
                    child: ColumNavigator(),
                    create: (context) => Navigation()))));
  }
}

typedef InterplantearyText = List<String>;
typedef NoteRequester = Function(List<String>);

class AbstractionReference {
  String? mid;
  String? iid;
  List<String>? path;
  String? cid;
  late String origin; // "mid:iid" or "cid"
  static String midToIidToken = ":";
  static String pathToken = "/";
  static String midPlaceholder = "x";

  //An abstraction reference has the signature "mid:iid/prop/path/" or "cid/prop/path"

  AbstractionReference.fromText(String text) {
    var t = text.split(AbstractionReference.pathToken);
    origin = t[0]; // "mid:iid" or "cid"
    path = t..removeAt(0);

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
  }

  bool isIid() {
    return iid != null;
  }

  bool isCid() {
    return cid != null;
  }
}
