import 'package:flutter/material.dart';
import 'package:ipfoam_client/main.dart';
import 'package:ipfoam_client/note.dart';
import 'package:ipfoam_client/repo.dart';
import 'package:ipfoam_client/transforms/colum_navigator.dart';
import 'package:ipfoam_client/transforms/interplanetary_text/interplanetary_text.dart';
import 'package:ipfoam_client/transforms/interplanetary_text/plain_text_run.dart';
import 'package:ipfoam_client/transforms/sub_abstraction_block.dart';
import 'package:ipfoam_client/utils.dart';

class DynamicTransclusionRun implements IptRun {
  @override
  List<IptRun> iptRuns = []; //TODO unused?
  late AbstractionReference transformAref;
  List<dynamic> arguments = [];

  DynamicTransclusionRun(List<dynamic> expr) {
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
  TextSpan renderTransclusion(Repo repo, Navigation navigation) {
    var transformNote = Utils.getNote(transformAref, repo);
    var text = "<Unfound dynamic transclusion: " + transformAref.origin + " >";
    if (transformNote != null) {
      if (transformNote.block[Note.iidPropertyTransform]) {
        return applyTransform(
            transformNote.block[Note.iidPropertyTransform], repo, navigation);
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
      String transformId, Repo repo, Navigation navigation) {
    IptRender transform = PlainTextRun("<" + transformId + " not implemented>");
    if (transformId == Note.transFilter) {
      //TODO
    } else if (transformId == Note.transSubAbstractionBlock) {
      transform = SubAbstractionBlock(arguments, repo);
    }

    return transform.renderTransclusion(repo, navigation);
  }
}
