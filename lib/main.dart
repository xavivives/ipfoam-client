import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:convert';
import 'package:ipfoam_client/interplanetary_text_transform.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var server = IpfoamServer();

    server.getCids(["mstfwyya", "isw76vwa", "x77cl54q", "TYPEpwqlajqq"]);

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

  void _incrementCounter() {
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
            child: InterplanetaryTextTransform(ipt: const [
              "Is a 1979 book by ",
              "[\"m2u2cyfa/pwqlajqq\"]",
              " that proposes a new theory of architecture (and design in general) that relies on the understanding and configuration of design patterns. Although it came out later, it is essentially the introduction to ",
              "[\"n2sd3asq/pwqlajqq\"]",
              " and The Oregon Experiment,"
            ], accessibleNotes: [])));
  }
}

class IpfoamServer {
  Future<void> getCids(List<String> iids) async {
    if (iids.isEmpty) return;
    var iidsEndPoint =
        "https://ipfoam-server-dc89h.ondigitalocean.app/iids/" + iids.join(",");
    var result = await http.get(Uri.parse(iidsEndPoint));
    Map<String, dynamic> body = json.decode(result.body);
    Map<String, dynamic> cids = body["data"]["cids"];
    Map<String, dynamic> blocks = body["data"]["blocks"];
    List<String> dependencies = [];
    (cids as Map<String, dynamic>).forEach((iid, cid) {
      if (blocks[cid] != "") {
        Map<String, dynamic> block = blocks[cid];
        Repos.loadNote(iid, cid, block);
        dependencies.addAll(getBlockDependencies(block));
      }
    });
    log(dependencies.toString());
    getCids(dependencies);
  }

  List<String> getBlockDependencies(Map<String, dynamic> block) {
    List<String> dependencies = [];

    block.forEach((key, value) {
      dependencies.add(key);
    });
    return dependencies;
  }
}

class NoteWrap {
  String iid;
  String cid;
  Map<String, Object> block = {};

  NoteWrap(this.iid, this.cid, Map<String, Object> block);

  NoteWrap.fromJSONU(this.iid, this.cid, String JsonBlock) {
    block = json.decode(JsonBlock) as Map<String, Object>;
  }
}

class NoteType {
  String iid;
  String cid;
  String? defaultName;
  String? represents;
  List<String>? constrains;
  String? ipldSchema;

  NoteType(this.iid, this.cid, Map<String, Object> block) {
    defaultName = block["defaultName"] as String;
    represents = block["represents"] as String;
    constrains = block["constrains"] as List<String>;
    ipldSchema = block["ipldSchema"] as String;
  }
}

class Repos {
  static Map<String, dynamic> cids = {};
  static Map<String, dynamic> blocks = {};

  static void loadNote(String iid, String cid, dynamic block) {
    cids[iid] = cid;
    blocks[cid] = block;
  }
}

class Runtime {
  Map<String, DateTime> requests = {};

  getFromIpfs() {}
  getFromMind() {}
  getFromLocal() {}

  void requestAbstraction(List<String> iids) {}
}

typedef InterplantearyText = List<String>;
typedef NoteRequester = Function(List<String>);
