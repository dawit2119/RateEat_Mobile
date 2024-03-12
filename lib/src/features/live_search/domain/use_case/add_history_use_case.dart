import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/live_search/data/data_sources/local_search_history_data_source.dart';
import 'package:rateeat_mobile/src/features/live_search/data/models/history.dart';
import 'package:rateeat_mobile/src/features/live_search/domain/repository/live_search_repo.dart';

class AddLocalSearchHistoryUseCase
    extends UseCase<void, AddLocalSearchUseCaseParams> {
  final LiveSearchRepository liveSearchRepository;

  AddLocalSearchHistoryUseCase({
    required this.liveSearchRepository,
  });
  @override
  Future<Either<Failure, void>> call(AddLocalSearchUseCaseParams params) async {
    return await liveSearchRepository.addHistory(
      history: params.history,
      localSearchType: params.localSearchType,
    );
  }
}

class AddLocalSearchUseCaseParams extends Equatable {
  final History history;
  final LocalSearchType localSearchType;

  const AddLocalSearchUseCaseParams({
    required this.history,
    this.localSearchType = LocalSearchType.restaurants,
  });

  @override
  List<Object?> get props => [history, localSearchType];
}
