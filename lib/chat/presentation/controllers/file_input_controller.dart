// lib/controllers/chat_controller.dart
import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:flutter/material.dart';
// import 'dart:typed_data';

// import 'dart:io';
import 'package:get/get.dart';

// import 'package:image/image.dart' as img;
import 'package:file_picker/file_picker.dart';

// import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:xGPT/chat/presentation/controllers/image_input_controller.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';

class FileInputController extends GetxController {
  RxBool hasFile = false.obs;

  RxBool isDisabled = false.obs;

  Rx<PlatformFile?> pickedFile = Rx<PlatformFile?>(null);

  set disabled(bool value) {
    isDisabled.value = value;
  }

  Future<void> pickFile() async {
    if (!await checkFilePermission()) {
      return;
    }
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      var file = result.files.first;

      String? ext = extension(file.path!).toLowerCase();

      if (ext == '.jpg' || ext == '.jpeg' || ext == '.png' || ext == '.gif') {
        ImageInputController imageInputController =
            Get.find<ImageInputController>(tag: 'imageInputController');

        imageInputController.hasImage.value = true;
        imageInputController.pickedImage.value = File(file.path!);
        // print('This file is an image');
      } else {
        pickedFile.value = file;
        // print('This file is not an image');
        hasFile.value = true;
      }

      Amplitude.getInstance().logEvent('ChooseFileAction');
    }
  }

  // Future<File> convertToJPG(File image) async {
  //   final img.Image originalImage = img.decodeImage(image.readAsBytesSync())!;
  //   List<int> jpegData = img.JpegEncoder().encode(originalImage);
  //   Directory tempDir = await getTemporaryDirectory();
  //   File tempFile = File('${tempDir.path}/converted_image.jpg');
  //   tempFile.writeAsBytesSync(jpegData);
  //   return tempFile;
  // }

  // Future<File> resizeImage(String path) async {
  //   final compressedData = await FlutterImageCompress.compressWithFile(
  //     path,
  //     minWidth: 512,
  //     minHeight: 512,
  //     quality: 80, // You can adjust the quality as needed
  //   );
  //
  //   if (compressedData != null) {
  //     final tempDir = await getTemporaryDirectory();
  //     final tempFile = File('${tempDir.path}/temp_resized_image.jpg');
  //     await tempFile.writeAsBytes(compressedData);
  //     return tempFile;
  //   }
  //
  //   throw Exception('Unable to resize file');
  // }

  // Future<void> handleChooseImage(Function(String) onError, Function() onSuccess ) async {
  //   bool hasPermission = await requestStoragePermission();
  //
  //   if(!hasPermission) {
  //     onError('Storage permission is required to access images.');
  //      return;
  //   }
  //
  //   onSuccess();
  //   // chooseImage(context);
  // }

  void removeFile() {
    debugPrint('removeFile called');
    pickedFile.value = null;
    hasFile.value = false;
    Amplitude.getInstance().logEvent('RemoveFileAction');
  }

  Future<bool> checkFilePermission() async {
    PermissionStatus status = await Permission.storage.status;
    if (!status.isGranted) {
      PermissionStatus result = await Permission.storage.request();
      if (!result.isGranted) {
        return false;
      }
    }
    return true;
  }
}
