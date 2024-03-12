import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/live_search/data/data_sources/local_search_history_data_source.dart';
import 'package:rateeat_mobile/src/features/live_search/domain/repository/live_search_repo.dart';

import '../../data/models/history.dart';

class GetLocalHistoryUseCase
    extends UseCase<List<History>, GetHistoryUseCaseParams> {
  final LiveSearchRepository liveSearchRepository;

  GetLocalHistoryUseCase({
    required this.liveSearchRepository,
  });
  @override
  Future<Either<Failure, List<History>>> call(
      GetHistoryUseCaseParams params) async {
    return await liveSearchRepository.getHistoryList(
      localSearchType: params.localSearchType,
    );
  }
}

class GetHistoryUseCaseParams extends Equatable {
  final LocalSearchType localSearchType;

  const GetHistoryUseCaseParams({
    this.localSearchType = LocalSearchType.restaurants,
  });

  @override
  List<Object?> get props => [localSearchType];
}
