import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/datasources/remote_restaurant_review_datasource.dart';
import 'package:rateeat_mobile/src/features/review/data/models/add_restaurant_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/delete_restaurant_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/edit_restaurant_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/restaurant_reviews_response_model.dart';
import 'package:rateeat_mobile/src/features/review/data/repositories/restaurant_review_repository_impl.dart';

import 'restaurant_review_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<RestaurantReviewDataSource>(),
])
void main() {
  late RestaurantReviewRepositoryImpl restaurantReviewRepositoryImpl;
  late MockRestaurantReviewDataSource mockRestaurantReviewDataSource;

  setUp(() {
    mockRestaurantReviewDataSource = MockRestaurantReviewDataSource();
    restaurantReviewRepositoryImpl = RestaurantReviewRepositoryImpl(
        restaurantReviewSource: mockRestaurantReviewDataSource);
  });

  final testAddRestaurantReviewModel = AddRestaurantReviewRequestModel(
    restaurantId: '1',
    rating: 4,
  );
  final testEditRestaurantReviewModel = EditRestaurantReviewRequestModel(
    restaurantId: '1',
    reviewId: 'review',
    rating: 5,
  );

  final testDeleteRestaurantReviewModel = DeleteRestaurantReviewRequestModel(
    restaurantId: '1',
    reviewId: 'review',
  );

  final testResponse = RestaurantReviewsResponseModel(
    reviews: [],
    ratingsCount: [],
    averageRating: 0,
    numberOfReviews: 0,
  );

  group('RestaurantReviewRepositoryImpl', () {
    group('AddRestaurantReview', () {
      test(
          'should return a string when the call to add restaurant review is successful',
          () async {
        // arrange
        when(
          mockRestaurantReviewDataSource.addRestaurantReview(
            addRestaurantReviewRequestModel: testAddRestaurantReviewModel,
          ),
        ).thenAnswer((_) async => 'Review added successfully');
        // act
        final result = await restaurantReviewRepositoryImpl.addRestaurantReview(
          addRestaurantReviewRequestModel: testAddRestaurantReviewModel,
        );
        // assert
        expect(result, const Right('Review added successfully'));
        verify(
          mockRestaurantReviewDataSource.addRestaurantReview(
            addRestaurantReviewRequestModel: testAddRestaurantReviewModel,
          ),
        );
        verifyNoMoreInteractions(mockRestaurantReviewDataSource);
      });

      test(
          'should return a ServerFailure when the call to add restaurant review is unsuccessful',
          () async {
        // arrange
        when(
          mockRestaurantReviewDataSource.addRestaurantReview(
            addRestaurantReviewRequestModel: testAddRestaurantReviewModel,
          ),
        ).thenThrow(ServerException(errorMessage: 'Server Error'));
        // act
        final result = await restaurantReviewRepositoryImpl.addRestaurantReview(
          addRestaurantReviewRequestModel: testAddRestaurantReviewModel,
        );
        // assert
        expect(result, Left(ServerFailure(errorMessage: 'Server Error')));
        verify(
          mockRestaurantReviewDataSource.addRestaurantReview(
            addRestaurantReviewRequestModel: testAddRestaurantReviewModel,
          ),
        );
        verifyNoMoreInteractions(mockRestaurantReviewDataSource);
      });
    });

    group('EditRestaurantReview', () {
      test(
          'should return a string when the call to edit restaurant review is successful',
          () async {
        // arrange
        when(
          mockRestaurantReviewDataSource.editRestaurantReview(
            editRestaurantReviewRequestModel: testEditRestaurantReviewModel,
          ),
        ).thenAnswer((_) async => 'Review edited successfully');
        // act
        final result =
            await restaurantReviewRepositoryImpl.editRestaurantReview(
          editRestaurantReviewRequestModel: testEditRestaurantReviewModel,
        );
        // assert
        expect(result, const Right('Review edited successfully'));
        verify(
          mockRestaurantReviewDataSource.editRestaurantReview(
            editRestaurantReviewRequestModel: testEditRestaurantReviewModel,
          ),
        );
        verifyNoMoreInteractions(mockRestaurantReviewDataSource);
      });

      test(
          'should return a ServerFailure when the call to edit restaurant review is unsuccessful',
          () async {
        // arrange
        when(
          mockRestaurantReviewDataSource.editRestaurantReview(
            editRestaurantReviewRequestModel: testEditRestaurantReviewModel,
          ),
        ).thenThrow(ServerException(errorMessage: 'Server Error'));
        // act
        final result =
            await restaurantReviewRepositoryImpl.editRestaurantReview(
          editRestaurantReviewRequestModel: testEditRestaurantReviewModel,
        );
        // assert
        expect(result, Left(ServerFailure(errorMessage: 'Server Error')));
        verify(
          mockRestaurantReviewDataSource.editRestaurantReview(
            editRestaurantReviewRequestModel: testEditRestaurantReviewModel,
          ),
        );
        verifyNoMoreInteractions(mockRestaurantReviewDataSource);
      });
    });

    group('DeleteRestaurantReview', () {
      test(
          'should return a string when the call to delete restaurant review is successful',
          () async {
        // arrange
        when(
          mockRestaurantReviewDataSource.deleteRestaurantReview(
            deleteRestaurantReviewRequestModel: testDeleteRestaurantReviewModel,
          ),
        ).thenAnswer((_) async => 'Review deleted successfully');
        // act
        final result =
            await restaurantReviewRepositoryImpl.deleteRestaurantReview(
          deleteRestaurantReviewRequestModel: testDeleteRestaurantReviewModel,
        );
        // assert
        expect(result, const Right('Review deleted successfully'));
        verify(
          mockRestaurantReviewDataSource.deleteRestaurantReview(
            deleteRestaurantReviewRequestModel: testDeleteRestaurantReviewModel,
          ),
        );
        verifyNoMoreInteractions(mockRestaurantReviewDataSource);
      });

      test(
          'should return a ServerFailure when the call to delete restaurant review is unsuccessful',
          () async {
        // arrange
        when(
          mockRestaurantReviewDataSource.deleteRestaurantReview(
            deleteRestaurantReviewRequestModel: testDeleteRestaurantReviewModel,
          ),
        ).thenThrow(ServerException(errorMessage: 'Server Error'));
        // act
        final result =
            await restaurantReviewRepositoryImpl.deleteRestaurantReview(
          deleteRestaurantReviewRequestModel: testDeleteRestaurantReviewModel,
        );
        // assert
        expect(result, Left(ServerFailure(errorMessage: 'Server Error')));
        verify(
          mockRestaurantReviewDataSource.deleteRestaurantReview(
            deleteRestaurantReviewRequestModel: testDeleteRestaurantReviewModel,
          ),
        );
        verifyNoMoreInteractions(mockRestaurantReviewDataSource);
      });
    });

    group('GetRestaurantReviewsByTime', () {
      test(
          'should return a RestaurantReviewsResponse when the call to get restaurant reviews by time is successful',
          () async {
        // arrange
        when(
          mockRestaurantReviewDataSource.getAllRestaurantReviewsByTime(
            restaurantId: '1',
            limit: 10,
            page: 1,
          ),
        ).thenAnswer((_) async => testResponse);
        // act
        final result =
            await restaurantReviewRepositoryImpl.getRestaurantReviewsByTime(
          restaurantId: '1',
          limit: 10,
          page: 1,
        );
        // assert
        expect(result, Right(testResponse));
        verify(
          mockRestaurantReviewDataSource.getAllRestaurantReviewsByTime(
            restaurantId: '1',
            limit: 10,
            page: 1,
          ),
        );
        verifyNoMoreInteractions(mockRestaurantReviewDataSource);
      });

      test(
          'should return a ServerFailure when the call to get restaurant reviews by time is unsuccessful',
          () async {
        // arrange
        when(
          mockRestaurantReviewDataSource.getAllRestaurantReviewsByTime(
            restaurantId: '1',
            limit: 10,
            page: 1,
          ),
        ).thenThrow(ServerException(errorMessage: "Server Error"));
        // act
        final result =
            await restaurantReviewRepositoryImpl.getRestaurantReviewsByTime(
          restaurantId: '1',
          limit: 10,
          page: 1,
        );
        // assert
        expect(result, Left(ServerFailure(errorMessage: "Server Error")));
        verify(
          mockRestaurantReviewDataSource.getAllRestaurantReviewsByTime(
            restaurantId: '1',
            limit: 10,
            page: 1,
          ),
        );
        verifyNoMoreInteractions(mockRestaurantReviewDataSource);
      });
    });

    group('GetRestaurantReviewsByPopularity', () {
      test(
          'should return a RestaurantReviewsResponse when the call to get restaurant reviews by popularity is successful',
          () async {
        // arrange
        when(
          mockRestaurantReviewDataSource.getAllRestaurantReviewsByPopularity(
            restaurantId: '1',
            limit: 10,
            page: 1,
          ),
        ).thenAnswer((_) async => testResponse);
        // act
        final result = await restaurantReviewRepositoryImpl
            .getRestaurantReviewsByPopularity(
          restaurantId: '1',
          limit: 10,
          page: 1,
        );
        // assert
        expect(result, Right(testResponse));
        verify(
          mockRestaurantReviewDataSource.getAllRestaurantReviewsByPopularity(
            restaurantId: '1',
            limit: 10,
            page: 1,
          ),
        );
        verifyNoMoreInteractions(mockRestaurantReviewDataSource);
      });

      test(
          'should return a ServerFailure when the call to get restaurant reviews by popularity is unsuccessful',
          () async {
        // arrange
        when(
          mockRestaurantReviewDataSource.getAllRestaurantReviewsByPopularity(
            restaurantId: '1',
            limit: 10,
            page: 1,
          ),
        ).thenThrow(ServerException(errorMessage: "Server Error"));
        // act
        final result = await restaurantReviewRepositoryImpl
            .getRestaurantReviewsByPopularity(
          restaurantId: '1',
          limit: 10,
          page: 1,
        );
        // assert
        expect(result, Left(ServerFailure(errorMessage: "Server Error")));
        verify(
          mockRestaurantReviewDataSource.getAllRestaurantReviewsByPopularity(
            restaurantId: '1',
            limit: 10,
            page: 1,
          ),
        );
        verifyNoMoreInteractions(mockRestaurantReviewDataSource);
      });
    });
  });
}
