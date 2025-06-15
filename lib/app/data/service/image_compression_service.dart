import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
class ImageCompressionService {
  static const int maxFileSizeBytes = 1000000;
  static const int targetWidth = 1024;
  static const int initialQuality = 80;
  static const int minQuality = 20;
  static bool isFileSizeValid(File file) {
    final fileSizeBytes = file.lengthSync();
    return fileSizeBytes <= maxFileSizeBytes;
  }
  static String getFileSizeString(File file) {
    final fileSizeBytes = file.lengthSync();
    if (fileSizeBytes < 1024) {
      return '$fileSizeBytes B';
    } else if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }
  static Future<File?> compressImageToSize(File file) async {
    try {
      if (isFileSizeValid(file)) {
        return file;
      }
      final fileSizeBytes = file.lengthSync();
      if (fileSizeBytes > 1024 * 1024) {
      }
      final tempDir = await getTemporaryDirectory();
      final targetPath = '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';
      int quality = initialQuality;
      File? compressedFile;
      while (quality >= minQuality) {
        final result = await FlutterImageCompress.compressAndGetFile(
          file.absolute.path,
          targetPath,
          quality: quality,
          minWidth: targetWidth,
          minHeight: (targetWidth * 0.75).round(),
          format: CompressFormat.jpeg,
        );
        if (result != null) {
          compressedFile = File(result.path);
          final compressedSize = compressedFile.lengthSync();
          if (compressedSize <= maxFileSizeBytes) {
            return compressedFile;
          }
        }
        quality -= 10;
      }
      if (compressedFile != null && compressedFile.lengthSync() > maxFileSizeBytes) {
        final result = await FlutterImageCompress.compressAndGetFile(
          file.absolute.path,
          '${tempDir.path}/aggressive_compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
          quality: minQuality,
          minWidth: 512,
          minHeight: 384,
          format: CompressFormat.jpeg,
        );
        if (result != null) {
          final aggressiveFile = File(result.path);
          final aggressiveSize = aggressiveFile.lengthSync();
          if (aggressiveSize <= maxFileSizeBytes) {
            return aggressiveFile;
          }
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  static Future<File?> compressImageWithQuality(File file, int quality) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final targetPath = '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
        format: CompressFormat.jpeg,
      );
      if (result != null) {
        return File(result.path);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  static int getRecommendedQuality(File file) {
    final fileSizeBytes = file.lengthSync();
    final fileSizeMB = fileSizeBytes / (1024 * 1024);
    if (fileSizeMB > 5) {
      return 40;
    } else if (fileSizeMB > 3) {
      return 50;
    } else if (fileSizeMB > 2) {
      return 60;
    } else if (fileSizeMB > 1) {
      return 70;
    } else {
      return 80;
    }
  }
}
