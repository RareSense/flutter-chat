import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:xGPT/chat/presentation/controllers/image_input_controller.dart';
import 'package:xGPT/themes/theme.dart';

class ImageInput extends StatefulWidget {

  final Function updateHasInput;
  const ImageInput({Key? key, required this.updateHasInput})
      : super(key: key);

  @override
  ImageInputState createState() => ImageInputState();
}

class ImageInputState extends State<ImageInput> {

  ImageInputController imageInputController = Get.find<ImageInputController>(tag: 'imageInputController');

  void showErrorSnackbar(String message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void onChooseImageSuccess() async{
    if(imageInputController.isDisabled.value){
      return;
    }
    await imageInputController.pickImageFromSource(context);
    if(imageInputController.hasImage.value) {
      widget.updateHasInput();
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("imageInput::isDisabled: ${imageInputController.isDisabled.value}");
    return Obx(() => IconButton(
      onPressed: (){
        imageInputController.handleChooseImage(showErrorSnackbar, onChooseImageSuccess);
      },
      icon: Icon(
        Icons.camera_alt,
        color: imageInputController.isDisabled.value? Colors.teal[200]: AppColors.primary,
      ),
    ));
  }
}
