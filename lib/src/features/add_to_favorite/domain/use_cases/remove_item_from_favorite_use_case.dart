import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/add_to_favorite/domain/repositories/favorite_repository.dart';
import 'package:rateeat_mobile/src/features/add_to_favorite/domain/use_cases/add_item_to_favorite_use_case.dart';

class RemoveItemFromFavoriteUseCase extends UseCase<bool, ItemFavoriteParams> {
  final FavoriteRepository repository;

  RemoveItemFromFavoriteUseCase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(ItemFavoriteParams params) async {
    return await repository.removeItemFromFavorite(itemId: params.itemId);
  }
}
