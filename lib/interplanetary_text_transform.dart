import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:ipfoam_client/main.dart';
import 'dart:convert';

class InterplanetaryTextTransform extends StatelessWidget {
  InterplantearyText ipt;
  List<NoteWrap> accessibleNotes;
  NoteRequester? requester;

  InterplanetaryTextTransform(
      {required this.ipt, required this.accessibleNotes, this.requester}) {}

  TextSpan decode(String element) {
    var str = element;
    if (element.indexOf("[") == 0 &&
        element.indexOf("]") == element.length - 1) {
      List<dynamic> expr = json.decode(str);
      //todo parse instead
      str = expr.join();

      return TextSpan(
          text: str,
          style:
              const TextStyle(color: Colors.red, fontWeight: FontWeight.w400));
    }
    return TextSpan(
        text: str,
        style: const TextStyle(
          fontWeight: FontWeight.w300,
        ));
  }

  @override
  Widget build(BuildContext context) {
    List<TextSpan> elements = [];

    for (var t in ipt) {
      elements.add(decode(t));
    }
    var text = RichText(
      text: TextSpan(
        style: const TextStyle(
            fontSize: 20,
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
