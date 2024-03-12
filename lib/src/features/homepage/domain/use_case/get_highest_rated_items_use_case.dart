import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/popular_items_response.dart';

class GetPopularUseCase
    extends UseCase<PopularItemsResponse, GetPopularItemsParams> {
  final HomeRepository repository;

  GetPopularUseCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, PopularItemsResponse>> call(
      GetPopularItemsParams params) async {
    return await repository.getTopRatedItems(
      limit: params.limit,
      page: params.page,
      lat: params.lat,
      lng: params.lng,
      tags: params.tags,
      isFasting: params.isFasting,
    );
  }
}

class GetPopularItemsParams extends Equatable {
  final int page;
  final int limit;
  final List<String> tags;
  final double? lat;
  final double? lng;
  final bool? isFasting;

  const GetPopularItemsParams({
    required this.page,
    required this.limit,
    required this.tags,
    this.lat,
    this.lng,
    this.isFasting,
  });

  @override
  List<Object?> get props => [page, limit, tags];
}
