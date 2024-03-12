import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/map_section/domain/repositories/location_based_restaurant_repo.dart';
import 'package:rateeat_mobile/src/features/map_section/domain/use_cases/get_location_based_restaurants_usecase.dart';

import 'get_location_based_restaurants_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LocationBasedRestaurantsRepository>(),
])
void main() {
  late LocationBasedRestaurantUseCase locationBasedRestaurantUseCase;
  late MockLocationBasedRestaurantsRepository
      mockLocationBasedRestaurantsRepository;

  setUp(() {
    mockLocationBasedRestaurantsRepository =
        MockLocationBasedRestaurantsRepository();
    locationBasedRestaurantUseCase = LocationBasedRestaurantUseCase(
        repository: mockLocationBasedRestaurantsRepository);
  });

  const params =
      LocationBasedRestaurantParams(lat: 1.0, long: 1.0, radius: 1.0);

  test('should get restaurants based on location', () async {
    // arrange
    when(
      mockLocationBasedRestaurantsRepository.getRestaurantsBasedOnLocation(
          lat: params.lat, long: params.long, radius: params.radius),
    ).thenAnswer(
      (_) async => const Right(1),
    );

    // act
    final result = await locationBasedRestaurantUseCase(params);
    // assert
    expect(result, const Right(1));
    verify(
      mockLocationBasedRestaurantsRepository.getRestaurantsBasedOnLocation(
          lat: params.lat, long: params.long, radius: params.radius),
    );
    verifyNoMoreInteractions(mockLocationBasedRestaurantsRepository);
  });
}
