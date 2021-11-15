import 'dart:developer';

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
    if (cid == "") {
      log("Invalid CID: " + cid);

      return false;
    }
    return true;
  }

  static bool iidIsValid(String iid) {
    if (iid == "") {
      log("Invalid IID: " + iid);

      return false;
    }
    return true;
  }

  static bool blockIsValid(dynamic block) {
    if (block == "") {
      log("Invalid block");
      return false;
    }
    return true;
  }

  static bool typeIsStruct(Note note) {
    if (note.block != null) {
      if (note.block![Note.primitiveIpldSchema] != null) {
        if (note.block![Note.primitiveIpldSchema]
            .toString()
            .contains(Note.structTypeIdentifier)) {
          return true;
        }
      }
    }
    return false;
  }
}
