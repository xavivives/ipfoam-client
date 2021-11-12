import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:ipfoam_client/repo.dart';
import 'package:ipfoam_client/transforms/note_viewer.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
  const str3 = [
    "Is a 1979 book by ",
    "[\"m2u2cyfa/pwqlajqq\"]",
    " that proposes a new theory of architecture (and design in general) that relies on the understanding and configuration of design patterns. Although it came out later, it is essentially the introduction to ",
    "[\"n2sd3asq/pwqlajqq\"]",
    " and The Oregon Experiment,"
        "[\"x77cl54q/pwqlajqq\"]",
    "[\"TYPEpwqlajqq\"]"
  ];
  const str1 = [
    "[\"baguqeeraqmhjimttqkfw6xwzwflc57vla4jone6is3dfn5lf4terbxsj4cdq\"]",
    "[\"baguqeerascthaxcbfhb6cfzq36a3qibhxayiuhq7i6moy6bylgu6s4jr4z4q\"]",
    "[\"baguqeeralapclcswssawoyuwqpb7ghpszfcaw4bi3wt7nmnv6bqypwqlajqq\"]",
    "[\"baguqeeraculrztrg66wun5z4he3qk6ufv3evalphmi7zjita342ae2ptefia\"]",
    "[\"baguqeerauaki4hckr6xyrj6gk5rt7xe76xo4mhpnr7zy3r7krlluzkrrxnta\"]",
    "[\"baguqeerawhkesgkfn6fkj2yoga2uaqclgwslkxa3yyx46vf7mkuzcwi7dj5q\"]",
    "[\"baguqeerajxox2lwmztmjrz7vxywwr47c4ynkattrktbdetp7fz7x23qo4fua\"]",
    "[\"baguqeeraxbwfigx2sawjonxkx467pifbvcd5jjcmihroe6nplwh7avzlrroa\"]",
  ];
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
            child: Scaffold(body: NoteViewer(iid: "b4dqxu2a"))));
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
