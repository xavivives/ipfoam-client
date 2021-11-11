import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:convert';
import 'package:ipfoam_client/interplanetary_text_transform.dart';
import 'package:ipfoam_client/note.dart';
import 'package:ipfoam_client/repo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var server = IpfoamServer();

    //server.getCids(["mstfwyya", "isw76vwa", "x77cl54q", "TYPEpwqlajqq"]);
    Repo.getCidWrapByIid("mstfwyya");
    IpfoamServer.requestIidsToLoad();

    return MaterialApp(
      title: ' Demo',
      theme: ThemeData(
        fontFamily: 'OpenSans',
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  dynamic note = {};

  void incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Padding(
            padding: const EdgeInsets.all(40),
            child: InterplanetaryTextTransform(ipt: str3)));
  }
}

class IpfoamServer {
  static Future<void> requestIidsToLoad() async {
    List<String> iidsToLoad = [];

    Repo.iids.forEach((iid, entry) {
      if (entry.status == RequestStatus.needed) {
        iidsToLoad.add(iid);
        entry.lastRequest = DateTime.now();
        entry.status == RequestStatus.requested;
      }
    });
    log("Server requesting " + iidsToLoad.toString());

    if (iidsToLoad.isEmpty) return;
    var iidsEndPoint = "https://ipfoam-server-dc89h.ondigitalocean.app/iids/" +
        iidsToLoad.join(",");
    var result = await http.get(Uri.parse(iidsEndPoint));
    Map<String, dynamic> body = json.decode(result.body);
    log(body.toString());
    Map<String, dynamic> cids = body["data"]["cids"];
    Map<String, dynamic> blocks = body["data"]["blocks"];
    List<String> dependencies = [];
    (cids as Map<String, dynamic>).forEach((iid, cid) {
      if (blocks[cid] != "") {
        Map<String, dynamic> block = blocks[cid];
        Note note = Note(cid: cid, block: block);
        Repo.addNoteForCid(cid, note);
        Repo.addCidForIid(iid, cid);
        dependencies.addAll(IpfoamServer.getIddTypesForBlock(block));
      }
    });
    log("Server over");
    log("Dependencies: " + dependencies.toString());
    log(Repo.iids["mstfwyya"]!.status.toString());
    // getCids(dependencies);
  }

  static List<String> getIddTypesForBlock(Map<String, dynamic> block) {
    List<String> typesIids = [];

    block.forEach((key, value) {
      List<String> primitiveTypes = [
        Note.primitiveConstrains,
        Note.primitiveDefaultName,
        Note.primitiveIpldSchema,
        Note.primitiveRepresents
      ];
      if (primitiveTypes.contains(key) == false) typesIids.add(key);
    });
    return typesIids;
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
