import 'package:flutter/cupertino.dart';
import 'package:ipfoam_client/main.dart';

class InterplanetaryTextTransform extends StatelessWidget {
  InterplantearyText ipt;
  List<NoteWrap> accessibleNotes;
  NoteRequester requester;

  InterplanetaryTextTransform(
      {required this.ipt,
      required this.accessibleNotes,
      required this.requester}) {}

  Widget build(BuildContext context) {
    const List<TextSpan> elements = [];
    for (var t in ipt) {
      elements.add(TextSpan(
          text: t, style: const TextStyle(fontWeight: FontWeight.bold)));
    }
    var text = RichText(
      text: const TextSpan(
        // Note: Styles for TextSpans must be explicitly defined.
        // Child text spans wills inherit styles from parent
        style: TextStyle(
          fontSize: 14.0,
          // color: Colors.black,
        ),
        children: elements,
      ),
    );

    return text;
  }
}
