import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rateeat_mobile/src/core/utils/image_uploader.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../l10n/gen_l10n/app_localizations.dart';

class ProfileImage extends StatefulWidget {
  final Function(String) selectedImage;
  final String? imageUrl;
  const ProfileImage({
    super.key,
    required this.selectedImage,
    this.imageUrl,
  });

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  String? imageUrl;

  @override
  void initState() {
    imageUrl = widget.imageUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Container(
          height: screenHeight * 0.1,
          width: screenHeight * 0.1,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F3FC),
            image: imageUrl != null
                ? DecorationImage(
                    image: FileImage(File(imageUrl!)),
                    fit: BoxFit.cover,
                  )
                : null,
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        Positioned(
          top: screenHeight * 0.064,
          left: screenWidth * 0.165,
          child: Container(
            height: screenWidth * 0.06,
            width: screenWidth * 0.06,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(50),
            ),
            child: InkWell(
              onTap: () => _changeProfileImage(),
              child: imageUrl == null
                  ? const Icon(Icons.add, color: Color(0xFF9F9F9F))
                  : Center(
                      child: SvgPicture.asset(
                        "assets/icons/edit_square.svg",
                        height: 17.sp,
                        width: 17.sp,
                        colorFilter:
                            ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Future _changeProfileImage() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(AppLocalizations.of(context)!.cameraText),
                onTap: () async {
                  final pickedFile = await ImageUploader.getImage(
                    source: ImageSource.camera,
                  );
                  setState(() {
                    imageUrl = pickedFile!.path;
                    widget.selectedImage(imageUrl!);
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(
                  AppLocalizations.of(context)!.galleryText,
                ),
                onTap: () async {
                  final pickedFile = await ImageUploader.getImage(
                    source: ImageSource.gallery,
                  );
                  setState(() {
                    imageUrl = pickedFile!.path;
                    widget.selectedImage(imageUrl!);
                  });
                  if (context.mounted) {
                    context.pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
