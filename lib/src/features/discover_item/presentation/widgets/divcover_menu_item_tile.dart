import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import 'package:rateeat_mobile/src/features/homepage/presentation/bloc/tag/tag_bloc.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/bloc/tag/tag_event.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/bloc/tag/tag_state.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class DivcoverMenuItemTile extends StatelessWidget {
  final String categoryName;
  final String? categoryIconUrl;
  final int? totalItems;
  final VoidCallback onTap;

  const DivcoverMenuItemTile(
      {super.key,
      required this.categoryName,
      required this.onTap,
      this.totalItems,
      required this.categoryIconUrl});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TagBloc, SelectedTagState>(
      builder: (context, selectionState) {
        final selectedTags = selectionState.selectedTags;
        return InkWell(
          splashColor:
              (selectedTags.isNotEmpty && selectedTags.contains(categoryName))
                  ? AppColors.secondaryColor.withOpacity(.1)
                  : AppColors.primaryButtonColor.withOpacity(.1),
          borderRadius: BorderRadius.circular(10.sp),
          onTap: () {
            context.read<TagBloc>().add(
                  (selectedTags.isNotEmpty &&
                          selectedTags.contains(categoryName))
                      ? UnselectTag(tag: categoryName)
                      : SelectTag(tag: categoryName),
                );
            WidgetsBinding.instance.addPostFrameCallback((_) {
              onTap();
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: (selectedTags.isNotEmpty &&
                            selectedTags.contains(categoryName) ||
                        (selectedTags.isEmpty && categoryName == 'All'))
                    ? AppColors.primaryButtonColor
                    : AppColors.grey200,
                width: 1,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 15.sp),
              child: Row(
                children: [
                  categoryIconUrl != null
                      ? CachedNetworkImage(
                          imageUrl: categoryIconUrl!,
                          height: 18.sp,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) {
                            return Container();
                          },
                          progressIndicatorBuilder: (context, url, progress) =>
                              Shimmer.fromColors(
                            baseColor: AppColors.shimmerBaseColor,
                            highlightColor: AppColors.grey100,
                            child: Container(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Container(),
                  const SizedBox(
                    width: 7,
                  ),
                  Text(
                    categoryName,
                    style: GoogleFonts.poppins(
                      color: (selectedTags.isNotEmpty &&
                                  selectedTags.contains(categoryName) ||
                              (selectedTags.isEmpty && categoryName == 'All'))
                          ? AppColors.primaryButtonColor
                          : AppColors.secondaryColor,
                    ),
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  if (totalItems != null && totalItems! > 0)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: totalItems! > 9 ? 6 : 10,
                        vertical: 3,
                      ),
                      decoration: const BoxDecoration(
                        color: AppColors.grey400,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: totalItems! > 9 ? 24 : 20,
                        minHeight: 24,
                      ),
                      alignment: Alignment.center, // Center the text
                      child: Text(
                        '$totalItems',
                        style: GoogleFonts.poppins(
                          color: AppColors.textWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
