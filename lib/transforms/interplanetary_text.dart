import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ipfoam_client/color_utils.dart';
import 'package:ipfoam_client/main.dart';
import 'dart:convert';

import 'package:ipfoam_client/repo.dart';
import 'package:ipfoam_client/note.dart';
import 'package:ipfoam_client/transforms/colum_navigator.dart';
import 'package:ipfoam_client/transforms/sub_abstraction_block.dart';
import 'package:ipfoam_client/utils.dart';
import 'package:provider/provider.dart';

class InterplanetaryTextTransform extends StatelessWidget {
  List<String> ipt = [];

  InterplanetaryTextTransform(this.ipt) {}

  bool isRunATransclusionExpression(String run) {
    return (run.indexOf("[") == 0 && run.indexOf("]") == run.length - 1);
  }

  TextSpan decodeDynamicTransclusion(List<String> expr, Repo repo) {
    var transformAref = AbstractionReference.fromText(expr[0]);
    var transformNote = Utils.getNote(transformAref, repo);
  
    if (transformNote != null) {

      if (transformNote.block![Note.propertyTransformIdd]) {
        return applyTransform(transformNote.block![Note.propertyTransformIdd],
            expr.sublist(1, expr.length), repo);
      }
    }

    return TextSpan(
        text: "<dynamic transclusion>",
        style: const TextStyle(
          fontWeight: FontWeight.w300,
        ));
  }

  TextSpan applyTransform(String transformId, List<String> expr, Repo repo) {
    if(transformId==Note.transFilter){
      //TODO
    }
    else if(transformId==Note.transSubAbstractionBlock){
      print("HERE");
      var transcludedNoteAref = AbstractionReference.fromText(expr[0]);
      var block =  SubAbstractionBlock(transcludedNoteAref, 0, repo  );
      return block.renderIPT();
     
    }

    return TextSpan(
        text: "<"+transformId+" not implemented>",
        style: const TextStyle(
          fontWeight: FontWeight.w300,
        ));
  }

  TextSpan decode(String run, Repo repo, Navigation navigation) {
    var str = run;
    List<TextSpan> elements = [];

    if (isRunATransclusionExpression(run)) {
      AbstractionReference aref = AbstractionReference.fromText("");
      List<String> expr = json.decode(str);
      //Todo check if there is a nested transclusion
      if (expr.length == 1) {
        //Static transclusion
        aref = AbstractionReference.fromText(expr[0]);
        // arefOrigin = aref.origin;
        var t = getTranscludedText(aref, repo);
        //simple transclusion
        if (t.length <= 1) {
          str = t[0];
        }
        //ipt trasnclusion
        else {
          for (var run in t) {
            elements.add(decode(run, repo, navigation));
          }
          str = "";
        }
      } else if (expr.length > 1) {
        return decodeDynamicTransclusion(expr, repo);
      }

      return TextSpan(
          text: str,
          children: elements,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              if (aref != null && aref.iid != null) {
                navigation.add(aref.iid!);
              }
            },
          style: TextStyle(
              color: Colors.black,
              //backgroundColor: Colors.yellow,
              fontWeight: FontWeight.w400,
              background: Paint()
                ..strokeWidth = 10.0
                ..color = getBackgroundColor(aref.origin)
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



  List<String> getTranscludedText(AbstractionReference aref, Repo repo) {
    var note = Utils.getNote(aref, repo);

    if (note == null) {
      return [aref.origin];
    } else if (aref.tiid != null) {
      if (note.block![aref.tiid] != null) {
        //TODO verify what type is
        try {
          //Transcluded text
          return [note.block![aref.tiid] as String];
        } catch (e) {
          //Transcluded transclusion (ipt)
          return note.block![aref.tiid];
        }
      }
    }

    return [aref.origin];
  }

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<Repo>(context);
    final navigation = Provider.of<Navigation>(context);
    List<TextSpan> elements = [];

    for (var run in ipt) {
      elements.add(decode(run, repo, navigation));
    }
    var text = SelectableText.rich(
      TextSpan(
        style: const TextStyle(
            fontSize: 12,
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
