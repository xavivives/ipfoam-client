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

  static IptRun makeIptRun(String run) {
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

  static List<IptRun> makeIptRuns(List<String> ipt) {
    List<IptRun> iptRuns = [];
    for (var run in ipt) {
      iptRuns.add(IPTFactory.makeIptRun(run));
    }
    return iptRuns;
  }
}

abstract class IptRun implements IptRender {
  List<IptRun> iptRuns = [];
  bool isPlainText();
  bool isStaticTransclusion();
  bool isDynamicTransclusion();
}

abstract class IptRender {
  TextSpan renderTransclusion(Repo repo, Navigation navigation);
}

abstract class IptTransform {
  List<String> arguments = [];
  String transformIid = "";
}

class IptRoot extends StatelessWidget {
  List<String> ipt = [];
  List<IptRun> iptRuns = [];

  IptRoot(this.ipt) {
    iptRuns = IPTFactory.makeIptRuns(ipt);
  }

  IptRoot.fromArray(List<String> a) {
  ipt = ['["' + a.join('","') + '"]'];
    iptRuns = IPTFactory.makeIptRuns(ipt);
  }

  List<TextSpan> renderIPT(repo, navigation) {
    List<TextSpan> elements = [];
    for (var ipte in iptRuns) {
      elements.add(ipte.renderTransclusion(repo, navigation));
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
