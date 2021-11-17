import 'package:flutter/material.dart';
import 'package:ipfoam_client/main.dart';
import 'package:ipfoam_client/repo.dart';
import 'package:ipfoam_client/note.dart';
import 'package:provider/provider.dart';

class AbstractionReferenceLink extends StatelessWidget {
  final AbstractionReference aref;

  AbstractionReferenceLink({required this.aref});

  Widget buildText(String str) {
    return Text(str,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 20));
  }

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<Repo>(context);

    IidWrap? iidWrap;
    CidWrap? cidWrap;
    String str;

    if (aref.isIid()) {
      iidWrap = repo.getCidWrapByIid(aref.iid!);
      str = aref.iid!;
      if (iidWrap.cid != null) {
        str = iidWrap.cid!;
        cidWrap = repo.getNoteWrapByCid(iidWrap.cid!);
      }
    } else if (aref.isCid()) {
      cidWrap = repo.getNoteWrapByCid(aref.cid!);
      str = aref.cid!;
    } else {
      str = "Null";
    }

    if (cidWrap != null &&
        cidWrap.note != null &&
        cidWrap.note!.block != null &&
        cidWrap.note!.block![Note.propertyTitleIdd] != null) {
      str = cidWrap.note!.block![Note.propertyTitleIdd];
    }

    return buildText(str);
  }
}
