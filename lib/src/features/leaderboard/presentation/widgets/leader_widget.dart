import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class LeaderWidget extends StatefulWidget {
  final String imageUrl;
  final String rank;
  final String name;
  final String points;
  final Color borderColor;
  final bool isLeader;
  final GestureTapCallback onTap;
  const LeaderWidget({
    super.key,
    required this.imageUrl,
    required this.rank,
    required this.name,
    required this.points,
    required this.borderColor,
    this.isLeader = false,
    required this.onTap,
  });

  @override
  State<LeaderWidget> createState() => _LeaderWidgetState();
}

class _LeaderWidgetState extends State<LeaderWidget>
    with TickerProviderStateMixin {
  late final GifController _gifController;

  @override
  void initState() {
    super.initState();
    _gifController = GifController(vsync: this);
  }

  @override
  void dispose() {
    _gifController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding:
            widget.isLeader ? EdgeInsets.zero : const EdgeInsets.only(top: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              fit: StackFit.loose,
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                SizedBox(
                  height: widget.isLeader ? 12.5.h : 10.5.h,
                  width: widget.isLeader ? 12.5.h : 10.5.h,
                  child: Container(
                    padding: EdgeInsets.all(0.5.h),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: widget.borderColor,
                        width: 0.23.h,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: (widget.imageUrl ?? "").isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: widget.imageUrl,
                              memCacheHeight: (widget.isLeader ? 11.h : 9.h)
                                  .cacheSize(context),
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  color: Colors.white,
                                ),
                              ),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.person,
                              ),
                            )
                          : Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.person,
                              ),
                            ),
                    ),
                  ),
                ),
                Positioned(
                  top: widget.isLeader ? -0.0.h : -0.15.h,
                  right: widget.isLeader ? 0.1.w : -0.3.w,
                  child: Container(
                    height: 3.1.h,
                    width: 3.1.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.borderColor,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.rank,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            widget.isLeader
                ? const SizedBox(height: 3)
                : const SizedBox(height: 1),
            SizedBox(
              width: 100,
              child: Text(
                widget.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 2),
                  Text(
                    "${widget.points} bite coins",
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: AppColors.grey400,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
