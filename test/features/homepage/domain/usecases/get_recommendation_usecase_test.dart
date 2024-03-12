import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import 'get_highest_rated_items_usecase_test.mocks.dart';

void main() {
  late GetRestaurantRecommendationsUseCase getRecommendedUseCase;
  late MockHomeRepository mockHomeRepository;

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    getRecommendedUseCase = GetRestaurantRecommendationsUseCase(
      repository: mockHomeRepository,
    );
  });

  const testGetRecommendedItemsParams = GetRecommendedRestaurantsParams(
    page: 1,
    limit: 5,
    latitude: 0,
    longitude: 0,
    tags: [],
  );

  group('GetRecommendedUseCase', () {
    test(
        'should return a list of items when the call to the GetRecommended is successful',
        () async {
      // arrange
      when(
        mockHomeRepository.getRestaurantRecommendations(
            limit: testGetRecommendedItemsParams.limit,
            page: testGetRecommendedItemsParams.page,
            latitude: testGetRecommendedItemsParams.latitude,
            longitude: testGetRecommendedItemsParams.longitude,
            tags: []),
      ).thenAnswer((_) async => Right([
            RecommendedRestaurantModel(
              numberOfReviews: 0,
            )
          ]));
      // act
      final result = await getRecommendedUseCase(
        testGetRecommendedItemsParams,
      );

      final List<RecommendedRestaurantEntity> expectedResponse = [
        RecommendedRestaurantModel(
          numberOfReviews: 0,
        ),
      ];
      late final List<RecommendedRestaurantEntity> resultRight;

      result.fold((l) => null, (r) => resultRight = r);

      // assert
      expect(resultRight, expectedResponse);

      verify(mockHomeRepository.getRestaurantRecommendations(
          limit: testGetRecommendedItemsParams.limit,
          page: testGetRecommendedItemsParams.page,
          latitude: testGetRecommendedItemsParams.latitude,
          longitude: testGetRecommendedItemsParams.longitude,
          tags: []));
      verifyNoMoreInteractions(mockHomeRepository);
    });
  });
}
