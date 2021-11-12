import 'package:ipfoam_client/note.dart';

class Utils {
  static List<String> getIddTypesForBlock(Map<String, dynamic> block) {
    List<String> typesIids = [];

    block.forEach((key, value) {
      List<String> primitiveTypes = [
        Note.primitiveConstrains,
        Note.primitiveDefaultName,
        Note.primitiveIpldSchema,
        Note.primitiveRepresents
      ];
      if (primitiveTypes.contains(key) == false) typesIids.add(key);
    });
    return typesIids;
  }

  static bool cidIsValid(String cid) {
    if (cid == "") return false;
    return true;
  }

  static bool iidIsValid(String iid) {
    if (iid == "") return false;
    return true;
  }

  static bool blockIsValid(dynamic block) {
    if (block != "") return false;
    return true;
  }
}
