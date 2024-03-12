import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/live_search/domain/entities/popular_search_items.dart';
import 'package:rateeat_mobile/src/features/live_search/domain/repository/live_search_repo.dart';

class GetPopularSearchesUseCase
    extends UseCase<PopularSearchItems, GetPopularSearchesParams> {
  final LiveSearchRepository repository;

  GetPopularSearchesUseCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, PopularSearchItems>> call(
      GetPopularSearchesParams params) async {
    return await repository.getPopularSearchItems(
      limit: params.limit,
      page: params.page,
    );
  }
}

class GetPopularSearchesParams extends Equatable {
  final int page;
  final int limit;

  const GetPopularSearchesParams({
    required this.page,
    required this.limit,
  });

  @override
  List<Object?> get props => [page, limit];
}
