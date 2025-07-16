// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gst_credits.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GSTCreditsResponse _$GSTCreditsResponseFromJson(Map<String, dynamic> json) =>
    GSTCreditsResponse(
      flag: json['flag'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: (json['data'] as num?)?.toInt() ?? 0,
      email: json['email'] as String? ?? '',
    );

Map<String, dynamic> _$GSTCreditsResponseToJson(GSTCreditsResponse instance) =>
    <String, dynamic>{
      'flag': instance.flag,
      'message': instance.message,
      'data': instance.data,
      'email': instance.email,
    };
