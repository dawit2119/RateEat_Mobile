import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/live_search/data/data_sources/local_search_history_data_source.dart';
import 'package:rateeat_mobile/src/features/live_search/domain/repository/live_search_repo.dart';

class DeleteLocalHistoryUseCase
    extends UseCase<void, DeleteHistoryUseCaseParams> {
  final LiveSearchRepository liveSearchRepository;

  DeleteLocalHistoryUseCase({
    required this.liveSearchRepository,
  });
  @override
  Future<Either<Failure, void>> call(DeleteHistoryUseCaseParams params) async {
    return await liveSearchRepository.deleteHistory(
      id: params.id,
      localSearchType: params.localSearchType,
    );
  }
}

class DeleteHistoryUseCaseParams extends Equatable {
  final String id;
  final LocalSearchType localSearchType;

  const DeleteHistoryUseCaseParams({
    required this.id,
    this.localSearchType = LocalSearchType.restaurants,
  });

  @override
  List<Object?> get props => [id, localSearchType];
}
