import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../config/hive/hive_type_constants.dart';
import '../../../../utils/date_time_parser.dart';

part 'file_metadata.g.dart';

@HiveType(typeId: HiveTypeConstants.fileMetadata)
@JsonSerializable()
class FileMetadata {
  @HiveField(0)
  String id;

  @HiveField(1)
  String filename;

  @HiveField(2)
  String filePath;

  @HiveField(3)
  @JsonKey(
    fromJson: DateTimeParser.dateTimeFromJson,
    toJson: DateTimeParser.dateTimeToJson,
  )
  DateTime createdAt;

  @HiveField(4)
  @JsonKey(
    fromJson: DateTimeParser.dateTimeFromJson,
    toJson: DateTimeParser.dateTimeToJson,
  )
  DateTime updatedAt;

  FileMetadata({
    this.id = '',
    required this.filename,
    required this.filePath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FileMetadata.fromJson(Map<String, dynamic> json) =>
      _$FileMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$FileMetadataToJson(this);

  FileMetadata copyWith({
    String? id,
    String? filename,
    String? filePath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FileMetadata(
      id: id ?? this.id,
      filename: filename ?? this.filename,
      filePath: filePath ?? this.filePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'FileMetadata(id: $id, filename: $filename, filePath: $filePath, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
