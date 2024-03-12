import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/location_search/domain/usecases/search_location_usecase.dart';

import 'get_location_description_usecase_test.mocks.dart';

void main() {
  late SearchLocationUseCase searchLocationUseCase;
  late MockSearchLocationRepository mockSearchLocationRepository;

  setUp(() {
    mockSearchLocationRepository = MockSearchLocationRepository();
    searchLocationUseCase = SearchLocationUseCase(
      repository: mockSearchLocationRepository,
    );
  });

  const testPlace = 'Addis Ababa';
  const testParam = SearchLocationParams(place: testPlace);
  const testResponse = [
    SearchAutoCompleteModel(
      description: 'Addis Ababa, Ethiopia',
      placeId: 'ChIJQ6Vb0y8JYRcRnZM0v9Uv4YQ',
      name: 'Addis Ababa',
      latitude: '0.1',
      longitude: '0.1',
    )
  ];

  test('should get places suggestions from nominatim API', () async {
    when(mockSearchLocationRepository.getLocations(
      place: testParam.place,
    )).thenAnswer((_) async => const Right(testResponse));

    final result = await searchLocationUseCase(testParam);

    expect(result, const Right(testResponse));
    verify(mockSearchLocationRepository.getLocations(
      place: testParam.place,
    ));
    verifyNoMoreInteractions(mockSearchLocationRepository);
  });
}
