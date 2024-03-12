// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_map_animations/flutter_map_animations.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:latlong2/latlong.dart' as latLng;
// import 'package:rateeat_mobile/src/features/map_section/presentation/bloc/location_based_restaurants/location_based_restaurants_bloc.dart';

// import '../../../../core/core.dart';
// import '../../../discover/presentation/bloc/discoverySteps/discover_restaurants_event.dart';
// import '../../../features.dart';

// class MapContent extends StatefulWidget {
//   final List<Restaurant> restaurants;

//   const MapContent({
//     super.key,
//     required this.restaurants,
//   });

//   @override
//   State<MapContent> createState() => _MapContentState();
// }

// class _MapContentState extends State<MapContent> with TickerProviderStateMixin {
//   late final _animatedMapController = AnimatedMapController(vsync: this);
//   DistanceCalculator distanceCalculator = DistanceCalculator();

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<UserLocationBloc, UserLocationState>(builder: (context, userLocationState) {
//       if (userLocationState is UserLocationLoaded) {
//         context.read<DiscoveryStepsBloc>().add(
//               DiscoveryFilterUpdate(
//                 latitude: userLocationState.location.latitude,
//                 longitude: userLocationState.location.longitude,
//               ),
//             );
//         context.read<MapZoomBloc>().centerUserLocation();

//         return Container(
//           color: Colors.white,
//           child: Center(
//             child: BlocConsumer<MapZoomBloc, MapZoomState>(listener: (context, zoomState) {
//               _animatedMapController.animatedZoomTo(zoomState.zoomLevel, curve: Curves.easeInOut);
//               _animatedMapController.centerOnPoint(userLocationState.location.toLatLng());
//             }, builder: (context, zoomState) {
//               return FlutterMap(
//                 mapController: _animatedMapController.mapController,
//                 options: MapOptions(
//                   backgroundColor: Colors.white,
//                   keepAlive: true,
//                   // cameraConstraint: CameraConstraint.contain(
//                   //   bounds: LatLngBounds(
//                   //     const LatLng(9.086375076223417, 38.69297819816887),
//                   //     const LatLng(8.941500554449222, 38.86445630746759),
//                   //   ),
//                   // ),
//                   onMapEvent: (p0) {
//                     context.read<DiscoveryStepsBloc>().add(
//                           DiscoveryFilterUpdate(
//                             distanceToTravel: ((distanceCalculator.zoomLevelToDistance(
//                                   zoomLevel: p0.camera.zoom,
//                                 )) /
//                                 4196645.933333333),
//                           ),
//                         );
//                     if (p0.source.index == MapEventSource.tap.index) {
//                       context.read<LocationBasedRestaurantsBloc>().add(
//                             GetRestaurantsCountEvent(
//                               lat: p0.camera.center.latitude,
//                               long: p0.camera.center.longitude,
//                               radius: ((distanceCalculator.zoomLevelToDistance(
//                                         zoomLevel: p0.camera.zoom,
//                                       )) /
//                                       4196645.933333333) /
//                                   2,
//                             ),
//                           );
//                     }
//                   },
//                   onTap: (tapPosition, point) {
//                     if (!context.read<ShowWalkingDistanceTileBloc>().state) {
//                       context.read<UserLocationBloc>().add(
//                             ChangeUserLocation(
//                               newLocation: Location.fromLatLgt(point),
//                             ),
//                           );

//                       // On Change Location Restaurant Count
//                     }
//                     BlocProvider.of<ShowWalkingDistanceTileBloc>(context).hideDialogue();
//                   },
//                   interactionOptions: const InteractionOptions(pinchMoveThreshold: 2),
//                   initialCenter: userLocationState.location.toLatLng(),
//                   initialZoom: 18,
//                 ),
//                 children: [
//                   TileLayer(
//                     urlTemplate:
//                         'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoiYWJlbmkyNyIsImEiOiJjbG5lYjZ5cWQwY2FqMml0Y2FpeXRwbThyIn0.If8Cw8IF0SiAQht9M06gpA',
//                     errorTileCallback: (tile, error, stackTrace) {},
//                   ),
//                   MarkerLayer(
//                     rotate: true,
//                     markers: [
//                       Marker(
//                         height: 60,
//                         width: 100,
//                         point: userLocationState.location.toLatLng(),
//                         child: Column(
//                           children: [
//                             SvgPicture.asset(
//                               "assets/icons/location_solid.svg",
//                               color: Colors.indigo[700],
//                               height: 36,
//                               width: 36,
//                             ),
//                             Text("You're here",
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: subTitleTextStyle.copyWith(
//                                   fontSize: 12,
//                                   color: Colors.indigo.withOpacity(.8),
//                                   fontWeight: FontWeight.w600,
//                                 ))
//                           ],
//                         ),
//                       ),
//                       ...widget.restaurants
//                           .where((restaurant) =>
//                               restaurant.restaurantLocations!.isNotEmpty &&
//                               restaurant.restaurantLocations![0].latitude != null &&
//                               restaurant.restaurantLocations![0].longitude != null)
//                           .map(
//                             (restaurant) => CustomMapMarker(
//                               width: 100,
//                               height: 50,
//                               onTap: () {
//                                 showModalBottomSheet(
//                                   isScrollControlled: true,
//                                   enableDrag: true,
//                                   context: context,
//                                   backgroundColor: Colors.white,
//                                   builder: (context) {
//                                     return RestaurantInfoBottomSheet(
//                                       restaurant: restaurant,
//                                     );
//                                   },
//                                 );
//                               },
//                               point: latLng.LatLng(
//                                 restaurant.restaurantLocations![0].latitude!,
//                                 restaurant.restaurantLocations![0].longitude!,
//                               ),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   SvgPicture.asset(
//                                     "assets/icons/restaurant_pin.svg",
//                                     height: 24,
//                                     width: 24,
//                                     // color: AppColors.primaryColor,
//                                   ),
//                                   if (restaurant.name != null && zoomState.zoomLevel > 16)
//                                     Text(
//                                       restaurant.name!,
//                                       textAlign: TextAlign.center,
//                                       overflow: TextOverflow.ellipsis,
//                                       maxLines: 1,
//                                       style: subTitleTextStyle.copyWith(
//                                         fontSize: zoomState.zoomLevel / 1.4,
//                                         color: AppColors.primaryColor,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                     ],
//                   ),
//                 ],
//               );
//             }),
//           ),
//         );
//       } else {
//         return FailureStateWidget(
//             title: "Location Error",
//             message: "Unalbe to load user location",
//             imagePath: "assets/images/no_location_service.svg",
//             buttonOnPress: () {
//               context.read<UserLocationBloc>().add(const GetUserLocation());
//             });
//       }
//     });
//   }
// }

// class SearchQueryCubit extends Cubit<String> {
//   SearchQueryCubit() : super("Search Location");

//   void updateQuery(String query) {
//     emit(query);
//   }
// }
