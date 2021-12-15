import 'package:flutter/material.dart';
import 'package:ipfoam_client/main.dart';
import 'package:ipfoam_client/note.dart';
import 'package:ipfoam_client/repo.dart';
import 'package:ipfoam_client/transforms/colum_navigator.dart';
import 'package:ipfoam_client/transforms/interplanetary_text/interplanetary_text.dart';
import 'package:ipfoam_client/transforms/sub_abstraction_block.dart';
import 'package:ipfoam_client/utils.dart';

class DynamicTransclusionRun implements IptRun {
  @override
  List<IptRun> subIptElements = [];
  late AbstractionReference transformAref;
  List<String> arguments = [];

  DynamicTransclusionRun(List<String> expr) {
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
