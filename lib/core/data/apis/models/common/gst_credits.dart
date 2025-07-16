import 'package:json_annotation/json_annotation.dart';

part 'gst_credits.g.dart';

@JsonSerializable()
class GSTCreditsResponse {
  final bool flag;
  final String message;
  final int data;
  final String email;

  GSTCreditsResponse({
    this.flag = false,
    this.message = '',
    this.data = 0,
    this.email = '',
  });

  GSTCreditsResponse copyWith({
    bool? flag,
    String? message,
    int? data,
    String? email,
  }) {
    return GSTCreditsResponse(
      flag: flag ?? this.flag,
      message: message ?? this.message,
      data: data ?? this.data,
      email: email ?? this.email,
    );
  }

  factory GSTCreditsResponse.fromJson(Map<String, dynamic> json) =>
      _$GSTCreditsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GSTCreditsResponseToJson(this);
}
