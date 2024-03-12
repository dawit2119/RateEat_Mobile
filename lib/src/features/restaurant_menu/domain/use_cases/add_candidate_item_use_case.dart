import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import '../../../homepage/domain/entities/item.dart';
import '../repositories/restaurant_menu_repository.dart';

class AddCandidateItemUseCase
    extends UseCase<Item, AddCandidateItemUseCaseParams> {
  final RestaurantMenuRepository restaurantMenuRepository;

  AddCandidateItemUseCase({
    required this.restaurantMenuRepository,
  });
  @override
  Future<Either<Failure, Item>> call(params) async {
    return await restaurantMenuRepository.addCandidateItem(
      itemName: params.itemName,
      price: params.price,
      itemImages: params.itemImages ?? [],
      menuId: params.menuId,
      categoryName: params.categoryName,
    );
  }
}

class AddCandidateItemUseCaseParams extends Equatable {
  final String itemName;
  final String price;
  final List<File>? itemImages;
  final String menuId;
  final String categoryName;

  const AddCandidateItemUseCaseParams({
    required this.itemName,
    required this.price,
    required this.itemImages,
    required this.menuId,
    required this.categoryName,
  });

  @override
  List<Object> get props =>
      [itemName, price, itemImages ?? [], menuId, categoryName];
}
