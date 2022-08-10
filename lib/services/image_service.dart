import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

@lazySingleton
class ImageService {
  Future<bool> uploadProfilePicture(File profilePictureFile) async {
    final tempDir = await getTemporaryDirectory();
    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      profilePictureFile.absolute.path,
      tempDir.path,
      quality: 80,
    );
    try {
      final UploadFileResult result = await Amplify.Storage.uploadFile(
          local: compressedFile ?? profilePictureFile,
          key:
              (await Amplify.Auth.getCurrentUser()).userId + "_profile_picture",
          onProgress: (progress) {
            print('Fraction completed: ${progress.getFractionCompleted()}');
          });
      print('Successfully uploaded file: ${result.key}');
    } on StorageException catch (e) {
      print('Error uploading file: $e');
      return false;
    }
    return true;
  }
}

final imageService = ImageService();
