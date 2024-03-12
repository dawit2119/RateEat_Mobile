import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import '../../../homepage/domain/entities/item.dart';
import '../repository/live_search_repo.dart';

class LiveSearchItemsUseCase
    extends UseCase<List<Item>, LiveSearchItemsUseCaseParams> {
  final LiveSearchRepository liveSearchRepository;

  LiveSearchItemsUseCase({
    required this.liveSearchRepository,
  });

  @override
  Future<Either<Failure, List<Item>>> call(params) async {
    return await liveSearchRepository.searchItems(
      params.searchTerm,
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
}

class LiveSearchItemsUseCaseParams extends Equatable {
  final String searchTerm;
  final double latitude;
  final double longitude;

  const LiveSearchItemsUseCaseParams({
    required this.searchTerm,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [searchTerm, latitude, longitude];
}
