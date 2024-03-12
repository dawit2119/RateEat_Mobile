import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

class SelectedImageDisplay extends StatelessWidget {
  final String imagePath;
  final bool remoteSource;
  final VoidCallback onRemove;

  const SelectedImageDisplay({
    super.key,
    required this.imagePath,
    required this.onRemove,
    this.remoteSource = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipOval(
          child: SizedBox(
            height: 80,
            width: 80,
            child: remoteSource
                ? CachedNetworkImage(
                    imageUrl: imagePath,
                    memCacheHeight: (80).cacheSize(context),
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors
                            .grey, // You can customize the color for the error state
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.error,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        if (!remoteSource)
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                height: 20,
                width: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.errrorColor,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
