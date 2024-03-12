import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/item_detail/domain/domain.dart';

import '../../../homepage/domain/entities/item.dart';

class GetItemUseCase extends UseCase<Item, String> {
  final ItemRepository itemRepository;
  GetItemUseCase({required this.itemRepository});

  @override
  Future<Either<Failure, Item>> call(params) async {
    return await itemRepository.getItem(itemId: params);
  }
}
