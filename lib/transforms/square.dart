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

  Square(this.context, this.repo, this.navigation, this.bridge);

  void onBridgeIid(String iid) {
    print("Pushing IID:" + iid + " from bridge");
    repo.forceRequest(iid);
  
    navigation.add([
      Note.iidColumnNavigator,
      [Note.iidNoteViewer, iid]
    ]);
  }

  void processRoute(Uri uri) {

    final localServerPort = uri.queryParameters['localServerPort'];
    if (localServerPort != null && localServerPort != repo.localServerPort) {
      repo.localServerPort = localServerPort;
    }

    final websocketsPort = uri.queryParameters['websocketsPort'];
    if (websocketsPort != null && websocketsPort != bridge.websocketsPort) {
      bridge.startWs(onIid: onBridgeIid, port: websocketsPort);
    }

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
