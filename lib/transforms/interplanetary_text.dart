import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ipfoam_client/color_utils.dart';
import 'package:ipfoam_client/main.dart';
import 'package:ipfoam_client/repo.dart';
import 'package:ipfoam_client/note.dart';
import 'package:ipfoam_client/transforms/colum_navigator.dart';
import 'package:ipfoam_client/transforms/ipt.dart';
import 'package:ipfoam_client/transforms/sub_abstraction_block.dart';
import 'package:ipfoam_client/utils.dart';
import 'package:provider/provider.dart';

class InterplanetaryTextTransform extends StatelessWidget {
  List<String> ipt = [];
  List<IptElement> iptElements = [];
  //Keeps a list of its transforms that parent Transforms
  //TODO: INDEX ALL TRANSFORMS

  InterplanetaryTextTransform(this.ipt) {

     for (var run in ipt) {
       iptElements.add(IPTFactory.makeIPTElement(run));
    }

  }
/*
  TextSpan decodeDynamicTransclusion(
      DynamicTransclusionElement texpr, Repo repo, Navigation navigation) {
    var transformAref = texpr.aref;
    var transformNote = Utils.getNote(transformAref, repo);

    if (transformNote != null) {
      if (transformNote.block[Note.propertyTransformIdd]) {
        return applyTransform(transformNote.block[Note.propertyTransformIdd],
            texpr.arguments, repo, navigation);
      }
    }

    return const TextSpan(
        text: "<dynamic transclusion>",
        style: TextStyle(
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
*/

  /*TextSpan decode(String run, Repo repo, Navigation navigation) {
    var str = run;
    List<TextSpan> elements = [];

    if (DynamicTransclusionElement.isRunATransclusionExpression(run)) {
      var texpr = DynamicTransclusionElement.fromExpression(run);
      iptElemnts.add(texpr);
      if (texpr.isStatic()) {
        var t = getTranscludedText(texpr.aref, repo);
        //Plain text 
        if (t.length <= 1) {
          str = t[0];
        }
        //Interplanetary text
        else {
          for (var run in t) {
            elements.add(decode(run, repo, navigation));
          }
          str = "";
        }
      } else if (texpr.isDynamic()) {
        return decodeDynamicTransclusion(texpr, repo, navigation);
      }

      return TextSpan(
          text: str,
          children: elements,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              if (texpr.aref != null && texpr.aref.iid != null) {
                navigation.add(texpr.aref.iid!);
              }
            },
          style: TextStyle(
              color: Colors.black,
              //backgroundColor: Colors.yellow,
              fontWeight: FontWeight.w400,
              background: Paint()
                ..strokeWidth = 10.0
                ..color = getBackgroundColor(texpr.aref.origin)
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
  */

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

  /*List<String> getTranscludedText(AbstractionReference aref, Repo repo) {
    var note = Utils.getNote(aref, repo);

    if (note == null) {
      return [aref.origin];
    } else if (aref.tiid != null) {
      if (note.block[aref.tiid] != null) {
        //TODO verify what type is
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
  */

  List<TextSpan> renderIPT(repo, navigation) {
    List<TextSpan> elements = [];
    for (var ipte in iptElements) {
      elements.add(ipte.getTranscludedOuput(repo,navigation));
    }
    return elements;
  }

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<Repo>(context);
    final navigation = Provider.of<Navigation>(context);
    var text = SelectableText.rich(TextSpan(
      style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontFamily: "OpenSans",
          fontWeight: FontWeight.w100,
          fontStyle: FontStyle.normal, //TODO: Use FontStyle.normal. Flutter bug
          height: 1.7),
      children: renderIPT(repo, navigation),
    ));

    return text;
  }
}
