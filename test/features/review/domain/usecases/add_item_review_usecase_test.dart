import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/review/data/models/add_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/repositories/item_review_repository.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/add_item_review_usecase.dart';

import 'add_item_review_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ItemReviewRepository>(),
])
void main() {
  late AddItemReviewUseCase addItemReviewUseCase;
  late MockItemReviewRepository mockItemReviewRepository;

  setUp(() {
    mockItemReviewRepository = MockItemReviewRepository();
    addItemReviewUseCase =
        AddItemReviewUseCase(repository: mockItemReviewRepository);
  });

  final testAddItemReviewRequestModel = AddItemReviewRequestModel(
    itemId: 'testItemId',
    rating: 5,
  );

  group('AddItemReviewUseCase', () {
    test('should call the repository that adds item review', () async {
      // Arrange
      when(
        mockItemReviewRepository.addItemReview(
          addItemReviewRequestModel: testAddItemReviewRequestModel,
          isCandidateItem: false,
        ),
      ).thenAnswer((_) async => const Right(true));
      // Act
      final result = await addItemReviewUseCase(
        AddItemReviewUseCaseParams(
          addItemReviewRequestModel: testAddItemReviewRequestModel,
          isCandidateItem: false,
        ),
      );

      // Assert
      expect(result, const Right(true));
      verify(
        mockItemReviewRepository.addItemReview(
          addItemReviewRequestModel: testAddItemReviewRequestModel,
          isCandidateItem: false,
        ),
      );
      verifyNoMoreInteractions(mockItemReviewRepository);
    });
  });
}
