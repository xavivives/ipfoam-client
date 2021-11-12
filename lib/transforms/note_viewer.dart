import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ipfoam_client/repo.dart';
import 'package:ipfoam_client/note.dart';
import 'package:provider/provider.dart';

class NoteViewer extends StatelessWidget {
  final String iid;

  NoteViewer({required this.iid});

  String getStatusText(String? iid, String? cid, Note? note) {
    return "IID: " +
        iid.toString() +
        "\nCID: " +
        cid.toString() +
        "\nNOTE: " +
        note.toString();
  }

  Widget buildPropertyRow(String key, String value) {
    return Column(
      children: [Text(key), Text(value)],
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<Repo>(context);

    IidWrap iidWrap = repo.getCidWrapByIid(iid);

    if (iidWrap.cid == null) {
      return Text(getStatusText(iid, iidWrap.cid, null));
    }
    CidWrap cidWrap = repo.getNoteWrapByCid(iidWrap.cid!);

    if (cidWrap.note == null) {
      return Text(getStatusText(iid, iidWrap.cid, cidWrap.note));
    }

    List<Widget> items = [Text("Hello")];

    cidWrap.note!.block!.forEach((key, value) {
      log("key:" + key);
      items.add(buildPropertyRow(key, value.toString()));
    });

    return ListView(
        // padding: const EdgeInsets.all(8),
        children: items);
  }
}
