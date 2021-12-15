import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ipfoam_client/color_utils.dart';
import 'package:ipfoam_client/main.dart';
import 'package:ipfoam_client/note.dart';
import 'package:ipfoam_client/repo.dart';
import 'package:ipfoam_client/transforms/colum_navigator.dart';
import 'package:ipfoam_client/transforms/sub_abstraction_block.dart';
import 'package:ipfoam_client/utils.dart';

class IPTFactory {
  static bool isRunATransclusionExpression(String run) {
    return (run.indexOf("[") == 0 && run.indexOf("]") == run.length - 1);
  }

  static IptElement makeIPTElement(String run) {
    if (IPTFactory.isRunATransclusionExpression(run)) {
      List<String> expr = json.decode(run);

      if (expr.length == 1) {
        return StaticTransclusionElement(expr);
      }
      if (expr.length > 1) {
        return DynamicTransclusionElement(expr);
      }
    }
    return PlainTextElement(run);
  }
}

abstract class IptElement {
  List<IptElement> subIptElements = [];
  bool isPlainText();
  bool isStaticTransclusion();
  bool isDynamicTransclusion();
  TextSpan getTranscludedOuput(Repo repo, Navigation navigation);
}

class DynamicTransclusionElement implements IptElement {
  @override
  List<IptElement> subIptElements = [];
  late AbstractionReference transformAref;
  List<String> arguments = [];

  DynamicTransclusionElement(List<String> expr) {
    transformAref = AbstractionReference.fromText(expr[0]);
    arguments = expr.sublist(1, expr.length);
  }

  @override
  bool isStaticTransclusion() {
    return false;
  }

  @override
  bool isDynamicTransclusion() {
    return true;
  }

  @override
  bool isPlainText() {
    return false;
  }

  @override
  TextSpan getTranscludedOuput(Repo repo, Navigation navigation) {
    var transformNote = Utils.getNote(transformAref, repo);
    var text = "<dynamic transclusion>";
    if (transformNote != null) {
      if (transformNote.block[Note.propertyTransformIdd]) {
        return applyTransform(transformNote.block[Note.propertyTransformIdd],
            arguments, repo, navigation);
      } else {
        text = "<dynamic transclusion with unkown transform>";
      }
    }

    return TextSpan(
        text: text,
        style: const TextStyle(
          fontWeight: FontWeight.w300,
        ));
  }

  TextSpan applyTransform(
      String transformId, List<String> expr, Repo repo, Navigation navigation) {
    if (transformId == Note.transFilter) {
      //TODO
    } else if (transformId == Note.transSubAbstractionBlock) {
      var transcludedNoteAref = AbstractionReference.fromText(expr[0]);
      var block = SubAbstractionBlock(transcludedNoteAref, 0, repo);
      return block.renderIPT(repo, navigation);
    }

    return TextSpan(
        text: "<" + transformId + " not implemented>",
        style: const TextStyle(
          fontWeight: FontWeight.w300,
        ));
  }
}

class StaticTransclusionElement implements IptElement {
  late AbstractionReference aref;
  List<IptElement> subIptElements = [];

  StaticTransclusionElement(List<String> expr) {
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
  //Static transclusion can output either IPT or plain text
  //Should all the leaves of the IPTTree be plain text?
  //When is the sub-IPTTree built? on build()?

  //Cleanup interplantary_text.dart. should be deleted and replaced by the factory

  TextSpan getTranscludedOuput(Repo repo, Navigation navigation) {
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
        elements.add(ipte.getTranscludedOuput(repo, navigation));
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

class PlainTextElement implements IptElement {
  String text;
  List<IptElement> subIptElements = [];
  PlainTextElement(this.text);

  @override
  bool isStaticTransclusion() {
    return false;
  }

  @override
  bool isDynamicTransclusion() {
    return false;
  }

  @override
  bool isPlainText() {
    return true;
  }

  @override
  TextSpan getTranscludedOuput(Repo repo, Navigation navigation) {
    return TextSpan(
        text: text,
        style: const TextStyle(
          fontWeight: FontWeight.w300,
        ));
  }
}
