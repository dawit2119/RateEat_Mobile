import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/location_search/data/models/google_auto_complete_model.dart';
import 'package:rateeat_mobile/src/features/location_search/domain/usecases/google_search_places.dart';
import 'package:rateeat_mobile/src/features/location_search/domain/usecases/search_location_usecase.dart';

import 'get_location_description_usecase_test.mocks.dart';

void main() {
  late GoogleLocationUseCase googleLocationUseCase;
  late MockSearchLocationRepository mockSearchLocationRepository;

  setUp(() {
    mockSearchLocationRepository = MockSearchLocationRepository();
    googleLocationUseCase = GoogleLocationUseCase(
      repository: mockSearchLocationRepository,
    );
  });

  const testPlace = 'Addis Ababa';
  const testParam = SearchLocationParams(place: testPlace);
  const testResponse = [
    GoogleAutoCompleteModel(
      description: 'Addis Ababa, Ethiopia',
      placeId: 'ChIJQ6Vb0y8JYRcRnZM0v9Uv4YQ',
    )
  ];

  test('should get places suggestions from google places API', () async {
    when(mockSearchLocationRepository.getPlaces(
      place: testParam.place,
    )).thenAnswer((_) async => const Right(testResponse));

    final result = await googleLocationUseCase(testParam);

    expect(result, const Right(testResponse));
    verify(mockSearchLocationRepository.getPlaces(
      place: testParam.place,
    ));
    verifyNoMoreInteractions(mockSearchLocationRepository);
  });
}
