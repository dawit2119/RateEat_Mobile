import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/hive/local_user_model.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/review/data/datasources/remote_item_review_datasource.dart';
import 'package:rateeat_mobile/src/features/review/data/models/add_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/delete_draft_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/delete_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/draft_to_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/edit_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/item_reviews_response_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/entities/flag_review.dart';

import 'remote_item_review_datasource_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Dio>(),
  MockSpec<AuthenticationLocalSource>(),
])
Future<void> main() async {
  late ItemReviewDataSourceImpl dataSource;
  late MockDio mockDio;
  late MockAuthenticationLocalSource mockAuthSource;
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  setUp(() async {
    mockDio = MockDio();
    mockAuthSource = MockAuthenticationLocalSource();
    dataSource = ItemReviewDataSourceImpl(dio: mockDio);
    await dpLocator.reset();
    dpLocator.registerSingleton<AuthenticationLocalSource>(mockAuthSource);
  });

  group('addItemReview', () {
    test('should return true when the API call is successful', () async {
      // Arrange
      final requestModel = AddItemReviewRequestModel(
        rating: 5,
        comment: 'Great item!',
        itemId: 'item123',
      );
      when(mockAuthSource.getUserCredential())
          .thenReturn(LocalUserModel(token: 'valid_token'));
      when(mockDio.post(any,
              options: anyNamed('options'), data: anyNamed('data')))
          .thenAnswer((_) async => Response(
              statusCode: 201,
              data: {'message': 'Success'},
              requestOptions: RequestOptions(path: '')));

      // Act
      final result = await dataSource.addItemReview(
          addItemReviewRequestModel: requestModel, isCandidateItem: false);

      // Assert
      expect(result, true);
    });

    test('should throw ServerException on API error', () async {
      // Arrange
      final requestModel = AddItemReviewRequestModel(
        rating: 5,
        comment: 'Great item!',
        itemId: 'item123',
      );
      when(mockAuthSource.getUserCredential())
          .thenReturn(LocalUserModel(token: 'valid_token'));
      when(mockDio.post(any,
              options: anyNamed('options'), data: anyNamed('data')))
          .thenAnswer((_) async => Response(
              statusCode: 400,
              data: {'message': 'Error'},
              requestOptions: RequestOptions(path: '')));

      // Act
      final call = dataSource.addItemReview(
          addItemReviewRequestModel: requestModel, isCandidateItem: false);

      // Assert
      expect(call, throwsA(isA<ServerException>()));
    });
  });

  group('editItemReview', () {
    test('should return success message when the API call is successful',
        () async {
      // Arrange
      final requestModel = EditItemReviewRequestModel(
        itemId: 'item123',
        reviewId: 'review123',
        rating: 4,
        comment: 'Updated comment',
      );
      when(mockAuthSource.getUserCredential())
          .thenReturn(LocalUserModel(token: 'valid_token'));
      when(mockDio.put(any,
              options: anyNamed('options'), data: anyNamed('data')))
          .thenAnswer((_) async => Response(
              statusCode: 200,
              data: {'message': 'Updated successfully'},
              requestOptions: RequestOptions(path: '')));

      // Act
      final result = await dataSource.editItemReview(
          editItemReviewRequestModel: requestModel);

      // Assert
      expect(result, 'Updated successfully');
    });
  });

  group('deleteItemReview', () {
    test('should return success message when the review is deleted', () async {
      // Arrange
      final requestModel = DeleteItemReviewRequestModel(
          itemId: 'item123', reviewId: 'review123');
      when(mockAuthSource.getUserCredential())
          .thenReturn(LocalUserModel(token: 'valid_token'));
      when(mockDio.delete(any, options: anyNamed('options'))).thenAnswer(
          (_) async => Response(
              statusCode: 200,
              data: {'message': 'Deleted successfully'},
              requestOptions: RequestOptions(path: '')));

      // Act
      final result = await dataSource.deleteItemReview(
          deleteItemReviewRequestModel: requestModel);

      // Assert
      expect(result, 'Deleted successfully');
    });
  });

  group('getItemReviewsByPopularity', () {
    test(
        'should return ItemReviewsResponseModel when the API call is successful',
        () async {
      // Arrange
      final itemId = 'item123';
      final limit = 10;
      final page = 1;
      when(mockAuthSource.getUserCredential())
          .thenReturn(LocalUserModel(token: 'valid_token'));
      when(mockDio.get(any, options: anyNamed('options')))
          .thenAnswer((_) async => Response(
              statusCode: 200,
              data: {
                'data': {
                  'restaurantReviews': [],
                  'ratingCount': <String, dynamic>{},
                  'avgRating': 0.0,
                  'numReviews': 0,
                }
              },
              requestOptions: RequestOptions(path: '')));

      // Act
      final result = await dataSource.getItemReviewsByPopularity(
          itemId: itemId, limit: limit, page: page);

      // Assert
      expect(result, isA<ItemReviewsResponseModel>());
    });

    test('should throw ServerException on API error', () async {
      // Arrange
      final itemId = 'item123';
      final limit = 10;
      final page = 1;
      when(mockAuthSource.getUserCredential())
          .thenReturn(LocalUserModel(token: 'valid_token'));
      when(mockDio.get(any, options: anyNamed('options'))).thenAnswer(
          (_) async => Response(
              statusCode: 400,
              data: {'message': 'Error'},
              requestOptions: RequestOptions(path: '')));

      // Act
      final call = dataSource.getItemReviewsByPopularity(
          itemId: itemId, limit: limit, page: page);

      // Assert
      expect(call, throwsA(isA<ServerException>()));
    });
  });

  group('getItemReviewsByTime', () {
    test(
        'should return ItemReviewsResponseModel when the API call is successful',
        () async {
      // Arrange
      final itemId = 'item123';
      final limit = 10;
      final page = 1;
      when(mockAuthSource.getUserCredential())
          .thenReturn(LocalUserModel(token: 'valid_token'));
      when(mockDio.get(any, options: anyNamed('options')))
          .thenAnswer((_) async => Response(
              statusCode: 200,
              data: {
                'data': {
                  'restaurantReviews': [],
                  'ratingCount': <String, dynamic>{},
                  'avgRating': 0.0,
                  'numReviews': 0,
                }
              },
              requestOptions: RequestOptions(path: '')));

      // Act
      final result = await dataSource.getItemReviewsByTime(
          itemId: itemId, limit: limit, page: page);

      // Assert
      expect(result, isA<ItemReviewsResponseModel>());
    });

    test('should throw ServerException on API error', () async {
      // Arrange
      final itemId = 'item123';
      final limit = 10;
      final page = 1;
      when(mockAuthSource.getUserCredential())
          .thenReturn(LocalUserModel(token: 'valid_token'));
      when(mockDio.get(any, options: anyNamed('options'))).thenAnswer(
          (_) async => Response(
              statusCode: 400,
              data: {'message': 'Error'},
              requestOptions: RequestOptions(path: '')));

      // Act
      final call = dataSource.getItemReviewsByTime(
          itemId: itemId, limit: limit, page: page);

      // Assert
      expect(call, throwsA(isA<ServerException>()));
    });
  });

  group('addDraftToReview', () {
    test('should return success message when the API call is successful',
        () async {
      // Arrange
      final draftToReviewRequestModel = DraftToReviewRequestModel(
        rating: 5,
        comment: 'Great draft review!',
        draftItemReviewId: 'draft123',
        itemId: 'item123',
      );
      when(mockAuthSource.getUserCredential())
          .thenReturn(LocalUserModel(token: 'valid_token'));
      when(mockDio.post(any,
              options: anyNamed('options'), data: anyNamed('data')))
          .thenAnswer((_) async => Response(
              statusCode: 201,
              data: {'message': 'Draft added successfully'},
              requestOptions: RequestOptions(path: '')));

      // Act
      final result = await dataSource.addDraftToReview(
          draftToReviewRequestModel: draftToReviewRequestModel);

      // Assert
      expect(result, 'Draft added successfully');
    });

    test('should throw ServerException on API error', () async {
      // Arrange
      final draftToReviewRequestModel = DraftToReviewRequestModel(
        rating: 5,
        comment: 'Great draft review!',
        draftItemReviewId: 'draft123',
        itemId: 'item123',
      );
      when(mockAuthSource.getUserCredential())
          .thenReturn(LocalUserModel(token: 'valid_token'));
      when(mockDio.post(any,
              options: anyNamed('options'), data: anyNamed('data')))
          .thenAnswer((_) async => Response(
              statusCode: 400,
              data: {'message': 'Error'},
              requestOptions: RequestOptions(path: '')));

      // Act
      final call = dataSource.addDraftToReview(
          draftToReviewRequestModel: draftToReviewRequestModel);

      // Assert
      expect(call, throwsA(isA<ServerException>()));
    });
  });

  group('deleteDraftItemReview', () {
    test('should return success message when the draft review is deleted',
        () async {
      // Arrange
      final deleteDraftRequestModel = DeleteDraftItemReviewRequestModel(
          draftItemReviewId: 'draft123', itemId: 'item123');
      when(mockAuthSource.getUserCredential())
          .thenReturn(LocalUserModel(token: 'valid_token'));
      when(mockDio.delete(any, options: anyNamed('options'))).thenAnswer(
          (_) async => Response(
              statusCode: 200,
              data: {'message': 'Successfully Deleted'},
              requestOptions: RequestOptions(path: '')));

      // Act
      final result = await dataSource.deleteDraftItemReview(
          deleteDraftItemReviewRequestModel: deleteDraftRequestModel);

      // Assert
      expect(result, 'Successfully Deleted');
    });

    test('should throw ServerException on API error', () async {
      // Arrange
      final deleteDraftRequestModel = DeleteDraftItemReviewRequestModel(
          draftItemReviewId: 'draft123', itemId: 'item123');
      when(mockAuthSource.getUserCredential())
          .thenReturn(LocalUserModel(token: 'valid_token'));
      when(mockDio.delete(any, options: anyNamed('options'))).thenAnswer(
          (_) async => Response(
              statusCode: 400,
              data: {'message': 'Error'},
              requestOptions: RequestOptions(path: '')));

      // Act
      final call = dataSource.deleteDraftItemReview(
          deleteDraftItemReviewRequestModel: deleteDraftRequestModel);

      // Assert
      expect(call, throwsA(isA<ServerException>()));
    });
  });

  group('flagReview', () {
    test('should return success message when the review is flagged', () async {
      // Arrange
      final review = FlagReview(
        userId: "1",
        reviewId: 'review123',
        reportType: 'innapropriate content',
      );
      when(mockAuthSource.getUserCredential())
          .thenReturn(LocalUserModel(token: 'valid_token'));
      when(mockDio.post(any,
              options: anyNamed('options'), data: anyNamed('data')))
          .thenAnswer((_) async => Response(
              statusCode: 201,
              data: {'message': 'Review flagged successfully'},
              requestOptions: RequestOptions(path: '')));

      // Act
      final result = await dataSource.flagReview(review: review);

      // Assert
      expect(result, 'review accepted');
    });

    test('should throw ServerException on API error', () async {
      // Arrange
      final review = FlagReview(
        userId: "1",
        reviewId: 'review123',
        reportType: 'innapropriate content',
      );
      when(mockAuthSource.getUserCredential())
          .thenReturn(LocalUserModel(token: 'valid_token'));
      when(mockDio.post(any,
              options: anyNamed('options'), data: anyNamed('data')))
          .thenAnswer((_) async => Response(
              statusCode: 400,
              data: {'message': 'Error'},
              requestOptions: RequestOptions(path: '')));

      // Act
      final call = dataSource.flagReview(review: review);

      // Assert
      expect(call, throwsA(isA<ServerException>()));
    });
  });
}
