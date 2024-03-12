import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';
import 'package:rateeat_mobile/src/features/discover/data/models/location_model.dart';
import 'package:rateeat_mobile/src/features/discover/domain/entities/location.dart';
import 'package:rateeat_mobile/src/features/discover/domain/repositories/discover_repo.dart';

import '../../../../core/use_case/use_case.dart';

class GetLocationUseCase extends UseCase<Location, NoParams> {
  final DiscoverRepo discoverRepo;

  GetLocationUseCase({required this.discoverRepo});

  @override
  Future<Either<Failure, LocationModel>> call(NoParams params) async {
    return await discoverRepo.getLocation();
  }
}
