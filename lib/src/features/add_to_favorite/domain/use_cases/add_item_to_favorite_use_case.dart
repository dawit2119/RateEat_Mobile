import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/add_to_favorite/domain/repositories/favorite_repository.dart';

class AddItemToFavoriteUseCase extends UseCase<bool, ItemFavoriteParams> {
  final FavoriteRepository repository;

  AddItemToFavoriteUseCase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(ItemFavoriteParams params) async {
    return await repository.addItemToFavorite(itemId: params.itemId);
  }
}

class ItemFavoriteParams extends Equatable {
  final String itemId;
  const ItemFavoriteParams({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}
