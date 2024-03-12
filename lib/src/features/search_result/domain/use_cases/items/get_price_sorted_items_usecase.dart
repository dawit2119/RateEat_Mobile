import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/repositories/item_search_result.dart';

import '../../../../../core/core.dart';
import '../../../presentation/bloc/items_filter_search_result/filter_item_result_params.dart';

class GetPriceSortedItemsUseCase
    extends UseCase<List<ItemModel>, FilterItemResultsParams> {
  final ItemResultRepository itemResultRepository;

  GetPriceSortedItemsUseCase({required this.itemResultRepository});

  @override
  Future<Either<Failure, List<ItemModel>>> call(params) async {
    return await itemResultRepository.getPriceSortedItems(
      filterResultParams: params,
      page: params.page,
      limit: params.limit,
      latitude: params.location.latitude,
      longitude: params.location.longitude,
    );
  }
}
