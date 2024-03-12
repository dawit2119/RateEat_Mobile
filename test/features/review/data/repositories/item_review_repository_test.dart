import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/datasources/remote_item_review_datasource.dart';
import 'package:rateeat_mobile/src/features/review/data/models/add_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/delete_draft_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/delete_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/draft_to_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/edit_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/item_reviews_response_model.dart';
import 'package:rateeat_mobile/src/features/review/data/repositories/item_review_repository_impl.dart';
import 'package:rateeat_mobile/src/features/review/domain/entities/flag_review.dart';

import 'item_review_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ItemReviewDataSource>(),
])
void main() {
  late ItemReviewRepositoryImpl itemReviewRepositoryImpl;
  late MockItemReviewDataSource mockItemReviewDataSource;

  setUp(() {
    mockItemReviewDataSource = MockItemReviewDataSource();
    itemReviewRepositoryImpl = ItemReviewRepositoryImpl(
      itemReviewSource: mockItemReviewDataSource,
    );
  });

  final testAddItemReviewRequestModel = AddItemReviewRequestModel(
    itemId: 'testItemId',
    rating: 5,
  );

  final testEditItemReviewRequestModel = EditItemReviewRequestModel(
    itemId: 'testItemId',
    reviewId: 'testReviewId',
    rating: 5,
  );

  final testDeleteItemReviewRequestModel = DeleteItemReviewRequestModel(
    itemId: 'testItemId',
    reviewId: 'testReviewId',
  );

  const testFlagReview = FlagReview(
    reviewId: 'testReviewId',
    reportType: '',
    userId: '1',
  );

  final testItemReviewsResponse = ItemReviewsResponseModel(
    reviews: [],
    ratingsCount: [],
    averageRating: 0,
    numberOfReviews: 0,
  );
  final testAddToDraft = DraftToReviewRequestModel(
    itemId: '1',
    draftItemReviewId: 'review',
    rating: 5,
  );
  final testDeleteDraftReviewRequestModel = DeleteDraftItemReviewRequestModel(
    itemId: '1',
    draftItemReviewId: 'draftId',
  );

  group('ItemReviewRepositoryImpl', () {
    group('AddItemReview', () {
      test(
          'should return a string when the call to add Item Review is successful',
          () async {
        // arrange
        when(
          mockItemReviewDataSource.addItemReview(
            addItemReviewRequestModel: testAddItemReviewRequestModel,
            isCandidateItem: false,
          ),
        ).thenAnswer((_) async => true);
        // act
        final result = await itemReviewRepositoryImpl.addItemReview(
          addItemReviewRequestModel: testAddItemReviewRequestModel,
          isCandidateItem: false,
        );
        // assert
        expect(result, const Right(true));
        verify(
          mockItemReviewDataSource.addItemReview(
            addItemReviewRequestModel: testAddItemReviewRequestModel,
            isCandidateItem: false,
          ),
        );
        verifyNoMoreInteractions(mockItemReviewDataSource);
      });

      test('should return a ServerFailure when add item review is unsuccessful',
          () async {
        // arrange
        when(
          mockItemReviewDataSource.addItemReview(
            addItemReviewRequestModel: testAddItemReviewRequestModel,
            isCandidateItem: false,
          ),
        ).thenThrow(ServerException(errorMessage: "Server Error"));
        // act
        final result = await itemReviewRepositoryImpl.addItemReview(
          addItemReviewRequestModel: testAddItemReviewRequestModel,
          isCandidateItem: false,
        );
        // assert
        expect(result, Left(ServerFailure(errorMessage: "Server Error")));
        verify(
          mockItemReviewDataSource.addItemReview(
            addItemReviewRequestModel: testAddItemReviewRequestModel,
            isCandidateItem: false,
          ),
        );
        verifyNoMoreInteractions(mockItemReviewDataSource);
      });
    });

    group('EditItemReview', () {
      test(
          'should return a string when the call to edit Item Review is successful',
          () async {
        // arrange
        when(
          mockItemReviewDataSource.editItemReview(
            editItemReviewRequestModel: testEditItemReviewRequestModel,
          ),
        ).thenAnswer((_) async => 'Review edited successfully');
        // act
        final result = await itemReviewRepositoryImpl.editItemReview(
          editItemReviewRequestModel: testEditItemReviewRequestModel,
        );
        // assert
        expect(result, const Right('Review edited successfully'));
        verify(
          mockItemReviewDataSource.editItemReview(
            editItemReviewRequestModel: testEditItemReviewRequestModel,
          ),
        );
        verifyNoMoreInteractions(mockItemReviewDataSource);
      });

      test(
          'should return a ServerFailure when edit item review is unsuccessful',
          () async {
        // arrange
        when(
          mockItemReviewDataSource.editItemReview(
            editItemReviewRequestModel: testEditItemReviewRequestModel,
          ),
        ).thenThrow(ServerException(errorMessage: "Server Error"));
        // act
        final result = await itemReviewRepositoryImpl.editItemReview(
          editItemReviewRequestModel: testEditItemReviewRequestModel,
        );
        // assert
        expect(result, Left(ServerFailure(errorMessage: "Server Error")));
        verify(
          mockItemReviewDataSource.editItemReview(
            editItemReviewRequestModel: testEditItemReviewRequestModel,
          ),
        );
        verifyNoMoreInteractions(mockItemReviewDataSource);
      });
    });

    group('DeleteItemReview', () {
      test(
          'should return a string when the call to delete Item Review is successful',
          () async {
        // arrange
        when(
          mockItemReviewDataSource.deleteItemReview(
            deleteItemReviewRequestModel: testDeleteItemReviewRequestModel,
          ),
        ).thenAnswer((_) async => 'Review deleted successfully');
        // act
        final result = await itemReviewRepositoryImpl.deleteItemReview(
          deleteItemReviewRequestModel: testDeleteItemReviewRequestModel,
        );
        // assert
        expect(result, const Right('Review deleted successfully'));
        verify(
          mockItemReviewDataSource.deleteItemReview(
            deleteItemReviewRequestModel: testDeleteItemReviewRequestModel,
          ),
        );
        verifyNoMoreInteractions(mockItemReviewDataSource);
      });

      test(
          'should return a ServerFailure when delete item review is unsuccessful',
          () async {
        // arrange
        when(
          mockItemReviewDataSource.deleteItemReview(
            deleteItemReviewRequestModel: testDeleteItemReviewRequestModel,
          ),
        ).thenThrow(ServerException(errorMessage: "Server Error"));
        // act
        final result = await itemReviewRepositoryImpl.deleteItemReview(
          deleteItemReviewRequestModel: testDeleteItemReviewRequestModel,
        );
        // assert
        expect(result, Left(ServerFailure(errorMessage: "Server Error")));
        verify(
          mockItemReviewDataSource.deleteItemReview(
            deleteItemReviewRequestModel: testDeleteItemReviewRequestModel,
          ),
        );
        verifyNoMoreInteractions(mockItemReviewDataSource);
      });
    });

    group('FlagReview', () {
      test('should return a string when the call to flag review is successful',
          () async {
        // arrange
        when(
          mockItemReviewDataSource.flagReview(
            review: testFlagReview,
          ),
        ).thenAnswer((_) async => 'Review flagged successfully');
        // act
        final result = await itemReviewRepositoryImpl.flagReview(
          review: testFlagReview,
        );
        // assert
        expect(result, const Right('Review flagged successfully'));
        verify(
          mockItemReviewDataSource.flagReview(
            review: testFlagReview,
          ),
        );
        verifyNoMoreInteractions(mockItemReviewDataSource);
      });

      test('should return a ServerFailure when flag review is unsuccessful',
          () async {
        // arrange
        when(
          mockItemReviewDataSource.flagReview(
            review: testFlagReview,
          ),
        ).thenThrow(ServerException(errorMessage: "Server Error"));
        // act
        final result = await itemReviewRepositoryImpl.flagReview(
          review: testFlagReview,
        );
        // assert
        expect(result, Left(ServerFailure(errorMessage: "Server Error")));
        verify(
          mockItemReviewDataSource.flagReview(
            review: testFlagReview,
          ),
        );
        verifyNoMoreInteractions(mockItemReviewDataSource);
      });
    });

    group('getItemReviewsByPopularity', () {
      test(
          'should return a ItemReviewsResponse when the call to get item reviews by popularity is successful',
          () async {
        // arrange
        when(
          mockItemReviewDataSource.getItemReviewsByPopularity(
            itemId: 'testItemId',
            limit: 10,
            page: 1,
          ),
        ).thenAnswer((_) async => testItemReviewsResponse);
        // act
        final result =
            await itemReviewRepositoryImpl.getItemReviewsByPopularity(
          itemId: 'testItemId',
          limit: 10,
          page: 1,
        );
        // assert
        expect(result, Right(testItemReviewsResponse));
        verify(
          mockItemReviewDataSource.getItemReviewsByPopularity(
            itemId: 'testItemId',
            limit: 10,
            page: 1,
          ),
        );
        verifyNoMoreInteractions(mockItemReviewDataSource);
      });

      test(
          'should return a ServerFailure when get item reviews by popularity is unsuccessful',
          () async {
        // arrange
        when(
          mockItemReviewDataSource.getItemReviewsByPopularity(
            itemId: 'testItemId',
            limit: 10,
            page: 1,
          ),
        ).thenThrow(ServerException(errorMessage: "Server Error"));
        // act
        final result =
            await itemReviewRepositoryImpl.getItemReviewsByPopularity(
          itemId: 'testItemId',
          limit: 10,
          page: 1,
        );
        // assert
        expect(result, Left(ServerFailure(errorMessage: "Server Error")));
        verify(
          mockItemReviewDataSource.getItemReviewsByPopularity(
            itemId: 'testItemId',
            limit: 10,
            page: 1,
          ),
        );
        verifyNoMoreInteractions(mockItemReviewDataSource);
      });
    });

    group('getItemReviewsByTime', () {
      test(
          'should return a ItemReviewsResponse when the call to get item reviews by time is successful',
          () async {
        // arrange
        when(
          mockItemReviewDataSource.getItemReviewsByTime(
            itemId: 'testItemId',
            limit: 10,
            page: 1,
          ),
        ).thenAnswer((_) async => testItemReviewsResponse);
        // act
        final result = await itemReviewRepositoryImpl.getItemReviewsByTime(
          itemId: 'testItemId',
          limit: 10,
          page: 1,
        );
        // assert
        expect(result, Right(testItemReviewsResponse));
        verify(
          mockItemReviewDataSource.getItemReviewsByTime(
            itemId: 'testItemId',
            limit: 10,
            page: 1,
          ),
        );
        verifyNoMoreInteractions(mockItemReviewDataSource);
      });

      test(
          'should return a ServerFailure when get item reviews by time is unsuccessful',
          () async {
        // arrange
        when(
          mockItemReviewDataSource.getItemReviewsByTime(
            itemId: 'testItemId',
            limit: 10,
            page: 1,
          ),
        ).thenThrow(ServerException(errorMessage: "Server Error"));
        // act
        final result = await itemReviewRepositoryImpl.getItemReviewsByTime(
          itemId: 'testItemId',
          limit: 10,
          page: 1,
        );
        // assert
        expect(result, Left(ServerFailure(errorMessage: "Server Error")));
        verify(
          mockItemReviewDataSource.getItemReviewsByTime(
            itemId: 'testItemId',
            limit: 10,
            page: 1,
          ),
        );
        verifyNoMoreInteractions(mockItemReviewDataSource);
      });
    });

    group('addDraftToReview', () {
      test('should return a string when the call to add to draft is successful',
          () async {
        // arrange
        when(
          mockItemReviewDataSource.addDraftToReview(
            draftToReviewRequestModel: testAddToDraft,
          ),
        ).thenAnswer((_) async => 'Review deleted successfully');
        // act
        final result = await itemReviewRepositoryImpl.addDraftToReview(
          draftToReviewRequestModel: testAddToDraft,
        );
        // assert
        expect(result, const Right('Review deleted successfully'));
        verify(
          mockItemReviewDataSource.addDraftToReview(
            draftToReviewRequestModel: testAddToDraft,
          ),
        );
        verifyNoMoreInteractions(mockItemReviewDataSource);
      });

      test('should return a ServerFailure when add to draft is unsuccessful',
          () async {
        // arrange
        when(
          mockItemReviewDataSource.addDraftToReview(
            draftToReviewRequestModel: testAddToDraft,
          ),
        ).thenThrow(ServerException(errorMessage: "Server Error"));
        // act
        final result = await itemReviewRepositoryImpl.addDraftToReview(
          draftToReviewRequestModel: testAddToDraft,
        );
        // assert
        expect(result, Left(ServerFailure(errorMessage: "Server Error")));
        verify(
          mockItemReviewDataSource.addDraftToReview(
            draftToReviewRequestModel: testAddToDraft,
          ),
        );
        verifyNoMoreInteractions(mockItemReviewDataSource);
      });
    });

    group('deleteDraftItemReview', () {
      test(
          'should return a string when the call to delete draft item review is successful',
          () async {
        // arrange
        when(
          mockItemReviewDataSource.deleteDraftItemReview(
            deleteDraftItemReviewRequestModel:
                testDeleteDraftReviewRequestModel,
          ),
        ).thenAnswer((_) async => 'Review deleted successfully');
        // act
        final result = await itemReviewRepositoryImpl.deleteDraftItemReview(
          deleteDraftItemReviewRequestModel: testDeleteDraftReviewRequestModel,
        );
        // assert
        expect(result, const Right('Review deleted successfully'));
        verify(
          mockItemReviewDataSource.deleteDraftItemReview(
            deleteDraftItemReviewRequestModel:
                testDeleteDraftReviewRequestModel,
          ),
        );
        verifyNoMoreInteractions(mockItemReviewDataSource);
      });

      test(
          'should return a ServerFailure when delete draft item review is unsuccessful',
          () async {
        // arrange
        when(
          mockItemReviewDataSource.deleteDraftItemReview(
            deleteDraftItemReviewRequestModel:
                testDeleteDraftReviewRequestModel,
          ),
        ).thenThrow(ServerException(errorMessage: "Server Error"));
        // act
        final result = await itemReviewRepositoryImpl.deleteDraftItemReview(
          deleteDraftItemReviewRequestModel: testDeleteDraftReviewRequestModel,
        );
        // assert
        expect(result, Left(ServerFailure(errorMessage: "Server Error")));
        verify(
          mockItemReviewDataSource.deleteDraftItemReview(
            deleteDraftItemReviewRequestModel:
                testDeleteDraftReviewRequestModel,
          ),
        );
        verifyNoMoreInteractions(mockItemReviewDataSource);
      });
    });
  });
}
