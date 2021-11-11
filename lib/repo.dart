import 'dart:developer';

import 'package:ipfoam_client/main.dart';

class Repo {
  static Map<String, CidWrap> cids = {};
  static Map<String, IidWrap> iids = {};

  static void addNoteForCid(String cid, Note? note) {
    cids[cid] ??= CidWrap(cid);
    cids[cid]?.note = note;
    log("Added cid " + cid + " Status: " + cids[cid]!.status.toString());
  }

  static void addCidForIid(String iid, String? cid) {
    iids[iid] ??= IidWrap(iid);
    iids[iid]?.cid = cid;
    log("Added iid " + iid + " Status: " + iids[iid]!.status.toString());
  }

  static CidWrap getNoteWrapByCid(String cid) {
    cids[cid] ??= CidWrap(cid);
    if (cids[cid]!.status == RequestStatus.undefined) ;
    {
      cids[cid]!.status = RequestStatus.needed;
    }
    log("Returned not for cid " +
        cid +
        " Status: " +
        cids[cid]!.status.toString());

    return cids[cid]!;
  }

  static IidWrap getCidWrapByIid(String iid) {
    iids[iid] ??= IidWrap(iid);
    if (iids[iid]!.status == RequestStatus.undefined) ;
    {
      iids[iid]!.status = RequestStatus.needed;
    }
    log("Returned cid " +
        iids[iid]!.cid.toString() +
        " for iid " +
        iid +
        " Status: " +
        iids[iid]!.status.toString());
    return iids[iid]!;
  }
}

enum RequestStatus { undefined, needed, requested, loaded, invalid, failed }

class CidWrap {
  DateTime? lastRequest;
  RequestStatus status = RequestStatus.undefined;
  String cid;
  Note? note;

  CidWrap(this.cid);
  CidWrap.invalid(this.cid) {
    status = RequestStatus.invalid;
  }
}

class IidWrap {
  DateTime? lastRequest;
  RequestStatus status = RequestStatus.undefined;
  String iid;
  String? cid;

  IidWrap(this.iid);
  IidWrap.invalid(this.iid) {
    status = RequestStatus.invalid;
  }
}
