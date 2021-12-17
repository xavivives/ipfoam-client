import 'package:flutter/material.dart';
import 'package:ipfoam_client/main.dart';
import 'package:ipfoam_client/repo.dart';
import 'package:ipfoam_client/note.dart';
import 'package:ipfoam_client/transforms/interplanetary_text/dynamic_transclusion_run.dart';
import 'package:ipfoam_client/transforms/interplanetary_text/interplanetary_text.dart';
import 'package:ipfoam_client/utils.dart';

class SubAbstractionBlock implements IptRender, IptTransform {
  AbstractionReference aref = AbstractionReference.fromText("");
  int level = 0;
  final Repo repo;
  static const iid= "i2lf4dbua";
  @override
  String transformIid =iid;
  @override
  List<String> arguments;

  SubAbstractionBlock(this.arguments, this.repo) {
    processArguments();
  }

  void processArguments() {
    //HERE
    //check for arguments length
    //empty level fails

    //Note to transclude
    if (arguments.length == 0) {
      aref = AbstractionReference.fromText("");
    }
    if (arguments.length == 1) {
      level = -1;
    }

    aref = AbstractionReference.fromText(arguments[0]);

    //Level of indentation
    level = getLevelFromArgument(arguments[1]);
    if (level == -1) level = 0;
  }

  int getLevelFromArgument(String value) {
    var l = int.tryParse(value);
    if (l == null) {
      return -1;
    }
    return l;
  }

  void updateChildren() {}

  @override
  TextSpan renderTransclusion(repo, navigation) {
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
         // fontWeight: FontWeight.w300,
        ));
  }

  TextSpan renderLineJump() {
    return const TextSpan(text: "\n\n");
  }

  double titleFontSizeByLevel() {
    double rootSize = 42;
    double decrease = 8;
    double size = rootSize - (decrease * level);
    if (size < 16) {
      size = 16;
    }
    return size;
  }

  FontWeight titleFontWeightByLevel() {
    return FontWeight.w600;
    if (level == 0) {
      return FontWeight.w400;
    }
    if (level == 1) {
      return FontWeight.w200;
    }
    if (level == 2) {
      return FontWeight.w100;
    }
  }

  TextStyle titleStyleByLevel() {
    return TextStyle(
        fontWeight: titleFontWeightByLevel(),
        fontSize: titleFontSizeByLevel(),
        color: const Color.fromRGBO(50,50,50,1),
        height: 1.2);
  }

  TextSpan renderTitle(String str) {
    return TextSpan(text: str, style: titleStyleByLevel());
  }

  TextSpan renderAbstract(List<String> ipt, repo, navigation) {
    var a = IptRoot(ipt);

    var text = a.renderIPT(repo, navigation);
    return TextSpan(
        children: text,
        style: const TextStyle(
            //fontWeight: FontWeight.w300,
            fontStyle: FontStyle.italic,
            color: Colors.grey));
  }

  TextSpan renderView(List<String> ipt, repo, navigation) {
    var iptRuns = IPTFactory.makeIptRuns(ipt);

    List<TextSpan> elements = [];
    for (var i = 0; i < iptRuns.length; i++) {
      var run = iptRuns[i];

      if (run.isDynamicTransclusion()) {
        var dynamicRun = run as DynamicTransclusionRun;
        if (dynamicRun.transformAref.iid == transformIid) {
          var childLevel = getLevelFromArgument(run.arguments[1]);
          if (childLevel == -1) {
            childLevel = this.level + 1;
          }
          var newArguments = run.arguments;
          newArguments[1] = childLevel.toString();
          (iptRuns[i] as DynamicTransclusionRun).arguments = newArguments;
        }
      }
      elements.add(run.renderTransclusion(repo, navigation));
    }

    return TextSpan(
      children: elements,
    );
  }
}
