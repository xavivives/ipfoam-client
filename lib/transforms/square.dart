import 'package:flutter/material.dart';
import 'package:ipfoam_client/bridge.dart';
import 'package:ipfoam_client/repo.dart';
import 'package:ipfoam_client/transforms/colum_navigator.dart';
import 'package:provider/provider.dart';

class Square {
  Bridge bridge;
  Repo repo;
  Navigation navigation;

  Square(this.repo, this.navigation, this.bridge) {
    bridge.startWs(onIid: onBridgeIid);
  }

  void onBridgeIid(String iid) {
    print("IID " + iid + " recieved");
    // 

    repo.forceRequest(iid);
    navigation.reset();
    navigation.add(iid);
    print("IID reloaded");
  }

  void processRoute(Uri uri) {
    print("Parsing");
    final iidsStr = uri.queryParameters['iids'];
    print(iidsStr);
    if (iidsStr != null) {
      var iids = iidsStr.split(",");
      navigation.reset();
      
      for(var iid in iids){
        print(iid);
        navigation.add(iid);
      }
    }
  }
}
