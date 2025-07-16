// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'gst_response.g.dart';

@JsonSerializable(explicitToJson: true)
class GSTResponse {
  bool? flag;
  String? message;
  Data? data;

  GSTResponse({this.flag, this.message, this.data});

  factory GSTResponse.fromJson(Map<String, dynamic> json) =>
      _$GSTResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GSTResponseToJson(this);

  @override
  String toString() =>
      'GSTResponse(flag: $flag, message: $message, data: ${data?.toString()})';
}

@JsonSerializable(explicitToJson: true)
class Data {
  List<String>? nba;
  String? sts;
  String? rgdt;
  String? errorMsg;
  String? lstupdt;
  String? ctj;
  String? frequencyType;
  String? ctb;
  String? gstin;
  String? stjCd;
  String? ctjCd;
  String? dty;
  String? tradeNam;
  Pradr? pradr;
  List<String>? adadr;
  String? lgnm;
  String? stj;
  String? cxdt;

  Data({
    this.nba,
    this.sts,
    this.rgdt,
    this.errorMsg,
    this.lstupdt,
    this.ctj,
    this.frequencyType,
    this.ctb,
    this.gstin,
    this.stjCd,
    this.ctjCd,
    this.dty,
    this.tradeNam,
    this.pradr,
    this.adadr,
    this.lgnm,
    this.stj,
    this.cxdt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);

  @override
  String toString() {
    return 'Data(nba: $nba, sts: $sts, rgdt: $rgdt, errorMsg: $errorMsg, lstupdt: $lstupdt, ctj: $ctj, frequencyType: $frequencyType, ctb: $ctb, gstin: $gstin, stjCd: $stjCd, ctjCd: $ctjCd, dty: $dty, tradeNam: $tradeNam, pradr: ${pradr?.toString()}, adadr: $adadr, lgnm: $lgnm, stj: $stj, cxdt: $cxdt)';
  }
}

@JsonSerializable(explicitToJson: true)
class Pradr {
  String? ntr;
  Addr? addr;

  Pradr({this.ntr, this.addr});

  factory Pradr.fromJson(Map<String, dynamic> json) => _$PradrFromJson(json);

  Map<String, dynamic> toJson() => _$PradrToJson(this);

  @override
  String toString() => 'Pradr(ntr: $ntr, addr: ${addr?.toString()})';
}

@JsonSerializable(explicitToJson: true)
class Addr {
  String? dst;
  String? loc;
  String? city;
  String? stcd;
  String? flno;
  String? lg;
  String? st;
  String? pncd;
  String? bno;
  String? bnm;
  String? lt;

  Addr({
    this.dst,
    this.loc,
    this.city,
    this.stcd,
    this.flno,
    this.lg,
    this.st,
    this.pncd,
    this.bno,
    this.bnm,
    this.lt,
  });

  factory Addr.fromJson(Map<String, dynamic> json) => _$AddrFromJson(json);

  Map<String, dynamic> toJson() => _$AddrToJson(this);

  @override
  String toString() {
    return 'Addr(dst: $dst, loc: $loc, city: $city, stcd: $stcd, flno: $flno, lg: $lg, st: $st, pncd: $pncd, bno: $bno, bnm: $bnm, lt: $lt)';
  }
}
