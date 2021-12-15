import 'package:flutter/material.dart';
import 'package:ipfoam_client/main.dart';
import 'package:ipfoam_client/repo.dart';
import 'package:ipfoam_client/note.dart';
import 'package:ipfoam_client/transforms/interplanetary_text/interplanetary_text.dart';
import 'package:ipfoam_client/utils.dart';

class SubAbstractionBlock {
  final AbstractionReference aref;
  final int level;
  final Repo repo;
  List<SubAbstractionBlock> registry = [];

  SubAbstractionBlock(this.aref, this.level, this.repo);

  TextSpan renderIPT(repo, navigation) {
    var note = Utils.getNote(aref, repo);
    List<TextSpan> blocks = [];
    if (note != null) {
      if (note.block[Note.propertyTitleIdd]) {
        blocks.add(renderTitle(note.block[Note.propertyTitleIdd]));
        blocks.add(renderLineJump());
      }
      if (note.block[Note.propertyAbstractIdd]) {
        blocks.add(renderAbstract(
            note.block[Note.propertyAbstractIdd], repo, navigation));
        blocks.add(renderLineJump());
      }
      if (note.block[Note.propertyViewIdd]) {
        blocks.add(
            renderView(note.block[Note.propertyViewIdd], repo, navigation));
        blocks.add(renderLineJump());
      }
      return TextSpan(children: blocks);
    }
    return const TextSpan(
        text: "<Sub-abstraction block>",
        style: TextStyle(
          fontWeight: FontWeight.w300,
        ));
  }

  TextSpan renderLineJump() {
    return const TextSpan(text: "\n\n");
  }

  TextSpan renderTitle(String str) {
    return TextSpan(
        text: str,
        style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 36,height: 1.2));
  }

  TextSpan renderAbstract(List<String> ipt, repo, navigation) {
    var a = InterplanetaryTextTransform(ipt);

    var text = a.renderIPT(repo, navigation);
    return TextSpan(
        children: text,
        style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.italic,
            color: Colors.grey));
  }

  TextSpan renderView(List<String> ipt, repo, navigation) {
    var a = InterplanetaryTextTransform(ipt);

    var text = a.renderIPT(repo, navigation);
    return TextSpan(
        children: text,
      );
  }
}
