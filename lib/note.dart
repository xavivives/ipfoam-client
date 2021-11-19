import 'dart:convert';

class Note {
  static const String primitiveDefaultName = "defaultName";
  static const String primitiveRepresents = "represents";
  static const String primitiveConstrains = "constrains";
  static const String primitiveIpldSchema = "ipldSchema";
  static const String structTypeIdentifier = "type root struct {";
  static const String basicTypeInterplanetaryText = "interplanetary-text";
  static const String basicTypeString = "string";
  static const String basicTypeDate = "date";
  static const String basicTypeAbstractionReference = "abstraction-reference";
  static const String basicTypeAbstractionReferenceList =
      "abstraction-reference-list";
  static const String basicTypeBoolean = "boolean";
  static const String basicTypeUrl = "url";
  static const String propertyTitleIdd =
      "iqz3qlkca"; //This is a hack only valid for my Repo
  String cid;
  Map<String, dynamic>? block = {};
  //Bytes: bites//Todo, it could be arbitrary content theoretically

  Note({required this.cid, this.block});

  Note.fromJSONU(this.cid, String jsonBlock) {
    block = json.decode(jsonBlock) as Map<String, dynamic>;
  }
}

class NoteType {
  String iid;
  String cid;
  String? defaultName;
  String? represents;
  List<String>? constrains;
  String? ipldSchema;

  NoteType(this.iid, this.cid, Map<String, Object> block) {
    defaultName = block[Note.primitiveDefaultName] as String;
    represents = block[Note.primitiveRepresents] as String;
    constrains = block[Note.primitiveConstrains] as List<String>;
    ipldSchema = block[Note.primitiveIpldSchema] as String;
  }
}
