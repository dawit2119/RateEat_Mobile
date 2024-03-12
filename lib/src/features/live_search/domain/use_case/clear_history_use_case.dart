import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/live_search/data/data_sources/local_search_history_data_source.dart';
import 'package:rateeat_mobile/src/features/live_search/domain/repository/live_search_repo.dart';

class ClearLocalHistoryUseCase
    extends UseCase<void, ClearLocalHistoryUseCaseParams> {
  final LiveSearchRepository liveSearchRepository;

  ClearLocalHistoryUseCase({
    required this.liveSearchRepository,
  });
  @override
  Future<Either<Failure, void>> call(
      ClearLocalHistoryUseCaseParams params) async {
    return await liveSearchRepository.clearHistory(
      localSearchType: params.localSearchType,
    );
  }
}

class ClearLocalHistoryUseCaseParams extends Equatable {
  final LocalSearchType localSearchType;

  const ClearLocalHistoryUseCaseParams({
    this.localSearchType = LocalSearchType.restaurants,
  });

  @override
  List<Object?> get props => [localSearchType];
}
