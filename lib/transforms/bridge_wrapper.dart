import 'package:flutter/material.dart';
import 'package:ipfoam_client/bridge.dart';
import 'package:ipfoam_client/repo.dart';
import 'package:ipfoam_client/transforms/colum_navigator.dart';
import 'package:provider/provider.dart';

class BridgeWrapper extends StatefulWidget {
  var bridge = Bridge();
  Repo? repo;
  Navigation? navigation;
  Widget child;

  BridgeWrapper(this.child) {
    bridge.startWs(onIid: onBridgeIid);
  }

  void onBridgeIid(String iid) {
    print("IID " + iid + " recieved");
    if (repo != null && navigation != null) {
      repo!.forceRequest(iid);
      navigation!.reset();
      navigation!.add(iid);
      print("IID reloaded");
    }
  }

  @override
  State<BridgeWrapper> createState() => _BridgeWrapperState();
}

class _BridgeWrapperState extends State<BridgeWrapper> {
  Widget buildText(String str) {
    return Text(str,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            fontWeight: FontWeight.normal, color: Colors.black, fontSize: 20));
  }

  @override
  Widget build(BuildContext context) {
    widget.repo = Provider.of<Repo>(context);
    widget.navigation = Provider.of<Navigation>(context);
    return widget.child;
  }
}
