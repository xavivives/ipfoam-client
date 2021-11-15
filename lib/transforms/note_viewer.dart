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

  Widget buildPropertyRow(String typeIid, String content, Repo repo) {
    Note? typeNote;
    String propertyName = typeIid;
    String? cid = repo.getCidWrapByIid(typeIid).cid;
    if (cid != null) {
      typeNote = repo.getNoteWrapByCid(cid).note;
      if (typeNote != null) {
        propertyName = typeNote.block![Note.primitiveDefaultName];
      }
    } else {}

    return Column(
      children: [
        buildPropertyText(propertyName),
        buildContent(typeNote, content)
      ],
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  Widget buildPropertyText(String typeIid) {
    String str = typeIid;

    return Text(str,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 20));
  }

  Widget buildContent(Note? typeNote, String content) {
    return Text(content,
        textAlign: TextAlign.left,
        overflow: TextOverflow.visible,
        style: const TextStyle(
            fontWeight: FontWeight.normal, color: Colors.black, fontSize: 20));
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

    List<Widget> items = [];

    cidWrap.note!.block!.forEach((key, value) {
      items.add(buildPropertyRow(key, value.toString(), repo));
    });

    return SizedBox(
      width: 600,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          // padding: const EdgeInsets.all(8),
          children: items,
        ),
      ),
    );
  }
}
