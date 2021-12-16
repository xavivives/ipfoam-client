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
  @override
  String transformIid = "i2lf4dbua";
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
    if (arguments[0].isNotEmpty) {
      aref = AbstractionReference.fromText(arguments[0]);
    }

    //Level of indentation
    level = getLevelFromArgument(arguments[1]);
  }

  int getLevelFromArgument(String argument) {
    print(argument);
    if (argument == null) {
      return 0;
    } else {
      return int.parse(arguments[1]); //if empty or not number will be zero
    }
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
          fontWeight: FontWeight.w300,
        ));
  }

  TextSpan renderLineJump() {
    return const TextSpan(text: "\n\n");
  }

  double titleFontSizeByLevel() {
    double rootSize = 36;
    double decrease = 6;
    return rootSize - (decrease * level);
  }

  FontWeight titleFontWeightByLevel() {
   if(level==0){
     return FontWeight.w800;
   }
   if(level==1){
     return FontWeight.w600;
   }
   if(level==2){
     return FontWeight.w400;
   }

     return FontWeight.w300;
   
   
  }

  TextSpan renderTitle(String str) {
    return TextSpan(
        text: str,
        style: TextStyle(
            fontWeight: titleFontWeightByLevel(),
            fontSize: titleFontSizeByLevel(),
            height: 1.2));
  }

  TextSpan renderAbstract(List<String> ipt, repo, navigation) {
    var a = IptRoot(ipt);

    var text = a.renderIPT(repo, navigation);
    return TextSpan(
        children: text,
        style: const TextStyle(
            fontWeight: FontWeight.w300,
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
          if (childLevel == 0) {
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
