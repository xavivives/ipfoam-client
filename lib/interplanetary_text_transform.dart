import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ipfoam_client/color_utils.dart';
import 'package:ipfoam_client/main.dart';
import 'dart:convert';

class InterplanetaryTextTransform extends StatelessWidget {
  InterplantearyText ipt;
  NoteRequester? requester;

  InterplanetaryTextTransform({required this.ipt, this.requester}) {}

  TextSpan decode(String run) {
    var str = run;
    var arefOrigin;
    if (run.indexOf("[") == 0 && run.indexOf("]") == run.length - 1) {
      List<dynamic> expr = json.decode(str);
      //Todo check if there is a nested transclusion
      if (expr.length == 1) {
        //Static transclusion
        var aref = AbstractionReference.fromText(expr[0]);
        arefOrigin = aref.origin;
        str = getTranscludedText(aref);
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

  String getTranscludedText(AbstractionReference aref) {
    var note = Repo.getNoteByAref(aref);
    if (note.block != null) {
      if (note.block![aref.path] != null) {
        if (note.block![aref.path![0]] != null) {
          return note.block![aref.path![0]] as String;
        }
      }
    }
    return aref.origin;
  }

  @override
  Widget build(BuildContext context) {
    List<TextSpan> elements = [];

    for (var t in ipt) {
      elements.add(decode(t));
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
