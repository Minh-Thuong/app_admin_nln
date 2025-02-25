import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';

Future<XFile?> compressImage(XFile image) async {
  final filePath = image.path;
  final lastIndex = filePath.lastIndexOf('.');
  final outPath = "${filePath.substring(0, lastIndex)}_compressed.jpg";
  return await FlutterImageCompress.compressAndGetFile(filePath, outPath, quality: 75);
}

void selectImages(BuildContext context, ImagePicker picker, Function(XFile?) onImageSelected) async {
  final XFile? selectedImage = await picker.pickImage(source: ImageSource.gallery);
  if (selectedImage != null) {
    final compressedImage = await compressImage(selectedImage);
    if (compressedImage != null) {
      final file = File(compressedImage.path);
      final fileSize = await file.length();
      if (fileSize > 2 * 1024 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ảnh vẫn quá lớn! Hãy thử ảnh khác.")));
        return;
      }
      onImageSelected(compressedImage);
    }
  }
}