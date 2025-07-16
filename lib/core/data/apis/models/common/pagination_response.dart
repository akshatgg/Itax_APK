import 'package:json_annotation/json_annotation.dart';

part 'pagination_response.g.dart'; // Required for generated code

@JsonSerializable()
class PaginationResponse {
  final int pages;
  final int currentPage;
  final int limit;
  final int totalItems;

  PaginationResponse({
    this.pages = 0,
    this.currentPage = 0,
    this.limit = 0,
    this.totalItems = 0,
  });

  factory PaginationResponse.fromJson(Map<String, dynamic> json) =>
      _$PaginationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationResponseToJson(this);
}
