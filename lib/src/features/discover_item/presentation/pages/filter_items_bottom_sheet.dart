// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:go_router/go_router.dart';
// import 'package:rateeat_mobile/src/core/core.dart';
// import 'package:rateeat_mobile/src/features/discover_item/data/search_page/models/search_result.dart';
// import 'package:rateeat_mobile/src/features/discover_item/presentation/filter_page/bloc/filter_items_bloc.dart';
// import 'package:rateeat_mobile/src/features/discover_item/presentation/filter_page/bloc/filter_items_event.dart';
// import 'package:rateeat_mobile/src/features/discover_item/presentation/widgets/filter_app_bar.dart';
// import 'package:rateeat_mobile/src/features/discover_item/presentation/widgets/item_price_chips.dart';
// import 'package:rateeat_mobile/src/features/discover_item/presentation/widgets/restauant_dotted_border.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

// // class FilterItemsPage extends StatefulWidget {
//   final RestaurantResult restaurantResult;
//   final VoidCallback? onClose;
//   final bool? isfasting;
//   final String? sortingvalue;

//   const FilterItemsPage({
//     Key? key,
//     this.onClose,
//     this.isfasting,
//     this.sortingvalue,
//     required this.restaurantResult,
//   }) : super(key: key);

//   @override
//   State<FilterItemsPage> createState() => _FilterItemsPageState();
// }

// class _FilterItemsPageState extends State<FilterItemsPage> {
//   final List<double> prices = [50, 100, 400, 600, 1000, 2000, 5000];
//   double selectedPrice = 100000;
//   bool isselected = false;
//   double finalrating = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//           preferredSize: Size.fromHeight(36.sp),
//           child: FilterAppBar(onTap: () {
//             context.pop();
//           })),
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: EdgeInsets.symmetric(vertical: 18.sp, horizontal: 20.sp),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             RestauantDottedBorder(
//               title: widget.restaurantResult.name,
//             ),
//             verticalPadding(height: 2),
//             const Divider(color: AppColors.grey200),
//             verticalPadding(height: 2),
//             const Text(
//               "Maximum Price",
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//             verticalPadding(height: 2),
//             Center(
//               child: Wrap(
//                 crossAxisAlignment: WrapCrossAlignment.center,
//                 runAlignment: WrapAlignment.center,
//                 children: List.generate(
//                   7,
//                   (index) {
//                     final isCurrentlySelected = prices[index] == selectedPrice;
//                     return Padding(
//                         padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 8.sp),
//                         child: SingleItemChip(
//                           selected: isCurrentlySelected,
//                           title: '${prices[index]} birr',
//                           onTap: () {
//                             setState(() {
//                               if (isCurrentlySelected) {
//                                 // Deselect the chip
//                                 selectedPrice = 0; // Or any other default value
//                               } else {
//                                 // Select the chip
//                                 selectedPrice = prices[index];
//                               }
//                             });
//                           },
//                         ));
//                   },
//                 ),
//               ),
//             ),
//             verticalPadding(height: 2),
//             const Divider(color: AppColors.grey200),
//             verticalPadding(height: 2),
//             Text(
//               "Star Rating",
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16.sp,
//               ),
//             ),
//             verticalPadding(height: 2),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 RatingBar.builder(
//                   initialRating: 0,
//                   minRating: 0,
//                   glowColor: AppColors.grey100,
//                   glowRadius: 0.1,
//                   itemSize: 35,
//                   direction: Axis.horizontal,
//                   allowHalfRating: true,
//                   itemCount: 5,
//                   unratedColor: AppColors.grey200,
//                   updateOnDrag: true,
//                   itemPadding: EdgeInsets.symmetric(horizontal: 0.5.sp),
//                   itemBuilder: (context, _) => const Icon(
//                     Icons.star_rounded,
//                     color: AppColors.primaryColor,
//                   ),
//                   onRatingUpdate: (rating) {
//                     setState(() {
//                       finalrating = rating;
//                     });
//                   },
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
//                   child: (finalrating == 5)
//                       ? Text(
//                           "$finalrating stars",
//                           style: TextStyle(
//                             fontSize: 15.sp,
//                             fontWeight: FontWeight.w600,
//                             color: AppColors.grey500,
//                           ),
//                         )
//                       : Text(
//                           "$finalrating stars & up",
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.grey500,
//                           ),
//                         ),
//                 ),
//               ],
//             ),
//             verticalPadding(height: 2),
//             const Divider(color: AppColors.grey200),
//             verticalPadding(height: 2),
//           ],
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: SizedBox(
//         height: .45.dp,
//         width: 100.w - 24.sp,
//         child: FloatingActionButton(
//           backgroundColor: AppColors.primaryColor,
//           onPressed: () {
//             context.read<FilterItemsBloc>().add(
//                   GetFilteredItemsEvent(
//                     restaurantId: widget.restaurantResult.id,
//                     maxPrice: selectedPrice,
//                     minRating: finalrating,
//                     fasting: widget.isfasting == true,
//                     sortingQuery: widget.sortingvalue.toString(),
//                   ),
//                 );
//           },
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(12.sp)),
//           ),
//           child: Text(
//             "Finish",
//             style: TextStyle(
//               fontSize: 16.sp,
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
