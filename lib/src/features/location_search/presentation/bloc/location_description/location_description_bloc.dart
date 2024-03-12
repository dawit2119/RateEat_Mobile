import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/discover/discover.dart';
import 'package:rateeat_mobile/src/features/location_search/domain/usecases/get_location_description_usecase.dart';

class LocationDescriptionBloc
    extends Bloc<LocationDescriptionEvent, LocationDescriptionState> {
  LocationDescriptionBloc({required this.getLocationDescriptionUseCase})
      : super(const LocationDescriptionState(
          locationDescription: '',
        )) {
    on<UpdateLocationDescription>(_onUpdateLocationDescription);
  }
  final GetLocationDescriptionUseCase getLocationDescriptionUseCase;

  void _onUpdateLocationDescription(UpdateLocationDescription event,
      Emitter<LocationDescriptionState> emit) async {
    var response = await getLocationDescriptionUseCase(event.location);
    response.fold(
      (left) => emit(
          LocationDescriptionState(locationDescription: left.errorMessage)),
      (right) => emit(LocationDescriptionState(locationDescription: right)),
    );
  }
}

class LocationDescriptionState extends Equatable {
  final String locationDescription;

  const LocationDescriptionState({required this.locationDescription});
  @override
  List<Object?> get props => [locationDescription];
}

class LocationDescriptionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateLocationDescription extends LocationDescriptionEvent {
  final Location location;

  UpdateLocationDescription({required this.location});
}
