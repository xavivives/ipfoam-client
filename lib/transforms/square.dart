import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ipfoam_client/bridge.dart';
import 'package:ipfoam_client/note.dart';
import 'package:ipfoam_client/repo.dart';
import 'package:ipfoam_client/transforms/colum_navigator.dart';

class Square {
  Bridge bridge;
  Repo repo;
  Navigation navigation;
  BuildContext context;

  Square(this.context, this.repo, this.navigation, this.bridge) {
    bridge.startWs(onIid: onBridgeIid);
  }

  void onBridgeIid(String iid) {
    print("Pushing IID:" + iid + " from bridge");
    repo.forceRequest(iid);
    //navigation.reset();

    //navigation.add('["is6hvlinqlzfmhs7a",["is6hvlinq2lf4dbua","'+iid+'"]]');
    navigation.add([
      Note.iidColumnNavigator,
      [Note.iidNoteViewer, iid]
    ]);
  }

  void processRoute(Uri uri) {
    final run = uri.queryParameters['expr'];
    if (run == null) {
      return;
    }
    try {
      List<dynamic> expr = json.decode(run);
      navigation.add(expr);
    } catch (e) {
      print("unable to decode expr:" + run);
    }
  }
}
