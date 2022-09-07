import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:socale/components/keyboard_safe_area.dart';
import 'package:socale/components/nest_will_pop_scope.dart';
import 'package:socale/screens/onboarding/onboarding_screen.dart';

class AvatarSelection extends ConsumerStatefulWidget {
  const AvatarSelection({Key? key}) : super(key: key);

  @override
  ConsumerState<AvatarSelection> createState() => _AvatarSelectionState();
}

class _AvatarSelectionState extends ConsumerState<AvatarSelection> {
  late PageController _pageController;
  Future<bool> _onBackPress() async {
    _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    return false;
  }

  Future<void> createAndUploadFile() async {
    // Create a dummy file
    const exampleString = 'Example file contents';
    final tempDir = await getTemporaryDirectory();
    final exampleFile = File('${tempDir.path}/example.txt')
      ..createSync()
      ..writeAsStringSync(exampleString);

    // Upload the file to S3
    try {
      final UploadFileResult result = await Amplify.Storage.uploadFile(
          local: exampleFile,
          key: 'ExampleKey',
          onProgress: (progress) {
            print('Fraction completed: ${progress.getFractionCompleted()}');
          });
      print('Successfully uploaded file: ${result.key}');
    } on StorageException catch (e) {
      print('Error uploading file: $e');
    }
  }

  void upload() async {
    try {
      print('In upload');
      // Uploading the file with options
      const exampleString = 'Example file contents';
      final tempDir = await getTemporaryDirectory();
      final local = File('${tempDir.path}/example.txt')
        ..createSync()
        ..writeAsStringSync(exampleString);

      final key = DateTime.now().toString();
      Map<String, String> metadata = <String, String>{};
      metadata['name'] = 'filename';
      metadata['desc'] = 'A test file';
      S3UploadFileOptions options = S3UploadFileOptions(accessLevel: StorageAccessLevel.guest, metadata: metadata);

      UploadFileResult result = await Amplify.Storage.uploadFile(
          key: key,
          local: local,
          options: options,
          onProgress: (progress) {
            print("PROGRESS: ${progress.getFractionCompleted()}");
          });

      print('Successfully uploaded file: ${result.key}');
    } catch (e) {
      print('UploadFile Err: $e');
    }
  }

  Future<void> downloadFile() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final filepath = '${documentsDir.path}/profile.png';
    final file = File(filepath);

    try {
      final result = await Amplify.Storage.downloadFile(
        key: 'ExampleKey',
        local: file,
        onProgress: (progress) {
          print('Fraction completed: ${progress.getFractionCompleted()}');
        },
      );
      final contents = result.file.readAsStringSync();
      // Or you can reference the file that is created above
      // final contents = file.readAsStringSync();
      print('Downloaded contents: $contents');
    } on StorageException catch (e) {
      print('Error downloading file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    _pageController = ref.watch(onboardingPageController);

    return NestedWillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
        body: KeyboardSafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    createAndUploadFile();
                  },
                  child: Text("Upload"),
                ),
                ElevatedButton(
                  onPressed: () {
                    downloadFile();
                  },
                  child: Text("download"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
