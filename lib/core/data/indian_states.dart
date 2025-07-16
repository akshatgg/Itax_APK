// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';

part 'indian_states.g.dart';

@JsonSerializable(explicitToJson: true)
class IndianStatesData {
  int? id;
  String name;
  @JsonKey(name: 'name_ar')
  String nameAr;
  String emoji;
  String emojiU;
  List<IndianState> state;
  IndianStatesData({
    this.id,
    required this.name,
    required this.nameAr,
    required this.emoji,
    required this.emojiU,
    required this.state,
  });
  factory IndianStatesData.fromJson(Map<String, dynamic> json) =>
      _$IndianStatesDataFromJson(json);
  Map<String, dynamic> toJson() => _$IndianStatesDataToJson(this);

  IndianStatesData copyWith({
    int? id,
    String? name,
    String? nameAr,
    String? emoji,
    String? emojiU,
    List<IndianState>? state,
  }) {
    return IndianStatesData(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      emoji: emoji ?? this.emoji,
      emojiU: emojiU ?? this.emojiU,
      state: state ?? this.state,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class IndianState {
  int id;
  String name;
  @JsonKey(name: 'name_ar')
  String nameAr;
  @JsonKey(name: 'country_id')
  int countryId;
  List<IndianCity> city;
  IndianState({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.countryId,
    required this.city,
  });
  factory IndianState.fromJson(Map<String, dynamic> json) =>
      _$IndianStateFromJson(json);
  Map<String, dynamic> toJson() => _$IndianStateToJson(this);

  IndianState copyWith({
    int? id,
    String? name,
    String? nameAr,
    int? countryId,
    List<IndianCity>? city,
  }) {
    return IndianState(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      countryId: countryId ?? this.countryId,
      city: city ?? this.city,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class IndianCity {
  int id;
  String name;
  @JsonKey(name: 'state_id')
  int stateId;
  IndianCity({
    required this.id,
    required this.name,
    required this.stateId,
  });
  factory IndianCity.fromJson(Map<String, dynamic> json) =>
      _$IndianCityFromJson(json);
  Map<String, dynamic> toJson() => _$IndianCityToJson(this);

  IndianCity copyWith({
    int? id,
    String? name,
    int? stateId,
  }) {
    return IndianCity(
      id: id ?? this.id,
      name: name ?? this.name,
      stateId: stateId ?? this.stateId,
    );
  }
}

Future<IndianStatesData?> loadIndianStatesData() async {
  final jsonString = await rootBundle.loadString('assets/data/countries.json');
  final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
  final data = jsonList
      .map((jsonItem) =>
          IndianStatesData.fromJson(jsonItem as Map<String, dynamic>))
      .toList();
  if (data.isNotEmpty) {
    return data.first;
  }
  return null;
}
