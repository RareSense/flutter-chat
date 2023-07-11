import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xGPT/chat/presentation/controllers/file_input_controller.dart';
import 'package:xGPT/themes/theme.dart';

class FileInput extends StatefulWidget {

  final Function updateHasInput;
  const FileInput({Key? key, required this.updateHasInput})
      : super(key: key);

  @override
  FileInputState createState() => FileInputState();
}

class FileInputState extends State<FileInput> {
  FileInputController fileInputController = Get.find<FileInputController>(tag: 'fileInputController');

  void showErrorSnackbar(String message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void handleFilePicker() async{
    if(fileInputController.isDisabled.value){
      return;
    }
    await fileInputController.pickFile();
    if(fileInputController.hasFile.value) {
      widget.updateHasInput();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => IconButton(
      onPressed: (){
        handleFilePicker();
        // fileInputController.handleChooseImage(showErrorSnackbar, onChooseImageSuccess);
      },
      icon:  Icon(
        Icons.attach_file,
        color: fileInputController.isDisabled.value? Colors.teal[200]: AppColors.primary,
      ),
    ));
  }
}
