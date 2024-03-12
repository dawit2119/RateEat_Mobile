import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class QrMenuFilterBottomSheet extends StatefulWidget {
  final String restaurantId;
  final bool? isFasting;
  final QRCategory? selectedCategory;
  final String query;
  final String? sortBy;
  final int? minRating;
  final String? sortType;
  final int? minPrice;
  final int? maxPrice;

  const QrMenuFilterBottomSheet({
    super.key,
    required this.restaurantId,
    required this.isFasting,
    required this.selectedCategory,
    required this.query,
    required this.sortBy,
    required this.minRating,
    required this.sortType,
    required this.minPrice,
    required this.maxPrice,
  });

  @override
  State<QrMenuFilterBottomSheet> createState() {
    return _QrMenuFilterBottomSheetState();
  }
}

class _QrMenuFilterBottomSheetState extends State<QrMenuFilterBottomSheet> {
  late String sortBy;
  late int minRating;
  late String sortType;

  List<PriceRange> priceRanges = [
    const PriceRangeModel(minPrice: null, maxPrice: 200, count: null),
    const PriceRangeModel(minPrice: 200, maxPrice: 500, count: null),
    const PriceRangeModel(minPrice: 500, maxPrice: 1000, count: null),
    const PriceRangeModel(minPrice: 1000, maxPrice: 2000, count: null),
    const PriceRangeModel(minPrice: 2000, maxPrice: null, count: null),
  ];

  int? minPrice;
  int? maxPrice;

  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    minPriceController.text = widget.minPrice?.toString() ?? "";
    maxPriceController.text = widget.maxPrice?.toString() ?? "";
    sortBy = widget.sortBy ?? 'popularity';
    minRating = widget.minRating ?? 0;
    sortType = widget.sortType ?? 'Desc';
    minPrice = widget.minPrice;
    maxPrice = widget.maxPrice;

    context.read<ItemsCountPerPriceBloc>().add(
          GetItemsCountPerPriceRange(
            category: widget.selectedCategory,
            minRating: null,
            isFasting: widget.isFasting,
            query: widget.query,
            restaurantId: widget.restaurantId,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        child: Theme(
          data: Theme.of(context).copyWith(
              unselectedWidgetColor: AppColors.grey300,
              disabledColor: AppColors.grey200),
          child: Padding(
            padding: EdgeInsets.only(
                left: 5.w,
                top: 3.h,
                right: 5.w,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 1.5.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Iconsax.arrow_35),
                      Text(
                        "Sort",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildRadioOption("Name", "name"),
                _buildRadioOption("Number of reviews", "number_of_reviews"),
                _buildRadioOption("Popularity", "popularity"),
                _buildRadioOption("Price", "price"),
                _buildRadioOption("Rating", "rating"),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5.h),
                  child: const Divider(
                    color: AppColors.grey200,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Iconsax.sort),
                    SizedBox(
                      width: 2.w,
                    ),
                    const Text("Filter",
                        style: TextStyle(
                          fontSize: 18,
                        )),
                    Expanded(
                      child: Container(),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          sortBy = 'popularity';
                          sortType = 'Desc';
                          minPrice = null;
                          maxPrice = null;
                          minRating = 0;
                        });
                        minPriceController.clear();
                        maxPriceController.clear();
                        context.read<ItemsCountPerPriceBloc>().add(
                              GetItemsCountPerPriceRange(
                                category: widget.selectedCategory,
                                minRating: minRating,
                                isFasting: widget.isFasting,
                                query: widget.query,
                                restaurantId: widget.restaurantId,
                              ),
                            );
                      },
                      child: const Text(
                        "Clear all",
                        style: TextStyle(color: AppColors.primaryColor),
                      ),
                    ),
                  ],
                ),
                const Text(
                  "Price (ETB)",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 1.h),
                _buildPriceRange(),
                SizedBox(height: 1.h),
                BlocBuilder<ItemsCountPerPriceBloc, ItemsCountPerPriceState>(
                    builder: (context, state) {
                  return IntrinsicHeight(
                    child: Column(
                      children: state is! ItemsCountPerPriceLoaded
                          ? priceRanges
                              .map((priRan) => _buildPriceRadioOption(priRan,
                                  setState, state is ItemsCountPerPriceLoading))
                              .toList()
                          : state.priceRanges
                              .map((priRan) => _buildPriceRadioOption(priRan,
                                  setState, state is ItemsCountPerPriceLoading))
                              .toList(),
                    ),
                  );
                }),
                const SizedBox(height: 20),
                const Text(
                  "Minimum Rating",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                _buildRatingStars(setState),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          context.pop();
                        },
                        child: Container(
                          height: 6.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.w),
                            border: Border.all(
                              color: AppColors.primaryColor,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Cancel",
                              style: TextStyle(fontSize: 17.sp),
                            ),
                          ),
                          // style: ElevatedButton.styleFrom(
                          //   primary: Colors.grey,
                          // ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if ((minPrice ?? 0) > (maxPrice ?? double.infinity)) {
                            showCustomToast(
                              context: context,
                              toastMessage:
                                  "Minimum price should be less than maximum price",
                              toastType: ToastType.error,
                            );
                            return;
                          }
                          context.read<QRMenuBloc>().add(GetQRMenu(
                                restaurantId: widget.restaurantId,
                                category: widget.selectedCategory,
                                page: 1,
                                isFasting: widget.isFasting,
                                sortBy: sortBy,
                                sortType: sortType,
                                minPrice: minPrice,
                                maxPrice: maxPrice,
                                minRating: minRating,
                                query: widget.query,
                              ));
                          context.pop();
                        },
                        child: Container(
                          height: 6.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.w),
                              color: AppColors.primaryColor),
                          child: Center(
                            child: Text(
                              "Apply",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 17.sp),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 7.h,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadioOption(String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (sortBy == value) {
              sortType = sortType == 'Desc' ? 'Asc' : 'Desc';
            } else {
              sortType = 'Desc';
            }
            sortBy = value;
          });
        },
        child: Row(
          children: [
            sortBy == value
                ? Icon(
                    sortType == 'Desc'
                        ? Iconsax.arrow_circle_down
                        : Iconsax.arrow_circle_up,
                    color: (value == sortBy
                        ? AppColors.primaryColor
                        : AppColors.grey500),
                  )
                : Container(
                    height: 3.h,
                    width: 3.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.grey400,
                      ),
                    ),
                  ),
            SizedBox(
              width: 3.w,
            ),
            Text(
              title,
              style: TextStyle(
                color: value == sortBy
                    ? AppColors.primaryColor
                    : AppColors.grey500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRadioOption(
      PriceRange priceRange, setState, bool isLoading) {
    int? newMin = priceRange.minPrice;
    int? newMax = priceRange.maxPrice;
    String title;
    if (newMin == null) {
      title = "Under $newMax";
    } else if (newMax == null) {
      title = ">$newMin";
    } else {
      title = "$newMin - $newMax";
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          if (newMin == minPrice && newMax == maxPrice) {
            minPrice = null;
            maxPrice = null;
            minPriceController.text = "";
            maxPriceController.text = "";
            return;
          } else {
            minPrice = newMin;
            maxPrice = newMax;
          }
        });
        minPriceController.text = newMin?.toString() ?? "";
        maxPriceController.text = newMax?.toString() ?? "";
      },
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.6.h),
            child: Container(
              width: 5.w,
              height: 5.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: "$newMin-$newMax" == "$minPrice-$maxPrice"
                      ? AppColors.primaryColor
                      : AppColors.grey400,
                  width: 0.5.w,
                ),
              ),
              child: "$newMin-$newMax" == "$minPrice-$maxPrice"
                  ? Center(
                      child: Container(
                        margin: EdgeInsets.all(0.5.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    )
                  : Container(),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: "$newMin-$newMax" == "$minPrice-$maxPrice"
                  ? AppColors.primaryColor
                  : AppColors.grey500,
            ),
          ),
          if (priceRange.count != null)
            Text(
              " | ${priceRange.count} ${priceRange.count != 1 ? "items" : "item"}",
              style: TextStyle(
                color: "$newMin-$newMax" == "$minPrice-$maxPrice"
                    ? AppColors.primaryColor
                    : AppColors.grey500,
              ),
            ),
          if (priceRange.count == null && isLoading)
            Shimmer.fromColors(
              baseColor: AppColors.shimmerBaseColor,
              highlightColor: AppColors.shimmerHighlightColor,
              child: Container(
                height: 3.h,
                width: 20.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPriceRange() {
    return SizedBox(
      width: 90.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              controller: minPriceController,
              onChanged: (text) {
                setState(() {
                  minPrice = text != "" ? int.parse(text) : null;
                });
              },
              decoration: InputDecoration(
                labelText: "Min",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3.w)),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: false),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: maxPriceController,
              onChanged: (text) {
                setState(() {
                  maxPrice = text != "" ? int.parse(text) : null;
                });
              },
              decoration: InputDecoration(
                labelText: "Max",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    3.w,
                  ),
                ),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStars(setState) {
    return IntrinsicWidth(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(5, (index) {
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  minRating = index + 1;
                });
                context.read<ItemsCountPerPriceBloc>().add(
                      GetItemsCountPerPriceRange(
                        category: widget.selectedCategory,
                        minRating: index + 1,
                        isFasting: widget.isFasting,
                        query: widget.query,
                        restaurantId: widget.restaurantId,
                      ),
                    );
              },
              child: Icon(
                Icons.star_rounded,
                color: index < minRating
                    ? AppColors.primaryColor
                    : AppColors.grey300,
              ),
            ),
          );
        }),
      ),
    );
  }
}
