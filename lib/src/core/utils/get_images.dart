import 'dart:async';

import 'package:flutter/material.dart';

Future<Size> getImageSize(String imageUrl) async {
  final Image image = Image.network(imageUrl);
  final Completer<Size> completer = Completer<Size>();

  image.image.resolve(const ImageConfiguration()).addListener(
    ImageStreamListener(
      (ImageInfo image, bool synchronousCall) {
        final Size size = Size(
          image.image.width.toDouble(),
          image.image.height.toDouble(),
        );
        completer.complete(size);
      },
    ),
  );

  return completer.future;
}
