import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploader {
  static Future<File?> getImage({required ImageSource source}) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return null;
      final imageTemp = File(image.path);
      return imageTemp;
    } on PlatformException {
      return null;
    } catch (e) {
      return null;
    }
  }

  // this is for image cropper
  //static Future<File?> _cropImage({required File imageFile}) async {
  //   CroppedFile? croppedImage = await ImageCropper().cropImage(
  //       compressFormat: ImageCompressFormat.png,
  //       sourcePath: imageFile.path,
  //       aspectRatio: const CropAspectRatio(
  //         ratioX: 1,
  //         ratioY: 1,
  //       ));
  //   if (croppedImage == null) {
  //     return null;
  //   }
  //   return File(croppedImage.path);
  // }

  // static Future<File> compressFile(File file) async {
  //   File compressedFile = await FlutterNativeImage.compressImage(
  //     file.path,
  //     percentage: 75,
  //   );
  //   return compressedFile;
  // }
}
