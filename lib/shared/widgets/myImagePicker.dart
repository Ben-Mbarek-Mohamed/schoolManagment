import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';

class ImagePickerWidget extends StatefulWidget {
  final Function(String, Image) onImageSelected;

  ImagePickerWidget({required this.onImageSelected});

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      String filePath = result.files.single.path!;
      File file = File(filePath);

      final bytes = await file.readAsBytes();
      String base64Image = base64Encode(bytes);
      Image image = Image.memory(base64Decode(base64Image));

      widget.onImageSelected(base64Image, image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pickImage,
      child: Container(
        width: 150,
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blueAccent, width: 2),
        ),
        child: Center(
          child: Icon(
            Icons.image,
            color: Colors.blueAccent,
            size: 100,
          ),
        ),
      ),
    );
  }
}
