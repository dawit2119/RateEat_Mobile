import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/discover/presentation/bloc/discoverySteps/discover_bloc.dart';

class FetchDiscoverRestaurantResultEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchNewDiscoverRestaurantResultEvent
    extends FetchDiscoverRestaurantResultEvent {
  final DiscoveryStepsBloc discoveryStepsBloc;

  FetchNewDiscoverRestaurantResultEvent({
    required this.discoveryStepsBloc,
  });

  @override
  List<Object?> get props => [discoveryStepsBloc];
}

class LoadMoreDiscoverRestaurantResultEvent
    extends FetchDiscoverRestaurantResultEvent {
  final DiscoveryStepsBloc discoveryStepsBloc;

  LoadMoreDiscoverRestaurantResultEvent({
    required this.discoveryStepsBloc,
  });

  @override
  List<Object?> get props => [discoveryStepsBloc];
}
