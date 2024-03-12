import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/draft_review_request_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/bloc/add_review_to_draft/add_review_to_draft_bloc.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/bloc/nearby_items/nearby_item_bloc.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/bloc/simple_review_stepper/simple_review_stepper_bloc.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/widgets/nearby_item_result.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/widgets/restaurant_name_dotted_border.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/saved_reviews/saved_reviews_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../l10n/gen_l10n/app_localizations.dart';
import '../../../../core/widgets/custom_persistent_bottom_navbar.dart';
import '../../../user_profile/presentation/pages/custom_tab_bar.dart';

class NearByItemSearchPage extends StatefulWidget {
  const NearByItemSearchPage({super.key});

  @override
  State<NearByItemSearchPage> createState() => _NearByItemSearchPageState();
}

class _NearByItemSearchPageState extends State<NearByItemSearchPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose(); // proper cleanup [web:61]
    super.dispose();
  }

  bool getUser() {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      return user != null;
    } on CacheException {
      return false;
    }
  }

  void _onSearchChanged(BuildContext context, String searchQuery) {
    final restaurant = context
        .read<SimpleReviewStepperBloc>()
        .state
        .simpleAddReviewStepperProps
        .restaurant;

    context.read<NearbyItemBloc>().add(
          GetNearbyItemsEvent(
            itemName: searchQuery,
            page: 1,
            restaurantId: restaurant!.id!,
          ),
        );

    context.read<NearByItemPageCubit>().changePage(1);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = SizeConfig.screenHeight;

    return BlocProvider(
      create: (context) => dpLocator<AddReviewToDraftBloc>(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,

        // FIX: Use AppBar.title + AppBar.bottom (instead of flexibleSpace Column),
        // so the AppBar measures itself correctly and won't overflow. [web:39]
        appBar: AppBar(
          automaticallyImplyLeading: false,
          scrolledUnderElevation: 0,
          titleSpacing: 15,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: screenHeight * 0.05,
                width: screenHeight * 0.05,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [...elevation_4],
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => context.pop(),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 20,
                      semanticLabel: "Back",
                    ),
                  ),
                ),
              ),
              SizedBox(width: SizeConfig.screenWidth * 0.06),
              Expanded(
                child: RestaurantNameDottedBorder(
                  title: context
                      .read<SimpleReviewStepperBloc>()
                      .state
                      .simpleAddReviewStepperProps
                      .restaurant!
                      .name!,
                ),
              ),
            ],
          ),
          bottom: PreferredSize(
            // PreferredSize is the correct way to give AppBar.bottom a height. [web:59]
            preferredSize: const Size.fromHeight(110),
            child: SafeArea(
              top: false, // AppBar already handles top inset. [web:62]
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        AppLocalizations.of(context)!.whatAreYouLookingForText,
                        style: GoogleFonts.poppins(
                          fontSize: screenHeight * 0.03,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomTextInputField(
                      hintText: AppLocalizations.of(context)!.typeItemNameText,
                      canRequestFocus: true,
                      fillColor: Colors.white,
                      labelColor: AppColors.grey600,
                      controller: _searchController,
                      onChanged: (q) => _onSearchChanged(context, q),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        body: const NearByItemResult(),

        // FIX: Keep the action button here + SafeArea to avoid bottom inset overflow. [web:62]
        bottomNavigationBar:
            BlocBuilder<SimpleReviewStepperBloc, SimpleReviewStepperState>(
          builder: (context, state) {
            if (state.simpleAddReviewStepperProps.item == null) {
              return const SizedBox.shrink();
            }

            return SafeArea(
              minimum: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: SizedBox(
                height: screenHeight * 0.06,
                width: double.infinity,
                child:
                    BlocConsumer<AddReviewToDraftBloc, AddReviewToDraftState>(
                  listener: (context, draftState) {
                    if (draftState is AddReviewToDraftSuccess) {
                      showCustomToast(
                        context: context,
                        toastMessage:
                            AppLocalizations.of(context)!.savedToDraftText,
                        toastType: ToastType.success,
                      );

                      context.read<SavedReviewsPageCubit>().changePage(1);
                      context
                          .read<SavedReviewsBloc>()
                          .add(GetSavedReviewsEvent());

                      if (getUser()) {
                        context.read<BottomNavigationCubit>().changeIndex(4);
                        context.goNamed(AppRoutes.home);
                      }
                    } else if (draftState is AddReviewToDraftFailure) {
                      showCustomToast(
                        context: context,
                        toastMessage: draftState.message,
                        toastType: ToastType.error,
                      );
                    }
                  },
                  builder: (context, draftState) {
                    final isLoading = draftState is AddReviewToDraftLoading;

                    return FloatingActionButton.extended(
                      backgroundColor: AppColors.primaryColor,
                      onPressed: isLoading
                          ? null
                          : () {
                              final request = context
                                  .read<SimpleReviewStepperBloc>()
                                  .state
                                  .simpleAddReviewStepperProps;

                              context.read<AddReviewToDraftBloc>().add(
                                    AddDraftRequestEvent(
                                      draftReviewRequestModel:
                                          DraftReviewRequestModel(
                                        images: request.images,
                                        videos: request.videos,
                                        itemId: request.item!.id!,
                                        restaurantId: request.restaurant!.id!,
                                      ),
                                    ),
                                  );
                            },
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      label: isLoading
                          ? LoadingAnimationWidget.dotsTriangle(
                              color: Colors.white,
                              size: screenHeight * 0.035,
                            )
                          : Text(
                              AppLocalizations.of(context)!.saveText,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
