import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/repositories/item_search_result.dart';

import '../../../../../core/core.dart';
import '../../../presentation/bloc/items_filter_search_result/filter_item_result_params.dart';

class GetMostPopularItemsUseCase
    extends UseCase<List<ItemModel>, FilterItemResultsParams> {
  final ItemResultRepository itemResultRepository;

  GetMostPopularItemsUseCase({required this.itemResultRepository});

  @override
  Future<Either<Failure, List<ItemModel>>> call(params) async {
    return await itemResultRepository.getMostPopularItems(
      filterResultParams: params,
      page: params.page,
      limit: params.limit,
      latitude: params.location.latitude,
      longitude: params.location.longitude,
    );
  }
}
