import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

class GetLocationDescriptionUseCase extends UseCase<String, Location> {
  final SearchLocationRepository searchLocationRepository;

  GetLocationDescriptionUseCase({required this.searchLocationRepository});
  @override
  Future<Either<Failure, String>> call(Location params) async {
    return await searchLocationRepository.getLocationDescription(
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
}
