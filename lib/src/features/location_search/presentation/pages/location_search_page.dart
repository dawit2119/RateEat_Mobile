import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/features/discover/presentation/bloc/discoverySteps/discover_restaurants_event.dart';
import 'package:rateeat_mobile/src/features/location_search/data/models/google_auto_complete_model.dart';

import 'package:rateeat_mobile/src/features/location_search/presentation/bloc/location_description/location_description_bloc.dart';

import '../../../../core/core.dart';
import '../../../features.dart';
import '../../../map_section/presentation/widgets/google_map_content.dart';

class LocationSearchPage extends StatefulWidget {
  const LocationSearchPage({super.key});

  @override
  State<LocationSearchPage> createState() => _LocationSearchPageState();
}

class _LocationSearchPageState extends State<LocationSearchPage> {
  List<GoogleAutoCompleteModel> locations = [];
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocListener<AutoCompleteBloc, AutoCompleteState>(
        listener: (context, state) {
          if (state is SearchLocationState &&
              state.status == SearchStatus.error) {
            showCustomToast(
              context: context,
              toastMessage:
                  state.errorMessage ?? "Error searching for location",
              toastType: ToastType.error,
            );
          }
        },
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: screenHeight * 0.015, left: screenWidth * 0.04),
                child: Row(
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

                    //* Location Title
                    Expanded(
                        child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.selectLocationText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: SizeConfig.screenHeight * 0.021,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
                  ],
                ),
              ),

              SizedBox(
                height: screenHeight * 0.03,
              ),
              // Search Bar
              BlocBuilder<SearchQueryCubit, String>(
                builder: (context, state) {
                  return Container(
                    alignment: Alignment.center,
                    width: screenWidth * 0.8,
                    height: screenHeight * 0.07,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CustomTextInputField(
                      controller: searchController,
                      autoFocus: true,
                      canRequestFocus: true,
                      onChanged: (value) {
                        context.read<SearchQueryCubit>().updateQuery(value);
                        if (value.isEmpty) {
                          context.read<AutoCompleteBloc>().add(
                                TriggerInitialEvent(),
                              );
                        } else {
                          context.read<AutoCompleteBloc>().add(
                                GetPlacesEvent(
                                  place: value,
                                ),
                              );
                        }
                      },
                      hintText:
                          AppLocalizations.of(context)!.searchLocationText,
                      showTrailing:
                          state != "" && state != "Search for a place",
                      onCancelled: () {
                        searchController.text = "";
                        context
                            .read<SearchQueryCubit>()
                            .updateQuery("Search for a place");
                        context.read<AutoCompleteBloc>().add(
                              TriggerInitialEvent(),
                            );
                      },
                    ),
                  );
                },
              ),

              SizedBox(
                height: screenHeight * 0.03,
              ),
              // Search Results
              BlocBuilder<AutoCompleteBloc, AutoCompleteState>(
                builder: (context, state) {
                  if (state is SearchPlacesState &&
                      state.status == SearchStatus.loading) {
                    return Center(
                      child: Column(
                        children: [
                          LoadingAnimationWidget.dotsTriangle(
                            key: Key("search_state_loading_widget"),
                            color: AppColors.primaryColor,
                            size: screenHeight * 0.04,
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            AppLocalizations.of(context)!.searchLocationText,
                            style: TextStyle(
                              fontSize: screenHeight * 0.013,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                    );
                  } else if (state is SearchPlacesState &&
                      state.status == SearchStatus.loaded) {
                    locations = state.searchAutocomplete ?? [];
                    return locations.isEmpty
                        ? ErrorAndInfoDisplayWidget(
                            assetImage: 'assets/icons/no_content.svg',
                            title: AppLocalizations.of(context)!.noResultText,
                            description:
                                AppLocalizations.of(context)!.searchNoText,
                            onPressed: null,
                          )
                        : SizedBox(
                            height: screenHeight * 0.6,
                            width: screenWidth * 0.8,
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: locations.length,
                              itemBuilder: (_, index) {
                                return Column(
                                  children: [
                                    LocationTile(
                                      location: locations[index],
                                      onPress: () async {
                                        final location = locations[index];

                                        try {
                                          final coordinates = await dpLocator<
                                                  SearchLocationRemoteSource>()
                                              .getPlaceCoordinates(
                                                  placeId: location.placeId);

                                          final latitude = coordinates.latitude;
                                          final longitude =
                                              coordinates.longitude;
                                          if (context.mounted) {
                                            context
                                                .read<DiscoveryStepsBloc>()
                                                .add(
                                                  DiscoveryFilterUpdate(
                                                    latitude: latitude,
                                                    longitude: longitude,
                                                  ),
                                                );
                                          }

                                          // Update Query
                                          dpLocator<SearchQueryCubit>()
                                              .updateQuery(
                                                  location.description);
                                          if (context.mounted) {
                                            //Change camera position
                                            //* Move the camera to user location
                                            context
                                                .read<MapZoomBloc>()
                                                .centerUserLocation(
                                                  location: Location(
                                                    latitude: latitude,
                                                    longitude: longitude,
                                                  ),
                                                );

                                            context.pop();
                                            //Fetch nearby restaurants
                                            final zoomState = context
                                                .read<MapZoomBloc>()
                                                .state;
                                            //* Get Restaurant Based on the selected Location

                                            context
                                                .read<AllRestaurantsBloc>()
                                                .add(
                                                  GetAllRestaurants(
                                                    latitude: latitude,
                                                    longitude: longitude,
                                                    radius: ((DistanceCalculator()
                                                                .zoomLevelToDistance(
                                                              zoomLevel:
                                                                  zoomState
                                                                      .zoomLevel,
                                                            ) /
                                                            4196645.933333333) /
                                                        2),
                                                  ),
                                                );
                                            context
                                                .read<UserLocationBloc>()
                                                .add(
                                                  ChangeUserLocation(
                                                    newLocation: Location(
                                                      latitude: latitude,
                                                      longitude: longitude,
                                                    ),
                                                  ),
                                                );
                                            context
                                                .read<LocationDescriptionBloc>()
                                                .add(
                                                  UpdateLocationDescription(
                                                    location: Location(
                                                      latitude: latitude,
                                                      longitude: longitude,
                                                    ),
                                                  ),
                                                );
                                          }
                                        } catch (e) {
                                          final couldNtGetCoordinatesTex =
                                              // ignore: use_build_context_synchronously
                                              AppLocalizations.of(context)!
                                                  .couldNtGetCoordinatesText;
                                          if (context.mounted) {
                                            showCustomToast(
                                              context: context,
                                              toastMessage:
                                                  couldNtGetCoordinatesTex,
                                              toastType: ToastType.error,
                                            );
                                          }
                                        }
                                      },
                                    ),
                                    // const Divider(
                                    //   thickness: 1,
                                    //   color: AppColors.grey200,
                                    // ),
                                  ],
                                );
                              },
                            ),
                          );
                  }
                  return Column(
                    children: [
                      ErrorAndInfoDisplayWidget(
                        assetImage: 'assets/icons/write_something.svg',
                        title: AppLocalizations.of(context)!.searchStartText,
                        description:
                            AppLocalizations.of(context)!.searchDescText,
                        onPressed: null,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
