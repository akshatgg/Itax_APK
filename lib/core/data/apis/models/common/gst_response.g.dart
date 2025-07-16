// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gst_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GSTResponse _$GSTResponseFromJson(Map<String, dynamic> json) => GSTResponse(
      flag: json['flag'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GSTResponseToJson(GSTResponse instance) =>
    <String, dynamic>{
      'flag': instance.flag,
      'message': instance.message,
      'data': instance.data?.toJson(),
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      nba: (json['nba'] as List<dynamic>?)?.map((e) => e as String).toList(),
      sts: json['sts'] as String?,
      rgdt: json['rgdt'] as String?,
      errorMsg: json['errorMsg'] as String?,
      lstupdt: json['lstupdt'] as String?,
      ctj: json['ctj'] as String?,
      frequencyType: json['frequencyType'] as String?,
      ctb: json['ctb'] as String?,
      gstin: json['gstin'] as String?,
      stjCd: json['stjCd'] as String?,
      ctjCd: json['ctjCd'] as String?,
      dty: json['dty'] as String?,
      tradeNam: json['tradeNam'] as String?,
      pradr: json['pradr'] == null
          ? null
          : Pradr.fromJson(json['pradr'] as Map<String, dynamic>),
      adadr:
          (json['adadr'] as List<dynamic>?)?.map((e) => e as String).toList(),
      lgnm: json['lgnm'] as String?,
      stj: json['stj'] as String?,
      cxdt: json['cxdt'] as String?,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'nba': instance.nba,
      'sts': instance.sts,
      'rgdt': instance.rgdt,
      'errorMsg': instance.errorMsg,
      'lstupdt': instance.lstupdt,
      'ctj': instance.ctj,
      'frequencyType': instance.frequencyType,
      'ctb': instance.ctb,
      'gstin': instance.gstin,
      'stjCd': instance.stjCd,
      'ctjCd': instance.ctjCd,
      'dty': instance.dty,
      'tradeNam': instance.tradeNam,
      'pradr': instance.pradr?.toJson(),
      'adadr': instance.adadr,
      'lgnm': instance.lgnm,
      'stj': instance.stj,
      'cxdt': instance.cxdt,
    };

Pradr _$PradrFromJson(Map<String, dynamic> json) => Pradr(
      ntr: json['ntr'] as String?,
      addr: json['addr'] == null
          ? null
          : Addr.fromJson(json['addr'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PradrToJson(Pradr instance) => <String, dynamic>{
      'ntr': instance.ntr,
      'addr': instance.addr?.toJson(),
    };

Addr _$AddrFromJson(Map<String, dynamic> json) => Addr(
      dst: json['dst'] as String?,
      loc: json['loc'] as String?,
      city: json['city'] as String?,
      stcd: json['stcd'] as String?,
      flno: json['flno'] as String?,
      lg: json['lg'] as String?,
      st: json['st'] as String?,
      pncd: json['pncd'] as String?,
      bno: json['bno'] as String?,
      bnm: json['bnm'] as String?,
      lt: json['lt'] as String?,
    );

Map<String, dynamic> _$AddrToJson(Addr instance) => <String, dynamic>{
      'dst': instance.dst,
      'loc': instance.loc,
      'city': instance.city,
      'stcd': instance.stcd,
      'flno': instance.flno,
      'lg': instance.lg,
      'st': instance.st,
      'pncd': instance.pncd,
      'bno': instance.bno,
      'bnm': instance.bnm,
      'lt': instance.lt,
    };
