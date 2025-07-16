import 'dart:async';
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../../config/hive/hive_constants.dart';
import '../../../utils/id_generator.dart';
import '../../../utils/logger.dart';
import '../../apis/models/shared/file_metadata.dart';

class FileStorageService {
  static const int chunkSize = 1024 * 1024; // 1MB per chunk
  Box<FileMetadata>? metadataBox;

  Future<void> init() async {
    var key = HiveConstants.encryptionKey.codeUnits;
    metadataBox = await Hive.openBox<FileMetadata>(
      HiveConstants.fileMetadataBox,
      encryptionCipher: HiveAesCipher(key),
    );
    final dir = await getApplicationDocumentsDirectory();
    logger.d('dir: ${dir.path}');
    final mediaDir = Directory('${dir.path}/media');
    if (!mediaDir.existsSync()) {
      mediaDir.createSync(recursive: true);
    }
  }

  Future<String> getMediaBucketPath() async {
    final dir = await getApplicationDocumentsDirectory();
    final mediaDir = Directory('${dir.path}/media');
    if (!mediaDir.existsSync()) {
      mediaDir.createSync(recursive: true);
    }
    return mediaDir.path;
  }

  Future<FileMetadata> saveFileInChunks(File file) async {
    if (metadataBox == null || !metadataBox!.isOpen) {
      await init();
    }

    final mediaPath = await getMediaBucketPath();
    final fileId = generateId();
    final filePath = '$mediaPath/$fileId-${file.uri.pathSegments.last}';

    final newFile = File(filePath);
    final sink = newFile.openWrite(mode: FileMode.write);
    final sourceStream = file.openRead();

    await for (var chunk in sourceStream) {
      sink.add(chunk); // Writing in chunks
    }

    await sink.close();

    final metadata = FileMetadata(
      id: fileId,
      filename: file.uri.pathSegments.last,
      filePath: filePath,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await metadataBox!.put(fileId, metadata);
    return metadata;
  }

  Future<FileMetadata?> saveImageThumbnail(File file) async {
    final mediaPath = await getMediaBucketPath();
    final fileId = generateId();
    final filePath = '$mediaPath/$fileId-${file.uri.pathSegments.last}';
    logger.d('saveImageThumbnail filePath: $filePath');

    final thumbnail = await FlutterImageCompress.compressAndGetFile(
      file.path,
      filePath,
      quality: 80,
      minWidth: 150,
      minHeight: 150,
    );
    if (thumbnail == null) {
      return null;
    }
    final length = await thumbnail.length();
    logger.d('saveImageThumbnail thumbnail: $length');
    return await saveFileInChunks(File(thumbnail.path));
  }

  Future<File?> getFileById(String fileId) async {
    if (metadataBox == null || !metadataBox!.isOpen) {
      await init();
    }
    final metadata = metadataBox!.get(fileId);
    if (metadata == null) return null;
    return File(metadata.filePath);
  }

  Future<void> deleteFile(String fileId) async {
    if (metadataBox == null || !metadataBox!.isOpen) {
      await init();
    }
    final metadata = metadataBox!.get(fileId);
    if (metadata != null) {
      final file = File(metadata.filePath);
      if (await file.exists()) {
        await file.delete();
      }
      await metadataBox!.delete(fileId);
    }
  }

  Future<void> deleteAllFiles() async {
    if (metadataBox == null || !metadataBox!.isOpen) {
      await init();
    }
    final dir = await getApplicationDocumentsDirectory();
    final mediaDir = Directory('${dir.path}/media');
    if (mediaDir.existsSync()) {
      mediaDir.deleteSync(recursive: true);
    }
    await metadataBox!.clear();
  }
}
