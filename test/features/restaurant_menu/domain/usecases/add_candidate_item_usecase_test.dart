import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/error/error.dart';

import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/repositories/restaurant_menu_repository.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/use_cases/add_candidate_item_use_case.dart';

import "add_candidate_item_usecase_test.mocks.dart";

@GenerateNiceMocks([MockSpec<RestaurantMenuRepository>()])
void main() {
  late AddCandidateItemUseCase useCase;
  late MockRestaurantMenuRepository mockRepository;

  setUp(() {
    mockRepository = MockRestaurantMenuRepository();
    useCase = AddCandidateItemUseCase(restaurantMenuRepository: mockRepository);
  });

  final tItemName = 'Test Item';
  final tPrice = '9.99';
  final tMenuId = 'menu123';
  final tCategoryName = 'Test Category';
  final tItemImages = [File('test_image.jpg')];

  final tItem = Item(
    itemId: 'item123',
    itemName: tItemName,
    price: double.parse(tPrice),
    imageUrl: 'test_image_url.jpg',
    numberOfReviews: 0,
  );

  test('should add a candidate item when the repository call is successful',
      () async {
    when(mockRepository.addCandidateItem(
      itemName: tItemName,
      price: tPrice,
      itemImages: tItemImages,
      menuId: tMenuId,
      categoryName: tCategoryName,
    )).thenAnswer((_) async => Right(tItem));

    final result = await useCase(AddCandidateItemUseCaseParams(
      itemName: tItemName,
      price: tPrice,
      itemImages: tItemImages,
      menuId: tMenuId,
      categoryName: tCategoryName,
    ));

    expect(result, Right(tItem));
    verify(mockRepository.addCandidateItem(
      itemName: tItemName,
      price: tPrice,
      itemImages: tItemImages,
      menuId: tMenuId,
      categoryName: tCategoryName,
    ));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return a failure when the repository call is unsuccessful',
      () async {
    final tFailure = ServerFailure(errorMessage: 'Server error');
    when(mockRepository.addCandidateItem(
      itemName: tItemName,
      price: tPrice,
      itemImages: tItemImages,
      menuId: tMenuId,
      categoryName: tCategoryName,
    )).thenAnswer((_) async => Left(tFailure));

    final result = await useCase(AddCandidateItemUseCaseParams(
      itemName: tItemName,
      price: tPrice,
      itemImages: tItemImages,
      menuId: tMenuId,
      categoryName: tCategoryName,
    ));

    expect(result, Left(tFailure));
    verify(mockRepository.addCandidateItem(
      itemName: tItemName,
      price: tPrice,
      itemImages: tItemImages,
      menuId: tMenuId,
      categoryName: tCategoryName,
    ));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should pass an empty list when itemImages is null', () async {
    when(mockRepository.addCandidateItem(
      itemName: tItemName,
      price: tPrice,
      itemImages: [],
      menuId: tMenuId,
      categoryName: tCategoryName,
    )).thenAnswer((_) async => Right(tItem));

    final result = await useCase(AddCandidateItemUseCaseParams(
      itemName: tItemName,
      price: tPrice,
      itemImages: null,
      menuId: tMenuId,
      categoryName: tCategoryName,
    ));

    expect(result, Right(tItem));
    verify(mockRepository.addCandidateItem(
      itemName: tItemName,
      price: tPrice,
      itemImages: [],
      menuId: tMenuId,
      categoryName: tCategoryName,
    ));
    verifyNoMoreInteractions(mockRepository);
  });

  group('AddCandidateItemUseCaseParams', () {
    test('supports value equality', () {
      expect(
        AddCandidateItemUseCaseParams(
          itemName: tItemName,
          price: tPrice,
          itemImages: tItemImages,
          menuId: tMenuId,
          categoryName: tCategoryName,
        ),
        equals(AddCandidateItemUseCaseParams(
          itemName: tItemName,
          price: tPrice,
          itemImages: tItemImages,
          menuId: tMenuId,
          categoryName: tCategoryName,
        )),
      );
    });

    test('props contains all fields', () {
      final params = AddCandidateItemUseCaseParams(
        itemName: tItemName,
        price: tPrice,
        itemImages: tItemImages,
        menuId: tMenuId,
        categoryName: tCategoryName,
      );

      expect(params.props,
          [tItemName, tPrice, tItemImages, tMenuId, tCategoryName]);
    });
  });
}
