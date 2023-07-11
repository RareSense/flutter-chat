// lib/controllers/chat_controller.dart
import 'dart:async';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:xGPT/utils/snackbar.dart';

class ImageInputController extends GetxController {
  RxBool hasImage = false.obs;
  Rx<File?> pickedImage = Rx<File?>(null);
  RxBool isDisabled = false.obs;

  set disabled(bool value){
    isDisabled.value=value;
  }


  Future<void> pickImageFromSource(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Choose image source'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, ImageSource.camera);
              },
              child: const Text('Camera'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, ImageSource.gallery);
              },
              child: const Text('Gallery'),
            ),
          ],
        );
      },
    );
    if (source != null) {
      final XFile? image = await picker.pickImage(source: source);

      try{
        if (image != null) {
          pickedImage.value = await convertToJPG(await resizeImage(image.path));
          hasImage.value = true;
          debugPrint("pickedImage.value=${pickedImage.value}, hasImage.value=${hasImage.value}");
          Amplitude.getInstance().logEvent('ChooseImageAction');
        }
      }catch(e,stackTrace){
        debugPrint("resizeImage::error:$e");
        debugPrint("resizeImage::stackTrace:$stackTrace");
        Snackbar.showError('Unable to compress image');
      }
    }
  }
  Future<File> convertToJPG(File image) async{
    final img.Image originalImage = img.decodeImage(image.readAsBytesSync())!;
    List<int> jpegData = img.JpegEncoder().encode(originalImage);
    Directory tempDir = await getTemporaryDirectory();
    File tempFile = File('${tempDir.path}/${DateTime.now()}.jpg');
    tempFile.writeAsBytesSync(jpegData);
    return tempFile;
  }

  Future<File> resizeImage(String path) async{

    final compressedData = await FlutterImageCompress.compressWithFile(
      path,
      minWidth: 512,
      minHeight: 512,
      quality: 80, // You can adjust the quality as needed
    );
    if(compressedData!=null)
    {
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/${DateTime.now()}.jpg');
      await tempFile.writeAsBytes(compressedData);
      return tempFile;
    }

    throw Exception('Unable to resize file');

  }

  Future<void> handleChooseImage(Function(String) onError, Function() onSuccess ) async {
    bool hasPermission = await requestStoragePermission();

    if(!hasPermission) {
      onError('Storage permission is required to access images.');
       return;
    }

    onSuccess();
    // chooseImage(context);
  }

  void removeImage() {
    debugPrint("removeImage called");
    pickedImage.value = null;
    hasImage.value = false;
    debugPrint("pickedImage.value=${pickedImage.value}, hasImage.value=${hasImage.value}");
    Amplitude.getInstance().logEvent('RemoveImageAction');
  }

  Future<bool> requestStoragePermission() async {
    Permission permission =
        Platform.isIOS ? Permission.photos : Permission.camera;

    PermissionStatus status = await permission.status;

    if (status.isGranted) {
      return true;
    } else {
      PermissionStatus newStatus = await permission.request();
      return newStatus.isGranted;
    }
  }
}
