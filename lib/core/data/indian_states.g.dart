// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'indian_states.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IndianStatesData _$IndianStatesDataFromJson(Map<String, dynamic> json) =>
    IndianStatesData(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
      emoji: json['emoji'] as String,
      emojiU: json['emojiU'] as String,
      state: (json['state'] as List<dynamic>)
          .map((e) => IndianState.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$IndianStatesDataToJson(IndianStatesData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'name_ar': instance.nameAr,
      'emoji': instance.emoji,
      'emojiU': instance.emojiU,
      'state': instance.state.map((e) => e.toJson()).toList(),
    };

IndianState _$IndianStateFromJson(Map<String, dynamic> json) => IndianState(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
      countryId: (json['country_id'] as num).toInt(),
      city: (json['city'] as List<dynamic>)
          .map((e) => IndianCity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$IndianStateToJson(IndianState instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'name_ar': instance.nameAr,
      'country_id': instance.countryId,
      'city': instance.city.map((e) => e.toJson()).toList(),
    };

IndianCity _$IndianCityFromJson(Map<String, dynamic> json) => IndianCity(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      stateId: (json['state_id'] as num).toInt(),
    );

Map<String, dynamic> _$IndianCityToJson(IndianCity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'state_id': instance.stateId,
    };
