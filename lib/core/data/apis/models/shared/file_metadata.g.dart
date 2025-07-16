// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_metadata.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FileMetadataAdapter extends TypeAdapter<FileMetadata> {
  @override
  final int typeId = 16;

  @override
  FileMetadata read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FileMetadata(
      id: fields[0] as String,
      filename: fields[1] as String,
      filePath: fields[2] as String,
      createdAt: fields[3] as DateTime,
      updatedAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FileMetadata obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.filename)
      ..writeByte(2)
      ..write(obj.filePath)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileMetadataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileMetadata _$FileMetadataFromJson(Map<String, dynamic> json) => FileMetadata(
      id: json['id'] as String? ?? '',
      filename: json['filename'] as String,
      filePath: json['filePath'] as String,
      createdAt: DateTimeParser.dateTimeFromJson(json['createdAt'] as String?),
      updatedAt: DateTimeParser.dateTimeFromJson(json['updatedAt'] as String?),
    );

Map<String, dynamic> _$FileMetadataToJson(FileMetadata instance) =>
    <String, dynamic>{
      'id': instance.id,
      'filename': instance.filename,
      'filePath': instance.filePath,
      'createdAt': DateTimeParser.dateTimeToJson(instance.createdAt),
      'updatedAt': DateTimeParser.dateTimeToJson(instance.updatedAt),
    };
