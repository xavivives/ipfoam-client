import 'dart:developer';

import 'package:ipfoam_client/note.dart';

class Repo {
  static Map<String, CidWrap> cids = {};
  static Map<String, IidWrap> iids = {};

  static void addNoteForCid(String cid, Note? note) {
    cids[cid] ??= CidWrap(cid);
    cids[cid]?.note = note;
    if (note == null)
      cids[cid]?.status = RequestStatus.missing;
    else
      cids[cid]?.status = RequestStatus.loaded;
    log("Added cid " + cid + " Status: " + cids[cid]!.status.toString());
  }

  static void addCidForIid(String iid, String? cid) {
    iids[iid] ??= IidWrap(iid);
    iids[iid]?.cid = cid;
    if (cid == null) {
      iids[iid]?.status = RequestStatus.missing;
    } else {
      iids[iid]?.status = RequestStatus.loaded;
    }
    log("Added iid " + iid + " Status: " + iids[iid]!.status.toString());
  }

  static CidWrap getNoteWrapByCid(String cid) {
    cids[cid] ??= CidWrap(cid);
    if (cids[cid]!.status == RequestStatus.undefined) ;
    {
      cids[cid]!.status = RequestStatus.needed;
    }
    log("Returned note for cid " +
        cid +
        " Status: " +
        cids[cid]!.status.toString());

    return cids[cid]!;
  }

  static IidWrap getCidWrapByIid(String iid) {
    log("here");
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

//undefined: default state. Is only in this state if no action has been done
//needed: A Transform manifested it wants it. But no attempt of getting it  has been done
//requested: It has been requested to an outside source but have not response yet
//missing: The outside source has returned an emptty request , regardless of the reason. Should not expect the source to have it under the same conditions
//loaded: Its loaded and stred in Repo
//failed: The request failed (ex: connectivity issues).
//invalid: The item requested or the content returned is invalid
enum RequestStatus {
  undefined,
  needed,
  requested,
  missing,
  loaded,
  failed,
  invalid
}

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
