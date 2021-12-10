import 'package:flutter/material.dart';
import 'package:ipfoam_client/main.dart';
import 'package:ipfoam_client/repo.dart';
import 'package:ipfoam_client/note.dart';
import 'package:ipfoam_client/utils.dart';

class SubAbstractionBlock {
  final AbstractionReference aref;
  final  int  level ;
  final Repo repo;

  SubAbstractionBlock( this.aref, this.level, this.repo );

  TextSpan renderIPT(){
    var note = Utils.getNote(aref, repo);
    List<TextSpan> blocks = [];
    if(note!=null){
      if(note.block[Note.propertyTitleIdd]){
        blocks.add(renderTitle(note.block[Note.propertyTitleIdd]));
        blocks.add(renderLineJump());
      }
      if(note.block[Note.propertyAbstractIdd]){
          blocks.add(renderAbstract(note.block[Note.propertyAbstractIdd]));
          blocks.add(renderLineJump());
      }
      if(note.block[Note.propertyViewIdd]){
          blocks.add(renderView(note.block[Note.propertyViewIdd]));
          blocks.add(renderLineJump());
      }
      return TextSpan(children: blocks);
    }
  return renderView("<Sub-abstraction block>");
  }
  
  TextSpan renderLineJump() {
    return  const TextSpan(
        text: "\n",
       );
  }
  TextSpan renderTitle(String str) {
    return   TextSpan(
        text: str,
        style: const TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 20
        ));
  }

  TextSpan renderAbstract(String str) {
    return   TextSpan(
        text: str,
        style: const TextStyle(
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.italic
        ));
  }

  TextSpan renderView(String str) {
    return   TextSpan(
        text: str,
        style: const TextStyle(
          fontWeight: FontWeight.w300,
        ));
  }
}
