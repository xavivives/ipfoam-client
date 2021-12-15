import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ipfoam_client/repo.dart';
import 'package:ipfoam_client/transforms/colum_navigator.dart';
import 'package:ipfoam_client/transforms/interplanetary_text/dynamic_transclusion_run.dart';
import 'package:ipfoam_client/transforms/interplanetary_text/plain_text_run.dart';
import 'package:ipfoam_client/transforms/interplanetary_text/static_transclusion_run.dart';
import 'package:provider/provider.dart';

class IPTFactory {
  static bool isRunATransclusionExpression(String run) {
    return (run.indexOf("[") == 0 && run.indexOf("]") == run.length - 1);
  }

  static IptRun makeIPTElement(String run) {
    if (IPTFactory.isRunATransclusionExpression(run)) {
      List<String> expr = json.decode(run);

      if (expr.length == 1) {
        return StaticTransclusionRun(expr);
      }
      if (expr.length > 1) {
        return DynamicTransclusionRun(expr);
      }
    }
    return PlainTextRun(run);
  }
}

abstract class IptRun {
  List<IptRun> subIptElements = [];
  bool isPlainText();
  bool isStaticTransclusion();
  bool isDynamicTransclusion();
  TextSpan renderTransclusion(Repo repo, Navigation navigation);
}



class InterplanetaryTextTransform extends StatelessWidget {
  List<String> ipt = [];
  List<IptRun> iptElements = [];

  InterplanetaryTextTransform(this.ipt) {

     for (var run in ipt) {
       iptElements.add(IPTFactory.makeIPTElement(run));
    }

  }
  List<TextSpan> renderIPT(repo, navigation) {
    List<TextSpan> elements = [];
    for (var ipte in iptElements) {
      elements.add(ipte.renderTransclusion(repo,navigation));
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
