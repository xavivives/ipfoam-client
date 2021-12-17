import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ipfoam_client/bridge.dart';
import 'package:ipfoam_client/repo.dart';
import 'package:ipfoam_client/transforms/colum_navigator.dart';

class Square {
  Bridge bridge;
  Repo repo;
  Navigation navigation;
  BuildContext context;

  Square(this.context,this.repo, this.navigation, this.bridge) {
    bridge.startWs(onIid: onBridgeIid);
  }

  void onBridgeIid(String iid) {
    print("Pushing IID:" + iid + " from bridge");
    repo.forceRequest(iid);
    navigation.reset();
    navigation.add(iid);
  }

  void processRoute(Uri uri) {
     final exprStr = uri.queryParameters['expr'];
    List<String> expr=[];
     if(exprStr!=null){
       try{
      expr = json.decode(exprStr);
       }catch(e){
         print(e);
       }
       print("expr;");
      print(expr);


     }

    final iidsStr = uri.queryParameters['iids'];
    if (iidsStr != null) {
      var iids = iidsStr.split(",");
      navigation.reset();
      
      for(var iid in iids){
        navigation.add(iid);
      }
    }
  }
}
