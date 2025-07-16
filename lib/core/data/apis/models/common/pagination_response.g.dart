// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationResponse _$PaginationResponseFromJson(Map<String, dynamic> json) =>
    PaginationResponse(
      pages: (json['pages'] as num?)?.toInt() ?? 0,
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
      totalItems: (json['totalItems'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$PaginationResponseToJson(PaginationResponse instance) =>
    <String, dynamic>{
      'pages': instance.pages,
      'currentPage': instance.currentPage,
      'limit': instance.limit,
      'totalItems': instance.totalItems,
    };
