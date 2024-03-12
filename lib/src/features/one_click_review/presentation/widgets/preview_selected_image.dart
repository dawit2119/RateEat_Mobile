import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PreviewImage extends StatelessWidget {
  final String imagePath;
  // final VoidCallback onRemove;

  const PreviewImage({
    super.key,
    required this.imagePath,
    //  required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          child: SizedBox(
              child: PhotoView(
                  imageProvider: Image.file(
            File(imagePath),
            fit: BoxFit.cover,
          ).image)),
        ),
      ],
    );
  }
}
