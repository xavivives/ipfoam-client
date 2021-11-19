import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ipfoam_client/color_utils.dart';
import 'package:ipfoam_client/main.dart';
import 'dart:convert';

import 'package:ipfoam_client/repo.dart';
import 'package:ipfoam_client/note.dart';
import 'package:provider/provider.dart';

class InterplanetaryTextTransform extends StatelessWidget {
  InterplantearyText ipt = [];

  InterplanetaryTextTransform(this.ipt) {}

  bool isRunATransclusionExpression(String run) {
    return (run.indexOf("[") == 0 && run.indexOf("]") == run.length - 1);
  }

  TextSpan decode(String run, Repo repo) {
    var str = run;
    var arefOrigin;
    if (isRunATransclusionExpression(run)) {
      List<dynamic> expr = json.decode(str);
      //Todo check if there is a nested transclusion
      if (expr.length == 1) {
        //Static transclusion
        var aref = AbstractionReference.fromText(expr[0]);
        arefOrigin = aref.origin;
        str = getTranscludedText(aref, repo);
      } else if (expr.length > 1) {
        //dynamic transclusion
      }

      log("got" + str);

      return TextSpan(
          text: str,
          style: TextStyle(
              color: Colors.black,
              //backgroundColor: Colors.yellow,
              fontWeight: FontWeight.w400,
              background: Paint()
                ..strokeWidth = 10.0
                ..color = getBackgroundColor(arefOrigin)
                ..style = PaintingStyle.fill

                // ..style = PaintingStyle.fill
                ..strokeJoin = StrokeJoin.round));
    }
    return TextSpan(
        text: str,
        style: const TextStyle(
          fontWeight: FontWeight.w300,
        ));
  }

  /*String getTranscludedText(AbstractionReference aref) {
    if (accessibleNotes[aref.origin] == null) {
      return aref.origin;
    } else {
      if (accessibleNotes[aref.origin]?.block?[aref.path?[0]] == null) {
        return aref.origin;
      } else {
        return accessibleNotes[aref.origin]?.block?[aref.path?[0]] as String;
      }
    }
  }*/

  String getTranscludedText(AbstractionReference aref, Repo repo) {
    Note? note;
    String? cid;
    if (aref.isIid()) {
      cid = repo.getCidWrapByIid(aref.iid!).cid;
    } else if (aref.isCid()) {
      cid = aref.cid;
    } else {
      //unknown
      return aref.origin;
    }

    if (cid != null) {
      var noteWrap = repo.getNoteWrapByCid(cid);
      note = noteWrap.note;
    }

    if (note == null) {
      return aref.origin;
    } else if (aref.path != null) {
      //TODO. Only one element of the path is supported

      if (aref.path!.length == 1 && note.block![aref.path![0]] != null) {
        return note.block![aref.path![0]] as String;
      }
    }

    return aref.origin;
  }

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<Repo>(context);
    List<TextSpan> elements = [];

    for (var run in ipt) {
      elements.add(decode(run, repo));
    }
    var text = RichText(
      text: TextSpan(
        style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontFamily: "OpenSans",
            fontWeight: FontWeight.w100,
            height: 1.5),
        children: elements,
      ),
    );

    return text;
  }
}
