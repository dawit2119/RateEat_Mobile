import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/bloc/nearby_restaurant/nearby_restaurant_bloc.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/widgets/nearby_restaurant_result.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../l10n/gen_l10n/app_localizations.dart';
import '../../../discover/discover.dart';

class NearByRestaurantSearchPage extends StatelessWidget {
  const NearByRestaurantSearchPage({super.key});

  @override
  Widget build(context) {
    double screenHeight = SizeConfig.screenHeight;
    return BlocConsumer<UserLocationBloc, UserLocationState>(
      listener: (context, userLocationState) {
        if (userLocationState is UserLocationError) {}
      },
      builder: (context, locationState) {
        if (locationState is UserLocationLoading) {
          return Scaffold(
            body: Center(
              child: LoadingAnimationWidget.dotsTriangle(
                color: AppColors.primaryColor,
                size: screenHeight * 0.04,
              ),
            ),
          );
        }
        if (locationState is UserLocationError) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(screenHeight * 0.07),
              child: AppBar(
                automaticallyImplyLeading: false,
                scrolledUnderElevation: 0,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: screenHeight * 0.05,
                            width: screenHeight * 0.05,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [...elevation_4],
                                borderRadius: BorderRadius.circular(10)),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                context.pop();
                              },
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
                        ],
                      ),
                    ],
                  ),
                ),
                centerTitle: true,
              ),
            ),
            body: Center(
              child: SizedBox(
                height: 80.h,
                child: ErrorAndInfoDisplayWidget(
                  assetImage: "assets/images/no_location_service.svg",
                  title:
                      AppLocalizations.of(context)!.unableToGetUserLocationText,
                  description:
                      AppLocalizations.of(context)!.locationPermissionText,
                  onPressed: () {
                    context
                        .read<UserLocationBloc>()
                        .add(const GetUserLocation());
                  },
                ),
              ),
            ),
          );
        }
        if (locationState is UserLocationLoaded) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(screenHeight * 0.25),
              child: AppBar(
                automaticallyImplyLeading: false,
                scrolledUnderElevation: 0,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: screenHeight * 0.05,
                            width: screenHeight * 0.05,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [...elevation_4],
                                shape: BoxShape.circle),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                context.pop();
                              },
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
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      //* where  are you
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          AppLocalizations.of(context)!.whereAreYouAtText,
                          style: GoogleFonts.poppins(
                            fontSize: screenHeight * 0.03,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      CustomTextInputField(
                        hintText:
                            AppLocalizations.of(context)!.typeRestaurantText,
                        canRequestFocus: true,
                        fillColor: Colors.white,
                        labelColor: AppColors.grey600,
                        controller: TextEditingController(),
                        onChanged: (searchQuery) {
                          context.read<NearByRestaurantBloc>().add(
                                GetNearbyRestaurantEvent(
                                  searchQuery: searchQuery,
                                  latitude: locationState.location.latitude,
                                  longitude: locationState.location.longitude,
                                  radius: 10000,
                                  page: 1,
                                ),
                              );
                          context
                              .read<NearByRestaurantPageCubit>()
                              .changePage(1);
                        },
                      ),
                    ],
                  ),
                ),
                centerTitle: true,
              ),
            ),
            body: const NearByRestaurants(),
          );
        }
        return Container();
      },
    );
  }
}
