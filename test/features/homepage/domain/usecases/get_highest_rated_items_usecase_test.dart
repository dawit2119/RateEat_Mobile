import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/popular_items_response.dart';

import 'get_highest_rated_items_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<HomeRepository>(),
])
void main() {
  late GetPopularUseCase getPopularUseCase;
  late MockHomeRepository mockHomeRepository;

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    getPopularUseCase = GetPopularUseCase(
      repository: mockHomeRepository,
    );
  });

  final testGetPopularItemsParams = GetPopularItemsParams(
    page: 1,
    limit: 5,
    lat: 0,
    lng: 0,
    tags: ['tag'],
  );

  final items = [
    Item(
      itemId: '1',
      itemName: 'name',
      description: 'description',
      imageUrl: 'imageUrl',
      numberOfReviews: 0,
    )
  ];

  group('GetHighestRatedUseCase', () {
    test(
        'should return a list of items when the call to the GetHighestRated is successful',
        () async {
      // arrange
      when(
        mockHomeRepository.getTopRatedItems(
          limit: testGetPopularItemsParams.limit,
          page: testGetPopularItemsParams.page,
          lat: testGetPopularItemsParams.lat,
          lng: testGetPopularItemsParams.lng,
          tags: testGetPopularItemsParams.tags,
        ),
      ).thenAnswer((_) async =>
          Right(PopularItemsResponse(items: items, totalItems: items.length)));
      // act
      final result = await getPopularUseCase(
        testGetPopularItemsParams,
      );
      // assert
      expect(result,
          Right(PopularItemsResponse(items: items, totalItems: items.length)));
      verify(
        mockHomeRepository.getTopRatedItems(
          limit: testGetPopularItemsParams.limit,
          page: testGetPopularItemsParams.page,
          lat: testGetPopularItemsParams.lat,
          lng: testGetPopularItemsParams.lng,
          tags: testGetPopularItemsParams.tags,
        ),
      );
      verifyNoMoreInteractions(mockHomeRepository);
    });
  });
}
