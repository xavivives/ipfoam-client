import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ipfoam_client/color_utils.dart';
import 'package:ipfoam_client/main.dart';
import 'package:ipfoam_client/repo.dart';
import 'package:ipfoam_client/transforms/colum_navigator.dart';
import 'package:ipfoam_client/transforms/interplanetary_text/interplanetary_text.dart';
import 'package:ipfoam_client/utils.dart';

class StaticTransclusionRun implements IptRun {
  late AbstractionReference aref;
  List<IptRun> subIptElements = [];

  StaticTransclusionRun(List<String> expr) {
    aref = AbstractionReference.fromText(expr[0]);
  }

  @override
  bool isStaticTransclusion() {
    return true;
  }

  @override
  bool isDynamicTransclusion() {
    return false;
  }

  @override
  bool isPlainText() {
    return false;
  }

  List<String> getTranscludedText(Repo repo) {
    var note = Utils.getNote(aref, repo);

    if (note != null && aref.tiid != null) {
      if (note.block[aref.tiid] != null) {
        //TODO verify what property type is it
        try {
          //Transcluded text
          return [note.block[aref.tiid] as String];
        } catch (e) {
          //Transcluded transclusion (ipt)
          return note.block[aref.tiid];
        }
      }
    }

    return [aref.origin];
  }

  @override

  TextSpan renderTransclusion(Repo repo, Navigation navigation) {
    var text = "";
    var t = getTranscludedText(repo);
    List<TextSpan> elements = [];
    // Plain text/ leaf of Interplanetary text
    if (t.length <= 1) {
      text = t[0];
    }
    //Interplanetary text
    else {
      for (var ipte in subIptElements) {
        elements.add(ipte.renderTransclusion(repo, navigation));
      }
    }
    return TextSpan(
        text: text,
        children: elements,
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            if (aref.iid != null) {
              navigation.add(aref.iid!);
            }
          },
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            background: Paint()
              ..strokeWidth = 10.0
              ..color =  getBackgroundColor(aref.origin)
              ..style = PaintingStyle.fill
              ..strokeJoin = StrokeJoin.round));
  }
}
