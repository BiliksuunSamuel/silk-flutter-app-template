import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_service.g.dart';

/// A picked image resolved to a [File].
class PickedImage {
  const PickedImage({required this.file, required this.path});

  final File file;
  final String path;
}

/// A picked file resolved to its path and name.
class PickedFile {
  const PickedFile({
    required this.file,
    required this.path,
    required this.name,
  });

  final File file;
  final String path;
  final String name;
}

@Riverpod(keepAlive: true)
MediaService mediaService(MediaServiceRef ref) => MediaService();

class MediaService {
  MediaService() : _imagePicker = ImagePicker();

  final ImagePicker _imagePicker;

  /// Pick an image from the device gallery. Returns `null` if cancelled.
  Future<PickedImage?> pickImageFromGallery({double? maxWidth, double? maxHeight, int? imageQuality}) async {
    final xFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );
    if (xFile == null) return null;
    return PickedImage(file: File(xFile.path), path: xFile.path);
  }

  /// Capture a photo with the device camera. Returns `null` if cancelled.
  Future<PickedImage?> capturePhoto({double? maxWidth, double? maxHeight, int? imageQuality}) async {
    final xFile = await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );
    if (xFile == null) return null;
    return PickedImage(file: File(xFile.path), path: xFile.path);
  }

  /// Pick one or more files. Returns an empty list if cancelled.
  Future<List<PickedFile>> pickFiles({
    List<String>? allowedExtensions,
    bool allowMultiple = false,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: allowMultiple,
      type: allowedExtensions != null ? FileType.custom : FileType.any,
      allowedExtensions: allowedExtensions,
    );
    if (result == null) return [];
    return result.files
        .where((f) => f.path != null)
        .map(
          (f) => PickedFile(
            file: File(f.path!),
            path: f.path!,
            name: f.name,
          ),
        )
        .toList();
  }
}
