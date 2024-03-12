import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/use_cases/add_candidate_item_use_case.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/bloc/candidate_item/candidate_item_bloc.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/bloc/candidate_item/candidate_item_event.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/bloc/candidate_item/candidate_item_state.dart';

import 'candidate_item_bloc_test.mocks.dart';

@GenerateMocks([AddCandidateItemUseCase])
void main() {
  late CandidateItemBloc candidateItemBloc;
  late MockAddCandidateItemUseCase mockAddCandidateItemUseCase;

  setUp(() {
    mockAddCandidateItemUseCase = MockAddCandidateItemUseCase();
    candidateItemBloc = CandidateItemBloc(
      addCandidateItemUseCase: mockAddCandidateItemUseCase,
    );
  });

  tearDown(() {
    candidateItemBloc.close();
  });

  final testItem = Item(
    itemId: 'item123',
    itemName: 'Test Item',
    price: 10.99,
    description: 'Test description',
    numberOfReviews: 0,
  );

  final testImages = [File('test_image.jpg')];
  const testMenuId = 'menu123';
  const testCategoryName = 'Test Category';

  group('CandidateItemBloc', () {
    test('initial state should be AddCandidateItemInitial', () {
      expect(candidateItemBloc.state, isA<AddCandidateItemInitial>());
    });

    blocTest<CandidateItemBloc, CandidateItemState>(
      'emits [AddCandidateItemLoading, CandidateItemAdded] when AddCandidateItemEvent is added and use case succeeds',
      build: () {
        when(mockAddCandidateItemUseCase(any))
            .thenAnswer((_) async => Right(testItem));
        return candidateItemBloc;
      },
      act: (bloc) => bloc.add(AddCandidateItemEvent(
        itemName: testItem.itemName,
        price: testItem.price ?? 0.0,
        itemImages: testImages,
        menuId: testMenuId,
        categoryName: testCategoryName,
      )),
      expect: () => [
        isA<AddCandidateItemLoading>(),
        isA<CandidateItemAdded>(),
      ],
      verify: (_) {
        verify(mockAddCandidateItemUseCase(AddCandidateItemUseCaseParams(
          itemName: testItem.itemName,
          price: testItem.price.toString(),
          itemImages: testImages,
          menuId: testMenuId,
          categoryName: testCategoryName,
        ))).called(1);
      },
    );

    blocTest<CandidateItemBloc, CandidateItemState>(
      'emits [AddCandidateItemLoading, CandidateItemAddFailed] when AddCandidateItemEvent is added and use case fails',
      build: () {
        when(mockAddCandidateItemUseCase(any)).thenAnswer(
            (_) async => Left(ServerFailure(errorMessage: 'Error')));
        return candidateItemBloc;
      },
      act: (bloc) => bloc.add(AddCandidateItemEvent(
        itemName: testItem.itemName,
        price: testItem.price ?? 0.0,
        itemImages: testImages,
        menuId: testMenuId,
        categoryName: testCategoryName,
      )),
      expect: () => [
        isA<AddCandidateItemLoading>(),
        isA<CandidateItemAddFailed>(),
      ],
    );
  });
}
