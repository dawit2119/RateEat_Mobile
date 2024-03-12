import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/location_search/domain/usecases/get_location_description_usecase.dart';

import 'get_location_description_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SearchLocationRepository>(),
])
void main() {
  late GetLocationDescriptionUseCase getLocationDescriptionUseCase;
  late MockSearchLocationRepository mockSearchLocationRepository;

  setUp(() {
    mockSearchLocationRepository = MockSearchLocationRepository();
    getLocationDescriptionUseCase = GetLocationDescriptionUseCase(
      searchLocationRepository: mockSearchLocationRepository,
    );
  });

  const locationDescription = 'location description';
  const location = Location(latitude: 1.0, longitude: 1.0);
  test('should get location description from repository', () async {
    when(mockSearchLocationRepository.getLocationDescription(
      latitude: location.latitude,
      longitude: location.longitude,
    )).thenAnswer((_) async => const Right(locationDescription));

    final result = await getLocationDescriptionUseCase(location);

    expect(result, const Right(locationDescription));
    verify(mockSearchLocationRepository.getLocationDescription(
      latitude: location.latitude,
      longitude: location.longitude,
    ));
    verifyNoMoreInteractions(mockSearchLocationRepository);
  });
}
